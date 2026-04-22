#!/usr/bin/env python3
import os
import sys
from datetime import datetime, date, date

# Add the app directory to the path
sys.path.insert(0, os.path.dirname(__file__))

from app import create_app, db
from models import Department, Doctor, Patient, Appointment, Nurse, GeneralWorker, Medication, Prescription, Bill, BillItem, Pharmacist, PharmacyInventory, DispensingRecord, Salary

# Create app (uses MySQL connection from app.py)
app = create_app()

with app.app_context():
    # Drop all tables
    db.drop_all()
    print('✓ All tables dropped')
    
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
        Department(name='Pharmacy'),
    ]
    for dept in departments:
        db.session.add(dept)
    db.session.commit()
    print('✓ Added 6 departments')


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

    # Add Nurses
    nurses = [
        Nurse(name='Nurse Amanda Bell', license_number='RN-2021-001', department_id=1, phone='555-1001'),
        Nurse(name='Nurse David Carter', license_number='RN-2020-045', department_id=2, phone='555-1002'),
        Nurse(name='Nurse Emma Davis', license_number='RN-2022-012', department_id=3, phone='555-1003'),
        Nurse(name='Nurse Frank Miller', license_number='RN-2021-034', department_id=4, phone='555-1004'),
        Nurse(name='Nurse Grace Robinson', license_number='RN-2019-089', department_id=5, phone='555-1005'),
        Nurse(name='Nurse Hannah Thomas', license_number='RN-2023-008', department_id=1, phone='555-1006'),
    ]
    for nurse in nurses:
        db.session.add(nurse)
    db.session.commit()
    print('✓ Added 6 nurses')

    # Add General Workers
    workers = [
        GeneralWorker(name='John Helper', position='Orderly', department_id=1, phone='555-2001'),
        GeneralWorker(name='Maria Support', position='Clerk', department_id=2, phone='555-2002'),
        GeneralWorker(name='Carlos Maintenance', position='Maintenance Staff', department_id=3, phone='555-2003'),
        GeneralWorker(name='Lisa Cleaning', position='Cleaning Staff', department_id=4, phone='555-2004'),
        GeneralWorker(name='Robert Transport', position='Patient Transport', department_id=5, phone='555-2005'),
        GeneralWorker(name='Sofia Assistant', position='Medical Assistant', department_id=1, phone='555-2006'),
    ]
    for worker in workers:
        db.session.add(worker)
    db.session.commit()
    print('✓ Added 6 general workers')

    # Add Pharmacists
    pharmacists = [
        Pharmacist(name='Pharmacist Rachel Green', license_number='PH-2020-001', department_id=6, phone='555-3001'),
        Pharmacist(name='Pharmacist Mark Johnson', license_number='PH-2019-045', department_id=6, phone='555-3002'),
        Pharmacist(name='Pharmacist Sarah Williams', license_number='PH-2021-012', department_id=6, phone='555-3003'),
        Pharmacist(name='Pharmacist David Brown', license_number='PH-2022-034', department_id=6, phone='555-3004'),
    ]
    for pharmacist in pharmacists:
        db.session.add(pharmacist)
    db.session.commit()
    print('✓ Added 4 pharmacists')

    # Add Medications
    medications = [
        Medication(name='Aspirin', description='Pain reliever and anti-inflammatory', unit_price=5.99),
        Medication(name='Lisinopril', description='ACE inhibitor for blood pressure', unit_price=12.50),
        Medication(name='Metformin', description='Diabetes medication', unit_price=8.75),
        Medication(name='Atorvastatin', description='Cholesterol medication', unit_price=15.25),
        Medication(name='Omeprazole', description='Acid reflux medication', unit_price=9.99),
        Medication(name='Amoxicillin', description='Antibiotic', unit_price=18.50),
        Medication(name='Ibuprofen', description='Pain and fever reducer', unit_price=4.99),
        Medication(name='Warfarin', description='Blood thinner', unit_price=22.00),
    ]
    for med in medications:
        db.session.add(med)
    db.session.commit()
    print('✓ Added 8 medications')

    # Add Pharmacy Inventory
    inventory_items = [
        PharmacyInventory(medication_id=1, quantity_in_stock=150, reorder_level=50),
        PharmacyInventory(medication_id=2, quantity_in_stock=100, reorder_level=30),
        PharmacyInventory(medication_id=3, quantity_in_stock=120, reorder_level=40),
        PharmacyInventory(medication_id=4, quantity_in_stock=80, reorder_level=25),
        PharmacyInventory(medication_id=5, quantity_in_stock=90, reorder_level=30),
        PharmacyInventory(medication_id=6, quantity_in_stock=60, reorder_level=20),
        PharmacyInventory(medication_id=7, quantity_in_stock=200, reorder_level=75),
        PharmacyInventory(medication_id=8, quantity_in_stock=45, reorder_level=15),
    ]
    for item in inventory_items:
        db.session.add(item)
    db.session.commit()
    print('✓ Added pharmacy inventory for 8 medications')

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

    # Add Prescriptions
    prescriptions = [
        Prescription(patient_id=1, doctor_id=1, medication_id=1, dosage='81mg', frequency='Once daily', duration_days=30, notes='Take with food'),
        Prescription(patient_id=1, doctor_id=1, medication_id=4, dosage='20mg', frequency='Once daily', duration_days=30, notes='Take in evening'),
        Prescription(patient_id=2, doctor_id=2, medication_id=7, dosage='400mg', frequency='Every 6 hours', duration_days=7, notes='As needed for pain'),
        Prescription(patient_id=3, doctor_id=3, medication_id=7, dosage='600mg', frequency='Every 8 hours', duration_days=10, notes='For knee pain'),
        Prescription(patient_id=4, doctor_id=4, medication_id=3, dosage='500mg', frequency='Twice daily', duration_days=90, notes='With meals'),
        Prescription(patient_id=5, doctor_id=5, medication_id=6, dosage='500mg', frequency='Three times daily', duration_days=10, notes='Complete full course'),
        Prescription(patient_id=6, doctor_id=1, medication_id=2, dosage='10mg', frequency='Once daily', duration_days=30, notes='Monitor blood pressure'),
        Prescription(patient_id=7, doctor_id=6, medication_id=8, dosage='5mg', frequency='Once daily', duration_days=30, notes='Monitor INR levels'),
    ]
    for prescription in prescriptions:
        db.session.add(prescription)
    db.session.commit()
    print('✓ Added 8 prescriptions')

    # Add Dispensing Records
    dispensing_records = [
        DispensingRecord(prescription_id=1, pharmacist_id=1, quantity_dispensed=30, notes='First fill'),
        DispensingRecord(prescription_id=2, pharmacist_id=1, quantity_dispensed=30, notes='First fill'),
        DispensingRecord(prescription_id=3, pharmacist_id=2, quantity_dispensed=14, notes='Emergency fill'),
        DispensingRecord(prescription_id=4, pharmacist_id=3, quantity_dispensed=20, notes='Partial fill'),
        DispensingRecord(prescription_id=6, pharmacist_id=4, quantity_dispensed=30, notes='New prescription'),
    ]
    for record in dispensing_records:
        db.session.add(record)
    db.session.commit()
    print('✓ Added 5 dispensing records')

    # Add Bills
    bills = [
        Bill(patient_id=1, appointment_id=1, total_amount=787.20, paid_amount=787.20, status='paid'),
        Bill(patient_id=2, appointment_id=2, total_amount=269.86, paid_amount=100.00, status='partial'),
        Bill(patient_id=3, appointment_id=3, total_amount=349.80, paid_amount=0.00, status='unpaid'),
        Bill(patient_id=4, appointment_id=4, total_amount=120.00, paid_amount=120.00, status='paid'),
        Bill(patient_id=5, appointment_id=5, total_amount=500.00, paid_amount=250.00, status='partial'),
        Bill(patient_id=6, appointment_id=6, total_amount=555.00, paid_amount=555.00, status='paid'),
    ]
    for bill in bills:
        db.session.add(bill)
    db.session.commit()

    # Add Bill Items
    bill_items = [
        # Bill 1 items (John Doe - includes medication costs)
        BillItem(bill_id=1, description='Consultation Fee', quantity=1, unit_price=100.00, total_price=100.00, category='treatment'),
        BillItem(bill_id=1, description='ECG Test', quantity=1, unit_price=50.00, total_price=50.00, category='treatment'),
        BillItem(bill_id=1, description='Aspirin - 81mg', quantity=30, unit_price=5.99, total_price=179.70, category='medication'),
        BillItem(bill_id=1, description='Atorvastatin - 20mg', quantity=30, unit_price=15.25, total_price=457.50, category='medication'),
        
        # Bill 2 items (Jane Smith - includes medication costs)
        BillItem(bill_id=2, description='Neurological Consultation', quantity=1, unit_price=150.00, total_price=150.00, category='treatment'),
        BillItem(bill_id=2, description='MRI Scan', quantity=1, unit_price=50.00, total_price=50.00, category='treatment'),
        BillItem(bill_id=2, description='Ibuprofen - 400mg', quantity=14, unit_price=4.99, total_price=69.86, category='medication'),
        
        # Bill 3 items (Michael Brown - includes medication costs)
        BillItem(bill_id=3, description='Orthopedic Consultation', quantity=1, unit_price=120.00, total_price=120.00, category='treatment'),
        BillItem(bill_id=3, description='X-Ray', quantity=2, unit_price=65.00, total_price=130.00, category='treatment'),
        BillItem(bill_id=3, description='Ibuprofen - 600mg', quantity=20, unit_price=4.99, total_price=99.80, category='medication'),
        
        # Bill 4 items (Emma Wilson)
        BillItem(bill_id=4, description='General Checkup', quantity=1, unit_price=80.00, total_price=80.00, category='treatment'),
        BillItem(bill_id=4, description='Blood Tests', quantity=1, unit_price=40.00, total_price=40.00, category='treatment'),
        
        # Bill 5 items (David Martinez)
        BillItem(bill_id=5, description='Pre-Surgery Consultation', quantity=1, unit_price=200.00, total_price=200.00, category='treatment'),
        BillItem(bill_id=5, description='Lab Tests', quantity=1, unit_price=150.00, total_price=150.00, category='treatment'),
        BillItem(bill_id=5, description='Anesthesia Consultation', quantity=1, unit_price=150.00, total_price=150.00, category='treatment'),
        
        # Bill 6 items (Lisa Garcia - includes medication costs)
        BillItem(bill_id=6, description='Cardiac Follow-up', quantity=1, unit_price=120.00, total_price=120.00, category='treatment'),
        BillItem(bill_id=6, description='Echocardiogram', quantity=1, unit_price=60.00, total_price=60.00, category='treatment'),
        BillItem(bill_id=6, description='Lisinopril - 10mg', quantity=30, unit_price=12.50, total_price=375.00, category='medication'),
    ]
    for item in bill_items:
        db.session.add(item)
    db.session.commit()
    print('✓ Added 6 bills with detailed items including medication costs')

    # Add Salary Records
    salaries = [
        # Doctors - Higher salaries
        Salary(staff_type='doctor', staff_id=1, base_salary=150000.00, bonuses=5000.00, deductions=1200.00, 
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        Salary(staff_type='doctor', staff_id=2, base_salary=145000.00, bonuses=3000.00, deductions=1100.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        Salary(staff_type='doctor', staff_id=3, base_salary=140000.00, bonuses=4000.00, deductions=1000.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        
        # Nurses - Medium salaries
        Salary(staff_type='nurse', staff_id=1, base_salary=75000.00, bonuses=1500.00, deductions=600.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        Salary(staff_type='nurse', staff_id=2, base_salary=72000.00, bonuses=1200.00, deductions=550.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        
        # Pharmacists - Medium-high salaries
        Salary(staff_type='pharmacist', staff_id=1, base_salary=85000.00, bonuses=2000.00, deductions=700.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        Salary(staff_type='pharmacist', staff_id=2, base_salary=82000.00, bonuses=1800.00, deductions=650.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        
        # General Workers - Lower salaries
        Salary(staff_type='worker', staff_id=1, base_salary=45000.00, bonuses=500.00, deductions=300.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
        Salary(staff_type='worker', staff_id=2, base_salary=42000.00, bonuses=400.00, deductions=280.00,
               payment_date=date(2026, 3, 31), payment_period_start=date(2026, 3, 1), payment_period_end=date(2026, 3, 31),
               notes='Monthly salary payment'),
    ]
    
    for salary in salaries:
        salary.net_salary = salary.base_salary + salary.bonuses - salary.deductions
        db.session.add(salary)
    db.session.commit()
    print('✓ Added salary records for staff members')

    print()
    print('✅ MySQL database successfully cleared and repopulated!')
    print('   Database: smart_health')
    print('   Departments: 6 | Doctors: 6 | Nurses: 6 | Workers: 6 | Pharmacists: 4 | Patients: 8 | Appointments: 8')
    print('   Medications: 8 | Prescriptions: 8 | Bills: 6 | Dispensing Records: 5 | Salaries: 9')
