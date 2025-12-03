import os
import sqlite3
from flask import Flask, render_template, request, jsonify, send_from_directory

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(
    __name__,
    template_folder=basedir,                        # HTML files live in project root
    static_folder=os.path.join(basedir, 'static')   # CSS/JS/images in /static
)

def init_db():
    db_dir = os.path.join(basedir, 'static', 'db')
    db_path = os.path.join(db_dir, 'gamify.db')
    os.makedirs(db_dir, exist_ok=True)
    if not os.path.exists(db_path):
        conn = sqlite3.connect(db_path)
        c = conn.cursor()
        schema_path = os.path.join(db_dir, 'schema.sql')
        if os.path.exists(schema_path):
            with open(schema_path, 'r', encoding='utf-8') as f:
                c.executescript(f.read())
        conn.commit()
        conn.close()

init_db()

# Serve manifest & service worker from project root so PWA can find them
@app.route('/manifest.json')
def manifest():
    return send_from_directory(basedir, 'manifest.json')

@app.route('/sw.js')
def service_worker():
    return send_from_directory(basedir, 'sw.js')

# Pages
@app.route('/index.html')
def index():
    return render_template('index.html')

@app.route('/login.html')
def login():
    return render_template('login.html')

@app.route('/signup.html')
def signup():
    return render_template('signup.html')

@app.route('/profile.html')
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
    print("Templates folder:", app.template_folder)
    print("Static folder:", app.static_folder)
    app.run(debug=True, port=5000)