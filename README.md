# 12SE_YatharthSuchetAarav_PWA
PWA Movie Catalogue

python -m venv venv
.\venv\Scripts\Activate.ps1
pip install Flask
cd "Web Server/Gamify-PWA"
python app.py

## Running the Web Server (Windows PowerShell)

Prerequisites: Python 3.8+

1. Create and activate a virtual environment

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

2. Install dependencies

```powershell
pip install Flask
# or, if a requirements file is added later:
# pip install -r requirements.txt
```

3. Start the server

```powershell
cd "Web Server/Gamify-PWA"
python app.py
```

Notes:

- The app will auto-initialize the SQLite database from `Web Server/Gamify-PWA/static/db/schema.sql` if the database is missing.
- The server runs on port 5000 by default; open `http://127.0.0.1:5000/`.
- Stop the server with `Ctrl+C`.

