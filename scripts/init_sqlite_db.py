import os
import sqlite3

ROOT = os.path.dirname(os.path.dirname(__file__))
INSTANCE_DIR = os.path.join(ROOT, 'instance')
DB_PATH = os.path.join(INSTANCE_DIR, 'hospital.db')
SQL_PATH = os.path.join(INSTANCE_DIR, 'sql')

os.makedirs(INSTANCE_DIR, exist_ok=True)

with open(SQL_PATH, 'r') as f:
    sql = f.read()

conn = sqlite3.connect(DB_PATH)
try:
    conn.executescript(sql)
    print(f'Created/updated SQLite DB at: {DB_PATH}')
finally:
    conn.close()
