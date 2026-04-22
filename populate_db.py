#!/usr/bin/env python3
import os
import sys
from datetime import datetime, date

# Add the app directory to the path
sys.path.insert(0, os.path.dirname(__file__))

from app import create_app, db
from models import Department, Doctor, Patient, Appointment

# Create app with correct instance directory
app = create_app()

# Ensure we're using the correct database path
db_path = os.path.join(os.path.dirname(__file__), 'instance', 'hospital.db')
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{db_path}'

with app.app_context():
    # Create all tables
    db.create_all()
    print('✓ Database tables created')

    # Add Departments
    departments = [
        Department(name='Cardiology'),
        Department(name='Neurology'),
        Department(name='Orthopedics'),
        Department(name='General Medicine'),
        Department(name='Surgery'),
    ]
    for dept in departments:
        db.session.add(dept)
    db.session.commit()
    print('✓ Added 5 departments')

    # Add Doctors
    doctors = [
        Doctor(name='Dr. James Smith', specialty='Cardiology', department_id=1),
        Doctor(name='Dr. Sarah Johnson', specialty='Neurology', department_id=2),
        Doctor(name='Dr. Michael Chen', specialty='Orthopedics', department_id=3),
        Doctor(name='Dr. Emily Davis', specialty='General Medicine', department_id=4),
        Doctor(name='Dr. Robert Wilson', specialty='Surgery', department_id=5),
        Doctor(name='Dr. Lisa Anderson', specialty='Cardiology', department_id=1),
    ]
    for doctor in doctors:
        db.session.add(doctor)
    db.session.commit()
    print('✓ Added 6 doctors')

    # Add Patients
    patients = [
        Patient(first_name='John', last_name='Doe', dob=date(1975, 5, 15), phone='555-0101'),
        Patient(first_name='Jane', last_name='Smith', dob=date(1982, 3, 22), phone='555-0102'),
        Patient(first_name='Michael', last_name='Brown', dob=date(1990, 8, 10), phone='555-0103'),
        Patient(first_name='Emma', last_name='Wilson', dob=date(1988, 12, 5), phone='555-0104'),
        Patient(first_name='David', last_name='Martinez', dob=date(1995, 1, 18), phone='555-0105'),
        Patient(first_name='Lisa', last_name='Garcia', dob=date(1980, 6, 30), phone='555-0106'),
        Patient(first_name='James', last_name='Taylor', dob=date(1992, 11, 12), phone='555-0107'),
        Patient(first_name='Maria', last_name='Rodriguez', dob=date(1985, 9, 25), phone='555-0108'),
    ]
    for patient in patients:
        db.session.add(patient)
    db.session.commit()
    print('✓ Added 8 patients')

    # Add Appointments
    appointments = [
        Appointment(patient_id=1, doctor_id=1, scheduled_at=datetime(2026, 3, 25, 9, 30), notes='Routine cardiac checkup'),
        Appointment(patient_id=2, doctor_id=2, scheduled_at=datetime(2026, 3, 25, 10, 15), notes='Migraine evaluation'),
        Appointment(patient_id=3, doctor_id=3, scheduled_at=datetime(2026, 3, 26, 14, 0), notes='Knee pain consultation'),
        Appointment(patient_id=4, doctor_id=4, scheduled_at=datetime(2026, 3, 26, 11, 45), notes='General checkup'),
        Appointment(patient_id=5, doctor_id=5, scheduled_at=datetime(2026, 3, 27, 9, 0), notes='Pre-surgery consultation'),
        Appointment(patient_id=6, doctor_id=1, scheduled_at=datetime(2026, 3, 27, 15, 30), notes='Heart disease follow-up'),
        Appointment(patient_id=7, doctor_id=6, scheduled_at=datetime(2026, 3, 28, 10, 30), notes='Arrhythmia monitoring'),
        Appointment(patient_id=8, doctor_id=2, scheduled_at=datetime(2026, 3, 28, 13, 15), notes='Neurological assessment'),
    ]
    for appointment in appointments:
        db.session.add(appointment)
    db.session.commit()
    print('✓ Added 8 appointments')

    print()
    print('✅ Database successfully created and populated!')
    print(f'   Location: {db_path}')
