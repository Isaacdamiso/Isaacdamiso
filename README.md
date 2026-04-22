# Hospital Information System (Flask + SQLite)

Minimal starter project for a hospital information system using Flask and SQLite.

Quick start

1. Create and activate a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install dependencies:

```bash
pip install -r requirements.txt
```

3. Initialize the database and run the dev server:

```bash
export FLASK_APP=app.py
flask init-db
flask run
```

Open http://127.0.0.1:5000 in a browser.

Next steps
- Add authentication and role-based access
- Add full CRUD APIs for doctors, appointments, departments
- Add tests
