import os
import sqlite3
import traceback
import datetime
from functools import wraps
from flask import Flask, render_template, request, jsonify, send_from_directory, session, redirect, url_for
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(
    __name__,
    template_folder=basedir,
    static_folder=os.path.join(basedir, 'static')
)
app.secret_key = os.urandom(24)

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('logged_in'):
            return redirect('/login')
        return f(*args, **kwargs)
    return decorated_function

@app.template_filter('format_datetime')
def format_datetime(value):
    try:
        return datetime.strptime(value, "%Y-%m-%d %H:%M").strftime("%d-%m-%Y %H:%M")
    except Exception:
        return value

def init_db_from_schema(db_path, schema_path):
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    need_schema = not os.path.exists(db_path)
    if not need_schema:
        try:
            connection = sqlite3.connect(db_path)
            cursor = connection.cursor()
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='games'")
            if cursor.fetchone() is None:
                need_schema = True
            connection.close()
        except Exception:
            need_schema = True

    if need_schema:
        if not os.path.exists(schema_path):
            print(f"[DB INIT] schema.sql not found at {schema_path!r}, skipping auto-init.")
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
    db_path = os.path.join(basedir, 'gamify.db')
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    return conn

_db_path = os.path.join(basedir, 'gamify.db')
_schema_path = os.path.join(basedir, 'static', 'db', 'schema.sql')
init_db_from_schema(_db_path, _schema_path)

def search_games(q, limit=100):
    if not q:
        return []
    q = q.strip()
    pattern = f"%{q.lower()}%"
    db_path = os.path.join(basedir, 'gamify.db')
    results = []
    connection = None
    try:
        connection = sqlite3.connect(db_path)
        connection.row_factory = sqlite3.Row
        cursor = connection.cursor()

        # Search in gameName, genre, gameDev, gameDesc (prioritise gameName first)
        sql = """
            SELECT gameID, gameName, gameDev, genre, gameDesc, ageRating, logo, banner, trailer, patchNotes, sysReqs
            FROM games
            WHERE LOWER(gameName) LIKE ?
               OR LOWER(genre) LIKE ?
               OR LOWER(gameDev) LIKE ?
               OR LOWER(gameDesc) LIKE ?
            LIMIT ?
        """
        params = [pattern, pattern, pattern, pattern, limit]
        print(f"[DEBUG] search_games SQL: {sql[:80]}... params={params[:3]}...")
        cursor.execute(sql, params)
        rows = cursor.fetchall()
        for r in rows:
            results.append({k: r[k] for k in r.keys()})
        print(f"[DEBUG] search_games: found {len(results)} rows for q={q!r}")
        return results

    except Exception as exc:
        print("[ERROR] search_games exception:", exc)
        traceback.print_exc()
        return []
    finally:
        if connection:
            connection.close()

def debug_db():
    db_path = os.path.join(basedir, 'gamify.db')
    print(f"[DB DEBUG] db_path = {db_path!r}")
    print(f"[DB DEBUG] exists = {os.path.exists(db_path)}")
    if os.path.exists(db_path):
        try:
            st = os.stat(db_path)
            print(f"[DB DEBUG] size = {st.st_size} bytes")
            connection = sqlite3.connect(db_path)
            connection.row_factory = sqlite3.Row
            cursor = connection.cursor()
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
            tables = [r[0] for r in cursor.fetchall()]
            print(f"[DB DEBUG] tables = {tables}")
            if 'games' in tables:
                cursor.execute("PRAGMA table_info(games)")
                cols = [r['name'] for r in cursor.fetchall()]
                print(f"[DB DEBUG] games columns = {cols}")
                try:
                    cursor.execute("SELECT COUNT(*) as cnt FROM games")
                    cnt = cursor.fetchone()['cnt']
                    print(f"[DB DEBUG] games row count = {cnt}")
                except Exception as e:
                    print("[DB DEBUG] could not count rows:", e)
            connection.close()
        except Exception as e:
            print("[DB DEBUG] error inspecting DB:", e)
            traceback.print_exc()

# User Authentication (Login/Signup)
@app.route('/login_validation', methods=['POST'])
def login_validation():
    email = request.form.get('email')
    password = request.form.get('password')
    
    connection = sqlite3.connect(os.path.join(basedir, 'gamify.db'))
    cursor = connection.cursor()

    user = cursor.execute("SELECT userID, userName, userPassword FROM users WHERE userEmail=?", (email,)).fetchone()
    
    connection.close()
    
    if user and check_password_hash(user[2], password):
        session['user_id'] = user[0]
        session['user_name'] = user[1]
        session['user_email'] = email
        session['logged_in'] = True
        
        return jsonify({
            "success": True,
            "message": "Login successful!"
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": "Invalid credentials!"
        }), 401

@app.route('/add_user', methods=['POST'])
def add_user():
    email = request.form.get('email')
    username = request.form.get('username')
    password = request.form.get('password')
    
    connection = sqlite3.connect(os.path.join(basedir, 'gamify.db'))
    cursor = connection.cursor()

    existing = cursor.execute("SELECT 1 FROM users WHERE userEmail=?", (email,)).fetchone()

    if existing:
        connection.close()
        return jsonify({
            "success": False,
            "title": "Account Exists",
            "message": "An account with this email already exists. Please login instead."
        }), 409
    
    hashed_password = generate_password_hash(password)
    
    cursor.execute("INSERT INTO users (userEmail, userName, userPassword) VALUES (?, ?, ?)", (email, username, hashed_password))
    connection.commit()
    connection.close()
    
    return jsonify({
        "success": True,
        "title": "Signup Successful",
        "message": "Your account has been created successfully. Please login."
    }), 201

# Serve manifest & service worker from project root
@app.route('/manifest.json')
def manifest():
    return send_from_directory('static', 'manifest.json', mimetype='application/manifest+json')

@app.route('/sw.js')
def service_worker():
    return send_from_directory('static', 'sw.js')

# Pages
@app.route('/')
def index():
    return render_template('index.html')

def get_games_by_genre(limit_per_genre=10):
    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT gameID, gameName, genre, banner FROM games ORDER BY genre, gameName")
    
    rows = cursor.fetchall()
    connection.close()

    categories = {}

    for row in rows:
        genre = row["genre"]
        if genre not in categories:
            categories[genre] = []
        if len(categories[genre]) < limit_per_genre:
            categories[genre].append(dict(row))

    return categories

@app.route('/home')
def home():
    q = request.args.get('q', '').strip()
    if q:
        games = search_games(q)
        return render_template(
            'home.html',
            query=q,
            games=games
        )

    categories = get_games_by_genre()

    return render_template(
        'home.html',
        query='',
        categories=categories
    )
    
@app.route('/game/<int:game_id>')
@login_required
def game_detail(game_id):
    connection = get_db_connection()
    cursor = connection.cursor()

    game = cursor.execute("SELECT gameID, gameName, gameDev, genre, gameDesc, ageRating, logo, banner, trailer, patchNotes, sysReqs FROM games WHERE gameID = ?", (game_id,)).fetchone()

    rating = cursor.execute("SELECT COUNT(*) as reviewCount, ROUND(AVG(revRating), 1) as avgRating FROM reviews WHERE gameID = ?", (game_id,)).fetchone()
    
    connection.close()
    
    if not game:
        return "Game not found", 404

    return render_template('game_detail.html', game=dict(game), rating=dict(rating))

@app.route('/game/<int:game_id>/reviews')
@login_required
def game_reviews(game_id):
    connection = get_db_connection()
    cursor = connection.cursor()

    game = cursor.execute("SELECT gameID, gameName FROM games WHERE gameID = ?", (game_id,)).fetchone()
    if not game:
        connection.close()
        return "Game not found", 404
    reviews = cursor.execute("SELECT r.revID, r.userID, r.revTitle, u.userName, r.revDate, r.revDescription, r.revRating FROM reviews r JOIN users u ON r.userID = u.userID WHERE r.gameID = ? ORDER BY r. revDate DESC", (game_id,)).fetchall()

    connection.close()
    return render_template('game_reviews.html', reviews=[dict(r) for r in reviews], game=dict(game), current_user_id=session.get('user_id'))

@app.route('/submit_review/<int:game_id>', methods=['POST'])
@login_required
def submit_review(game_id):
    title = request.form.get('revTitle')
    rating = request.form.get('revRating')
    description = request.form.get('revDescription')

    if not all([title, rating, description]):
        return "Invalid review data", 400
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    user_id = session.get('user_id')

    cursor.execute("INSERT INTO reviews (gameID, userID, revTitle, revRating, revDescription) VALUES (?, ?, ?, ?, ?)", (game_id, user_id, title, rating, description))
    connection.commit()
    connection.close()

    return redirect(url_for('game_reviews', game_id=game_id))

@app.route('/review/<int:rev_id>/edit', methods=['GET', 'POST'])
@login_required
def edit_review(rev_id):
    connection = get_db_connection()
    cursor = connection.cursor()

    review = cursor.execute("SELECT revID, gameID, userID, revTitle, revRating, revDescription FROM reviews WHERE revID = ?", (rev_id,)).fetchone()
    game = cursor.execute("SELECT gameID, gameName FROM games WHERE gameID = ?", (review['gameID'],)).fetchone()
    
    if not review or review['userID'] != session['user_id']:
        connection.close()
        return "Forbidden", 403

    if request.method == 'POST':
        title = request.form['revTitle']
        rating = request.form['revRating']
        desc = request.form['revDescription']

        cursor.execute("UPDATE reviews SET revTitle = ?, revRating = ?, revDescription = ? WHERE revID = ?", (title, rating, desc, rev_id))

        connection.commit()
        connection.close()

        return redirect(url_for('game_reviews', game_id=review['gameID']))

    connection.close()
    return render_template('edit_review.html', review=dict(review), game=dict(game))

@app.route('/review/delete/<int:rev_id>', methods=['POST'])
@login_required
def delete_review(rev_id):
    connection = get_db_connection()
    cursor = connection.cursor()

    review = cursor.execute("SELECT userID, gameID FROM reviews WHERE revID = ?",(rev_id,)).fetchone()

    if not review or review['userID'] != session['user_id']:
        connection.close()
        return "Forbidden", 403

    cursor.execute("DELETE FROM reviews WHERE revID = ?", (rev_id,))
    connection.commit()
    connection.close()

    return redirect(url_for('game_reviews', game_id=review['gameID']))

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/login')

@app.route('/signup')
def signup():
    return render_template('signup.html')

@app.route('/profile')
@login_required
def profile():
    user_id = session.get('user_id')
    connection = get_db_connection()
    user = connection.execute('SELECT userName, userEmail, userBio, userPfp, userSettings FROM users WHERE userID = ?', (user_id,)).fetchone()
    connection.close()
    
    if user:
        return render_template('profile.html', user=user)
    else:
        return redirect(url_for('login'))
    
UPLOAD_FOLDER = 'static/uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload-avatar', methods=['POST'])
@login_required
def upload_avatar():
    user_id = session.get('user_id')
    file = request.files.get('avatar')

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        file.save(filepath)

        # Update avatar in the database
        connection = get_db_connection()
        connection.execute('UPDATE users SET userPfp = ? WHERE userID = ?', (filepath, user_id))
        connection.commit()
        connection.close()

        return redirect(url_for('profile'))
    
    return 'Invalid file type', 400

@app.route('/save-bio', methods=['POST'])
@login_required
def save_bio():
    user_id = session.get('user_id')
    bio = request.json.get('bio')
    
    connection = get_db_connection()
    connection.execute('UPDATE users SET userBio = ? WHERE userID = ?', (bio, user_id))
    connection.commit()
    connection.close()
    
    return jsonify({'status': 'success'}), 200

@app.route('/update-profile', methods=['POST'])
@login_required
def update_profile():
    user_id = session.get('user_id')
    username = request.form.get('username')
    email = request.form.get('email')

    connection = get_db_connection()
    connection.execute('UPDATE users SET userName = ?, userEmail = ? WHERE userID = ?', (username, email, user_id))
    connection.commit()
    connection.close()

    session['user_name'] = username
    session['user_email'] = email
    
    return redirect(url_for('profile'))

@app.route('/add_to_library/<int:game_id>', methods=['POST'])
@login_required
def add_to_library(game_id):
    user_id = session.get('user_id')

    connection = get_db_connection()
    cursor = connection.cursor()
    existing_game = cursor.execute("SELECT * FROM user_library WHERE userID = ? AND gameID = ?", (user_id, game_id)).fetchone()

    if existing_game:
        connection.close()
        return redirect(url_for('library'))
    
    # Insert the game into the user library
    cursor.execute("INSERT INTO user_library (userID, gameID) VALUES (?, ?)", (user_id, game_id))
    connection.commit()
    connection.close()

    return redirect(url_for('library'))

@app.route('/library')
@login_required
def library():
    user_id = session.get('user_id')
    connection = get_db_connection()
    cursor = connection.cursor()

    games = cursor.execute("SELECT g.gameID, g.gameName, g.banner FROM games g JOIN user_library ul ON g.gameID = ul.gameID WHERE ul.userID = ?", (user_id,)).fetchall()

    connection.close()

    return render_template('library.html', games=[dict(g) for g in games])

@app.route('/offline.html')
def offline():
    return render_template('offline.html')

@app.after_request
def add_pwa_headers(response):
    response.headers['Service-Worker-Allowed'] = '/'
    return response

@app.route('/api/games', methods=['GET'])
def get_games():
    try:
        conn = get_db_connection()
        c = conn.cursor()
        c.execute("SELECT * FROM games LIMIT 50")
        rows = [dict(r) for r in c.fetchall()]
        conn.close()
        return jsonify(rows)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/debug/games')
def debug_games():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM games LIMIT 10")
        rows = [dict(r) for r in cursor.fetchall()]
        connection.close()
        return jsonify({
            'sample_count': len(rows),
            'sample_games': rows,
            'columns': list(rows[0].keys()) if rows else []
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/schema')
def api_schema():
    """Return the actual games table schema."""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("PRAGMA table_info(games)")
        cols = [{'name': r['name'], 'type': r['type']} for r in cursor.fetchall()]
        conn.close()
        return jsonify({'columns': cols})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# SPA fallback -> index
@app.errorhandler(404)
def not_found(e):
    return render_template('index.html'), 404

if __name__ == '__main__':
    debug_db()
    print("Templates folder:", app.template_folder)
    print("Static folder:", app.static_folder)
    app.run(debug=True, port=5000)