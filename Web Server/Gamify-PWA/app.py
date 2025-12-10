import os
import sqlite3
import traceback
from flask import Flask, render_template, request, jsonify, send_from_directory

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(
    __name__,
    template_folder=basedir,
    static_folder=os.path.join(basedir, 'static')
)

# --- database helpers: initialize from schema and connection factory ---
def init_db_from_schema(db_path, schema_path):
    """
    Create database file and run schema SQL if the games table is missing.
    """
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    # If DB doesn't exist, create it and run schema
    need_schema = False
    if not os.path.exists(db_path):
        need_schema = True
    else:
        # check whether 'games' table exists
        try:
            conn = sqlite3.connect(db_path)
            cur = conn.cursor()
            cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='games'")
            if cur.fetchone() is None:
                need_schema = True
            conn.close()
        except Exception:
            need_schema = True

    if need_schema:
        if not os.path.exists(schema_path):
            print(f"[DB INIT] schema.sql not found at {schema_path!r}, cannot initialize DB schema.")
            return
        try:
            conn = sqlite3.connect(db_path)
            with open(schema_path, 'r', encoding='utf-8') as f:
                sql_script = f.read()
            conn.executescript(sql_script)
            conn.commit()
            conn.close()
            print(f"[DB INIT] Initialized database from schema: {schema_path}")
        except Exception as e:
            print(f"[DB INIT] Error initializing DB from schema: {e}")
            traceback.print_exc()


def get_db_connection():
    """Return a sqlite3 connection to the project's gamify.db with Row factory."""
    db_path = os.path.join(basedir, 'static', 'db', 'gamify.db')
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    return conn

# initialize DB using schema.sql if needed
_db_dir = os.path.join(basedir, 'static', 'db')
_db_path = os.path.join(_db_dir, 'gamify.db')
_schema_path = os.path.join(_db_dir, 'schema.sql')
init_db_from_schema(_db_path, _schema_path)

# --- new helper: search DB safely and return list of dicts ---
def search_games(q, limit=100):
    """Case-insensitive search across available columns in the games table.
    Falls back to client-side filtering if the SQL search fails or columns differ.
    """
    if not q:
        return []
    q = q.strip()
    pattern = f"%{q.lower()}%"
    db_path = os.path.join(basedir, 'static', 'db', 'gamify.db')
    results = []
    conn = None
    try:
        conn = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
        cur = conn.cursor()

        # discover table columns
        cur.execute("PRAGMA table_info(games)")
        cols_info = cur.fetchall()
        cols = [row['name'] for row in cols_info] if cols_info else []
        print(f"[DEBUG] search_games: db_path={db_path!r}, found_columns={cols}")

        # preferred searchable columns (try variants)
        preferred = ['name', 'title', 'genre', 'developer', 'short_desc', 'description', 'short_description']
        search_cols = [c for c in preferred if c in cols]

        if not search_cols:
            # if nothing matched, try any text-like columns from table (fallback)
            search_cols = [c for c in cols if c.lower() not in ('id',)]

        if not search_cols:
            print("[DEBUG] search_games: no searchable columns found in 'games' table.")
            return []

        # build SQL using LOWER(...) to make it case-insensitive
        where = " OR ".join([f"LOWER({c}) LIKE ?" for c in search_cols])
        # try to select a common output set but tolerate missing columns with COALESCE
        select_cols = []
        if 'id' in cols: select_cols.append('id')
        if 'name' in cols: select_cols.append('name')
        elif 'title' in cols: select_cols.append('title AS name')
        if 'genre' in cols: select_cols.append('genre')
        if 'developer' in cols: select_cols.append('developer')
        if 'short_desc' in cols:
            select_cols.append('short_desc AS description')
        elif 'description' in cols:
            select_cols.append('description')
        if 'thumbnail' in cols:
            select_cols.append('thumbnail')

        select_sql = ", ".join(select_cols) if select_cols else '*'
        sql = f"SELECT {select_sql} FROM games WHERE {where} LIMIT ?"
        params = [pattern] * len(search_cols) + [limit]
        print(f"[DEBUG] search_games SQL: {sql} params_len={len(params)}")
        cur.execute(sql, params)
        rows = cur.fetchall()
        for r in rows:
            results.append({k: r[k] for k in r.keys()})
        print(f"[DEBUG] search_games: returned {len(results)} rows")
        return results

    except Exception as exc:
        print("[ERROR] search_games exception:", exc)
        traceback.print_exc()
        # fallback to Python-side filtering if possible
        try:
            if conn is None:
                conn = sqlite3.connect(db_path)
                conn.row_factory = sqlite3.Row
            cur = conn.cursor()
            cur.execute("SELECT * FROM games")
            qlow = q.lower()
            for r in cur.fetchall():
                row = {k: r[k] for k in r.keys()}
                for v in row.values():
                    if isinstance(v, str) and qlow in v.lower():
                        results.append(row)
                        break
                if len(results) >= limit:
                    break
            print(f"[DEBUG] search_games (fallback) returned {len(results)} rows")
        except Exception as exc2:
            print("[ERROR] fallback search failed:", exc2)
            traceback.print_exc()
        return results
    finally:
        if conn:
            conn.close()

# new helper to debug DB on startup
def debug_db():
    db_path = os.path.join(basedir, 'static', 'db', 'gamify.db')
    print(f"[DB DEBUG] db_path = {db_path!r}")
    print(f"[DB DEBUG] exists = {os.path.exists(db_path)}")
    if os.path.exists(db_path):
        try:
            st = os.stat(db_path)
            print(f"[DB DEBUG] size = {st.st_size} bytes")
            conn = sqlite3.connect(db_path)
            conn.row_factory = sqlite3.Row
            cur = conn.cursor()
            # list tables
            cur.execute("SELECT name FROM sqlite_master WHERE type='table'")
            tables = [r[0] for r in cur.fetchall()]
            print(f"[DB DEBUG] tables = {tables}")
            if 'games' in tables:
                cur.execute("PRAGMA table_info(games)")
                cols = [r['name'] for r in cur.fetchall()]
                print(f"[DB DEBUG] games table columns = {cols}")
                try:
                    cur.execute("SELECT COUNT(*) as cnt FROM games")
                    cnt = cur.fetchone()['cnt']
                    print(f"[DB DEBUG] games row count = {cnt}")
                except Exception as e:
                    print("[DB DEBUG] could not count rows in games:", e)
            conn.close()
        except Exception as e:
            print("[DB DEBUG] error inspecting DB:", e)

# Serve manifest & service worker from project root
@app.route('/manifest.json')
def manifest():
    return send_from_directory(basedir, 'manifest.json')

@app.route('/sw.js')
def service_worker():
    return send_from_directory(basedir, 'sw.js')

# Pages
@app.route('/')
def index():
    return render_template('index.html')

# Home now accepts optional ?q= search and passes results to template
@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/search')
def search():
    q = request.args.get('q', '').strip()
    games = []
    if q:
        games = search_games(q)
        print(f"[SEARCH] q={q!r} -> {len(games)} results")
    return render_template('search.html', query=q, games=games)

# JSON search API (for AJAX)
@app.route('/search')
def api_search():
    q = request.args.get('q', '').strip()
    games = search_games(q) if q else []
    print(f"[API SEARCH] q={q!r} -> {len(games)} results")   # debug log
    return jsonify({'query': q, 'count': len(games), 'results': games})

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/signup')
def signup():
    return render_template('signup.html')

@app.route('/profile')
def profile():
    return render_template('profile.html')

# Example API
@app.route('/api/games', methods=['GET'])
def get_games():
    try:
        db_path = os.path.join(basedir, 'static', 'db', 'gamify.db')
        conn = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
        c = conn.cursor()
        c.execute("SELECT * FROM games LIMIT 50")
        rows = [dict(r) for r in c.fetchall()]
        conn.close()
        return jsonify(rows)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# SPA fallback -> index
@app.errorhandler(404)
def not_found(e):
    return render_template('index.html'), 404

if __name__ == '__main__':
    debug_db()    # print DB diagnostics at startup
    print("Templates folder:", app.template_folder)
    print("Static folder:", app.static_folder)
    app.run(debug=True, port=5000)