#!/usr/bin/env python3
import sqlite3
import os
from datetime import datetime, date

# Create database path
db_dir = os.path.join(os.path.dirname(__file__), 'instance')
os.makedirs(db_dir, exist_ok=True)
db_path = os.path.join(db_dir, 'hospital.db')

# Remove existing database if it exists to start fresh
if os.path.exists(db_path):
    os.remove(db_path)

# Connect to database
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Create tables
cursor.execute('''
    CREATE TABLE department (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(120) UNIQUE NOT NULL
    )
''')

cursor.execute('''
    CREATE TABLE doctor (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(120) NOT NULL,
        specialty VARCHAR(120),
        department_id INTEGER,
        FOREIGN KEY (department_id) REFERENCES department(id)
    )
''')

cursor.execute('''
    CREATE TABLE patient (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name VARCHAR(120) NOT NULL,
        last_name VARCHAR(120) NOT NULL,
        dob DATE,
        phone VARCHAR(20)
    )
''')

cursor.execute('''
    CREATE TABLE appointment (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER NOT NULL,
        doctor_id INTEGER NOT NULL,
        scheduled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        notes TEXT,
        FOREIGN KEY (patient_id) REFERENCES patient(id),
        FOREIGN KEY (doctor_id) REFERENCES doctor(id)
    )
''')

print('✓ Database tables created')

# Insert departments
departments = [
    ['Cardiology'],
    ['Neurology'],
    ['Orthopedics'],
    ['General Medicine'],
    ['Surgery'],
]

cursor.executemany('INSERT INTO department (name) VALUES (?)', departments)
conn.commit()
print('✓ Added 5 departments')

# Insert doctors
doctors = [
    ['Dr. James Smith', 'Cardiology', 1],
    ['Dr. Sarah Johnson', 'Neurology', 2],
    ['Dr. Michael Chen', 'Orthopedics', 3],
    ['Dr. Emily Davis', 'General Medicine', 4],
    ['Dr. Robert Wilson', 'Surgery', 5],
    ['Dr. Lisa Anderson', 'Cardiology', 1],
]

cursor.executemany(
    'INSERT INTO doctor (name, specialty, department_id) VALUES (?, ?, ?)',
    doctors
)
conn.commit()
print('✓ Added 6 doctors')

# Insert patients
patients = [
    ['John', 'Doe', '1975-05-15', '555-0101'],
    ['Jane', 'Smith', '1982-03-22', '555-0102'],
    ['Michael', 'Brown', '1990-08-10', '555-0103'],
    ['Emma', 'Wilson', '1988-12-05', '555-0104'],
    ['David', 'Martinez', '1995-01-18', '555-0105'],
    ['Lisa', 'Garcia', '1980-06-30', '555-0106'],
    ['James', 'Taylor', '1992-11-12', '555-0107'],
    ['Maria', 'Rodriguez', '1985-09-25', '555-0108'],
]

cursor.executemany(
    'INSERT INTO patient (first_name, last_name, dob, phone) VALUES (?, ?, ?, ?)',
    patients
)
conn.commit()
print('✓ Added 8 patients')

# Insert appointments
appointments = [
    [1, 1, '2026-03-25 09:30:00', 'Routine cardiac checkup'],
    [2, 2, '2026-03-25 10:15:00', 'Migraine evaluation'],
    [3, 3, '2026-03-26 14:00:00', 'Knee pain consultation'],
    [4, 4, '2026-03-26 11:45:00', 'General checkup'],
    [5, 5, '2026-03-27 09:00:00', 'Pre-surgery consultation'],
    [6, 1, '2026-03-27 15:30:00', 'Heart disease follow-up'],
    [7, 6, '2026-03-28 10:30:00', 'Arrhythmia monitoring'],
    [8, 2, '2026-03-28 13:15:00', 'Neurological assessment'],
]

cursor.executemany(
    'INSERT INTO appointment (patient_id, doctor_id, scheduled_at, notes) VALUES (?, ?, ?, ?)',
    appointments
)
conn.commit()
print('✓ Added 8 appointments')

conn.close()

print()
print('✅ Database successfully created and populated!')
print(f'   Location: {db_path}')
print()
print('🚀 To run the app:')
print('   python3 app.py')
print('   Then visit: http://localhost:5000')