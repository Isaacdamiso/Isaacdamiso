#!/usr/bin/env python3
import sqlite3
import os

db_path = "/home/isaac/Desktop/hospital information management system/instance/test.db"

conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Get existing departments
cursor.execute('SELECT id, name FROM department')
departments = cursor.fetchall()

print(f'✓ Found {len(departments)} departments')

# Add more doctors to each department
new_doctors = [
    # Cardiology (dept 1)
    ['Dr. Robert Wilson', 'Cardiologist', 1],
    ['Dr. Lisa Anderson', 'Cardiologist', 1],
    ['Dr. James Brown', 'Interventional Cardiologist', 1],
    
    # Pediatrics (dept 2)
    ['Dr. Emily Davis', 'Pediatrician', 2],
    ['Dr. Michael Chen', 'Pediatric Specialist', 2],
    ['Dr. Sarah Johnson', 'Pediatric Cardiologist', 2],
    
    # Emergency (dept 3)
    ['Dr. David Martinez', 'Emergency Medicine', 3],
    ['Dr. Maria Garcia', 'Trauma Surgeon', 3],
    ['Dr. William Taylor', 'Emergency Medicine', 3],
]

cursor.executemany(
    'INSERT OR IGNORE INTO doctor (name, specialty, department_id) VALUES (?, ?, ?)',
    new_doctors
)
conn.commit()

# Get total doctor count
cursor.execute('SELECT COUNT(*) FROM doctor')
total_doctors = cursor.fetchone()[0]

print(f'✓ Added doctors to all departments')
print(f'✓ Total doctors now: {total_doctors}')

# Show breakdown by department
for dept_id, dept_name in departments:
    cursor.execute('SELECT COUNT(*) FROM doctor WHERE department_id = ?', (dept_id,))
    count = cursor.fetchone()[0]
    print(f'  - {dept_name}: {count} doctors')

conn.close()

print()
print('✅ Successfully added doctors to all departments!')
