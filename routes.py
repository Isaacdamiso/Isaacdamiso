from flask import Blueprint, render_template, request, redirect, url_for, jsonify, flash, current_app
from database import db
from models import Patient, Doctor, Appointment, Department, Nurse, GeneralWorker, Medication, Prescription, Bill, BillItem, Pharmacist, PharmacyInventory, DispensingRecord, Salary
from datetime import datetime
import json

main_bp = Blueprint('main', __name__)


@main_bp.route('/')
def index():
    # Check for low stock items
    low_stock_items = PharmacyInventory.query.filter(
        PharmacyInventory.quantity_in_stock <= PharmacyInventory.reorder_level
    ).all()
    
    return render_template('index.html', low_stock_items=low_stock_items)


@main_bp.route('/patients', methods=['GET', 'POST'])
def patients():
    search_query = request.args.get('search', '')
    if request.method == 'POST':
        data = request.form
        p = Patient(first_name=data.get('first_name'), last_name=data.get('last_name'), phone=data.get('phone'))
        db.session.add(p)
        db.session.commit()
        
        return redirect(url_for('main.patients'))
    
    # Filter patients based on search query
    if search_query:
        allp = Patient.query.filter(
            db.or_(
                Patient.first_name.contains(search_query),
                Patient.last_name.contains(search_query),
                Patient.phone.contains(search_query)
            )
        ).all()
    else:
        allp = Patient.query.all()
    
    return render_template('patients.html', patients=allp, search_query=search_query)


@main_bp.route('/reports')
def reports():
    # Generate various reports
    reports_data = {
        'patient_stats': {
            'total_patients': Patient.query.count(),
            'patients_by_month': db.session.query(
                db.func.count(Patient.id),
                db.func.year(Patient.created_at),
                db.func.month(Patient.created_at)
            ).group_by(
                db.func.year(Patient.created_at),
                db.func.month(Patient.created_at)
            ).all()
        },
        'appointment_stats': {
            'total_appointments': Appointment.query.count(),
            'upcoming_appointments': Appointment.query.filter(
                Appointment.date_time >= datetime.now()
            ).count()
        },
        'pharmacy_stats': {
            'total_medications': Medication.query.count(),
            'low_stock_items': PharmacyInventory.query.filter(
                PharmacyInventory.quantity_in_stock <= PharmacyInventory.reorder_level
            ).count(),
            'total_inventory_value': db.session.query(
                db.func.sum(PharmacyInventory.quantity_in_stock * Medication.unit_price)
            ).join(Medication).scalar() or 0
        },
        'billing_stats': {
            'total_bills': Bill.query.count(),
            'total_revenue': db.session.query(db.func.sum(Bill.total_amount)).scalar() or 0,
            'avg_bill_amount': db.session.query(db.func.avg(Bill.total_amount)).scalar() or 0
        },
        'staff_stats': {
            'total_doctors': Doctor.query.count(),
            'total_nurses': Nurse.query.count(),
            'total_pharmacists': Pharmacist.query.count(),
            'total_workers': GeneralWorker.query.count()
        }
    }
    
    return render_template('reports.html', reports=reports_data)


@main_bp.route('/doctors', methods=['GET', 'POST'])
def doctors():
    search_query = request.args.get('search', '')
    search_specialty = request.args.get('specialty', '')
    search_dept = request.args.get('department', '')
    
    if request.method == 'POST':
        data = request.form
        d = Doctor(name=data.get('name'), specialty=data.get('specialty'), department_id=data.get('department_id'))
        db.session.add(d)
        db.session.commit()
        return redirect(url_for('main.doctors'))
    
    # Build query with filters
    query = Doctor.query
    if search_query:
        query = query.filter(Doctor.name.contains(search_query))
    if search_specialty:
        query = query.filter(Doctor.specialty.contains(search_specialty))
    if search_dept:
        query = query.filter(Doctor.department_id == search_dept)
    
    alld = query.all()
    depts = Department.query.all()
    return render_template('doctors.html', doctors=alld, departments=depts, search_query=search_query, search_specialty=search_specialty, search_dept=search_dept)


@main_bp.route('/nurses', methods=['GET', 'POST'])
def nurses():
    search_query = request.args.get('search', '')
    search_dept = request.args.get('department', '')
    
    if request.method == 'POST':
        data = request.form
        n = Nurse(name=data.get('name'), license_number=data.get('license_number'), 
                  department_id=data.get('department_id'), phone=data.get('phone'))
        db.session.add(n)
        db.session.commit()
        return redirect(url_for('main.nurses'))
    
    # Build query with filters
    query = Nurse.query
    if search_query:
        query = query.filter(db.or_(
            Nurse.name.contains(search_query),
            Nurse.license_number.contains(search_query),
            Nurse.phone.contains(search_query)
        ))
    if search_dept:
        query = query.filter(Nurse.department_id == search_dept)
    
    all_nurses = query.all()
    depts = Department.query.all()
    return render_template('nurses.html', nurses=all_nurses, departments=depts, search_query=search_query, search_dept=search_dept)


@main_bp.route('/workers', methods=['GET', 'POST'])
def workers():
    search_query = request.args.get('search', '')
    search_position = request.args.get('position', '')
    search_dept = request.args.get('department', '')
    
    if request.method == 'POST':
        data = request.form
        w = GeneralWorker(name=data.get('name'), position=data.get('position'), 
                          department_id=data.get('department_id'), phone=data.get('phone'))
        db.session.add(w)
        db.session.commit()
        return redirect(url_for('main.workers'))
    
    # Build query with filters
    query = GeneralWorker.query
    if search_query:
        query = query.filter(db.or_(
            GeneralWorker.name.contains(search_query),
            GeneralWorker.phone.contains(search_query)
        ))
    if search_position:
        query = query.filter(GeneralWorker.position.contains(search_position))
    if search_dept:
        query = query.filter(GeneralWorker.department_id == search_dept)
    
    all_workers = query.all()
    depts = Department.query.all()
    return render_template('workers.html', workers=all_workers, departments=depts, 
                         search_query=search_query, search_position=search_position, search_dept=search_dept)


@main_bp.route('/medications', methods=['GET', 'POST'])
def medications():
    if request.method == 'POST':
        data = request.form
        m = Medication(name=data.get('name'), description=data.get('description'), 
                       unit_price=float(data.get('unit_price', 0)))
        db.session.add(m)
        db.session.commit()
        return redirect(url_for('main.medications'))
    all_meds = Medication.query.all()
    return render_template('medications.html', medications=all_meds)


@main_bp.route('/backup')
def backup_database():
    import os
    from datetime import datetime
    
    # Create backup filename with timestamp
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_filename = f'hospital_backup_{timestamp}.sql'
    backup_path = os.path.join(current_app.root_path, 'backups')
    os.makedirs(backup_path, exist_ok=True)
    
    # Use mysqldump to create backup
    import subprocess
    try:
        cmd = [
            'mysqldump',
            '-u', 'isaac',
            '-p2001',
            'smart_health'
        ]
        
        with open(os.path.join(backup_path, backup_filename), 'w') as f:
            subprocess.run(cmd, stdout=f, check=True)
        
        flash(f'Database backup created: {backup_filename}', 'success')
    except subprocess.CalledProcessError as e:
        flash(f'Backup failed: {str(e)}', 'danger')
    
    return redirect(url_for('main.index'))


@main_bp.route('/prescriptions', methods=['GET', 'POST'])
def prescriptions():
    search_patient = request.args.get('patient', '')
    search_medication = request.args.get('medication', '')
    search_doctor = request.args.get('doctor', '')
    
    if request.method == 'POST':
        data = request.form
        p = Prescription(
            patient_id=data.get('patient_id'),
            doctor_id=data.get('doctor_id'),
            medication_id=data.get('medication_id'),
            dosage=data.get('dosage'),
            frequency=data.get('frequency'),
            duration_days=int(data.get('duration_days', 7)),
            notes=data.get('notes')
        )
        db.session.add(p)
        db.session.commit()
        return redirect(url_for('main.prescriptions'))
    
    # Build query with filters
    query = Prescription.query
    if search_patient:
        query = query.join(Patient).filter(
            db.or_(
                Patient.first_name.contains(search_patient),
                Patient.last_name.contains(search_patient)
            )
        )
    if search_medication:
        query = query.join(Medication).filter(Medication.name.contains(search_medication))
    if search_doctor:
        query = query.join(Doctor).filter(Doctor.name.contains(search_doctor))
    
    all_prescriptions = query.all()
    patients = Patient.query.all()
    doctors = Doctor.query.all()
    medications = Medication.query.all()
    return render_template('prescriptions.html', prescriptions=all_prescriptions, 
                          patients=patients, doctors=doctors, medications=medications,
                          search_patient=search_patient, search_medication=search_medication, search_doctor=search_doctor)


@main_bp.route('/bills', methods=['GET', 'POST'])
def bills():
    search_patient = request.args.get('patient', '')
    search_date_from = request.args.get('date_from', '')
    search_date_to = request.args.get('date_to', '')
    search_amount_from = request.args.get('amount_from', '')
    search_amount_to = request.args.get('amount_to', '')
    
    if request.method == 'POST':
        data = request.form
        patient_id = data.get('patient_id')
        appointment_id = data.get('appointment_id') or None
        
        # Create bill
        bill = Bill(patient_id=patient_id, appointment_id=appointment_id, total_amount=0.0)
        db.session.add(bill)
        db.session.flush()  # Get bill ID
        
        # Add bill items
        total = 0.0
        descriptions = data.getlist('description[]')
        categories = data.getlist('category[]')
        quantities = data.getlist('quantity[]')
        unit_prices = data.getlist('unit_price[]')
        
        for i in range(len(descriptions)):
            if descriptions[i] and unit_prices[i]:
                qty = int(quantities[i]) if quantities[i] else 1
                unit_price = float(unit_prices[i])
                item_total = qty * unit_price
                
                item = BillItem(
                    bill_id=bill.id,
                    description=descriptions[i],
                    category=categories[i] if i < len(categories) else 'treatment',
                    quantity=qty,
                    unit_price=unit_price,
                    total_price=item_total
                )
                db.session.add(item)
                total += item_total
        
        bill.total_amount = total
        db.session.commit()
        return redirect(url_for('main.bills'))
    
    # Build query with filters
    query = Bill.query
    if search_patient:
        query = query.join(Patient).filter(
            db.or_(
                Patient.first_name.contains(search_patient),
                Patient.last_name.contains(search_patient)
            )
        )
    if search_date_from:
        query = query.filter(db.func.date(Bill.created_at) >= search_date_from)
    if search_date_to:
        query = query.filter(db.func.date(Bill.created_at) <= search_date_to)
    if search_amount_from:
        query = query.filter(Bill.total_amount >= float(search_amount_from))
    if search_amount_to:
        query = query.filter(Bill.total_amount <= float(search_amount_to))
    
    all_bills = query.all()
    patients = Patient.query.all()
    appointments = Appointment.query.all()
    return render_template('bills.html', bills=all_bills, patients=patients, appointments=appointments,
                         search_patient=search_patient, search_date_from=search_date_from, 
                         search_date_to=search_date_to, search_amount_from=search_amount_from,
                         search_amount_to=search_amount_to)


@main_bp.route('/pharmacists', methods=['GET', 'POST'])
def pharmacists():
    search_query = request.args.get('search', '')
    search_dept = request.args.get('department', '')
    
    if request.method == 'POST':
        data = request.form
        p = Pharmacist(name=data.get('name'), license_number=data.get('license_number'), 
                       department_id=data.get('department_id'), phone=data.get('phone'))
        db.session.add(p)
        db.session.commit()
        return redirect(url_for('main.pharmacists'))
    
    # Build query with filters
    query = Pharmacist.query
    if search_query:
        query = query.filter(db.or_(
            Pharmacist.name.contains(search_query),
            Pharmacist.license_number.contains(search_query),
            Pharmacist.phone.contains(search_query)
        ))
    if search_dept:
        query = query.filter(Pharmacist.department_id == search_dept)
    
    all_pharmacists = query.all()
    depts = Department.query.all()
    return render_template('pharmacists.html', pharmacists=all_pharmacists, departments=depts,
                         search_query=search_query, search_dept=search_dept)


@main_bp.route('/pharmacy_inventory', methods=['GET', 'POST'])
def pharmacy_inventory():
    if request.method == 'POST':
        data = request.form
        medication_id = data.get('medication_id')
        
        # Check if inventory already exists for this medication
        existing = PharmacyInventory.query.filter_by(medication_id=medication_id).first()
        if existing:
            existing.quantity_in_stock = int(data.get('quantity_in_stock', 0))
            existing.reorder_level = int(data.get('reorder_level', 10))
            existing.last_updated = datetime.utcnow()
        else:
            inventory = PharmacyInventory(
                medication_id=medication_id,
                quantity_in_stock=int(data.get('quantity_in_stock', 0)),
                reorder_level=int(data.get('reorder_level', 10))
            )
            db.session.add(inventory)
            db.session.commit()
            return redirect(url_for('main.pharmacy_inventory'))
        
        db.session.commit()
        return redirect(url_for('main.pharmacy_inventory'))
    
    inventory_items = PharmacyInventory.query.all()
    medications = Medication.query.all()
    return render_template('pharmacy_inventory.html', inventory=inventory_items, medications=medications)


@main_bp.route('/dispensing_records', methods=['GET', 'POST'])
def dispensing_records():
    if request.method == 'POST':
        data = request.form
        prescription_id = data.get('prescription_id')
        pharmacist_id = data.get('pharmacist_id')
        quantity_dispensed = int(data.get('quantity_dispensed', 1))
        
        # Create dispensing record
        dispensing = DispensingRecord(
            prescription_id=prescription_id,
            pharmacist_id=pharmacist_id,
            quantity_dispensed=quantity_dispensed,
            notes=data.get('notes')
        )
        db.session.add(dispensing)
        db.session.flush()  # Get dispensing ID
        
        # Get prescription details
        prescription = Prescription.query.get(prescription_id)
        medication = prescription.medication
        patient = prescription.patient
        
        # Find or create bill for patient
        bill = Bill.query.filter_by(patient_id=patient.id, status='unpaid').first()
        if not bill:
            bill = Bill(patient_id=patient.id, total_amount=0.0)
            db.session.add(bill)
            db.session.flush()
        
        # Add bill item for medication
        unit_price = medication.unit_price
        total_price = quantity_dispensed * unit_price
        
        bill_item = BillItem(
            bill_id=bill.id,
            description=f"{medication.name} - {prescription.dosage}",
            category='medication',
            quantity=quantity_dispensed,
            unit_price=unit_price,
            total_price=total_price
        )
        db.session.add(bill_item)
        
        # Update bill total
        bill.total_amount += total_price
        
        db.session.commit()
        return redirect(url_for('main.dispensing_records'))
    
    all_records = DispensingRecord.query.all()
    prescriptions = Prescription.query.all()
    pharmacists = Pharmacist.query.all()
    return render_template('dispensing_records.html', records=all_records, 
                          prescriptions=prescriptions, pharmacists=pharmacists)


@main_bp.route('/departments', methods=['GET', 'POST'])
def departments():
    search_query = request.args.get('search', '')
    
    if request.method == 'POST':
        data = request.form
        dept = Department(name=data.get('name'))
        db.session.add(dept)
        db.session.commit()
        return redirect(url_for('main.departments'))
    
    # Build query with filters
    query = Department.query
    if search_query:
        query = query.filter(Department.name.contains(search_query))
    
    alld = query.all()
    return render_template('departments.html', departments=alld, search_query=search_query)


@main_bp.route('/appointments', methods=['GET', 'POST'])
def appointments():
    search_patient = request.args.get('patient', '')
    search_doctor = request.args.get('doctor', '')
    search_date = request.args.get('date', '')
    
    if request.method == 'POST':
        data = request.form
        appt = Appointment(
            patient_id=data.get('patient_id'),
            doctor_id=data.get('doctor_id'),
            scheduled_at=datetime.strptime(data.get('scheduled_at'), '%Y-%m-%dT%H:%M'),
            notes=data.get('notes')
        )
        db.session.add(appt)
        db.session.commit()
        return redirect(url_for('main.appointments'))
    
    # Build query with filters
    query = Appointment.query
    if search_patient:
        query = query.join(Patient).filter(
            db.or_(
                Patient.first_name.contains(search_patient),
                Patient.last_name.contains(search_patient)
            )
        )
    if search_doctor:
        query = query.join(Doctor).filter(Doctor.name.contains(search_doctor))
    if search_date:
        query = query.filter(db.func.date(Appointment.scheduled_at) == search_date)
    
    all_appts = query.all()
    patients = Patient.query.all()
    doctors = Doctor.query.all()
    return render_template('appointments.html', appointments=all_appts, patients=patients, doctors=doctors,
                         search_patient=search_patient, search_doctor=search_doctor, search_date=search_date)


@main_bp.route('/salaries', methods=['GET', 'POST'])
def salaries():
    if request.method == 'POST':
        data = request.form
        salary = Salary(
            staff_type=data.get('staff_type'),
            staff_id=int(data.get('staff_id')),
            base_salary=float(data.get('base_salary')),
            bonuses=float(data.get('bonuses', 0)),
            deductions=float(data.get('deductions', 0)),
            payment_date=datetime.strptime(data.get('payment_date'), '%Y-%m-%d').date(),
            payment_period_start=datetime.strptime(data.get('payment_period_start'), '%Y-%m-%d').date(),
            payment_period_end=datetime.strptime(data.get('payment_period_end'), '%Y-%m-%d').date(),
            notes=data.get('notes')
        )
        # Calculate net salary
        salary.net_salary = salary.base_salary + salary.bonuses - salary.deductions
        db.session.add(salary)
        db.session.commit()
        return redirect(url_for('main.salaries'))
    
    all_salaries = Salary.query.order_by(Salary.payment_date.desc()).all()
    
    # Get all staff for the dropdown
    doctors = Doctor.query.all()
    nurses = Nurse.query.all()
    pharmacists = Pharmacist.query.all()
    workers = GeneralWorker.query.all()
    
    return render_template('salaries.html', salaries=all_salaries, doctors=doctors, 
                          nurses=nurses, pharmacists=pharmacists, workers=workers)


# Views Routes
@main_bp.route('/views/active-appointments')
def active_appointments_view():
    from sqlalchemy import text
    active_appts = db.session.execute(text('SELECT * FROM active_appointments')).fetchall()
    return render_template('views/active_appointments.html', appointments=active_appts)


@main_bp.route('/views/patient-medications')
def patient_medications_view():
    from sqlalchemy import text
    patient_meds = db.session.execute(text('SELECT * FROM patient_medications')).fetchall()
    return render_template('views/patient_medications.html', medications=patient_meds)


@main_bp.route('/views/low-stock-alert')
def low_stock_view():
    from sqlalchemy import text
    low_stock = db.session.execute(text('SELECT * FROM low_stock_alert')).fetchall()
    return render_template('views/low_stock_alert.html', items=low_stock)


@main_bp.route('/views/doctor-workload')
def doctor_workload_view():
    from sqlalchemy import text
    doctor_workload = db.session.execute(text('SELECT * FROM doctor_workload ORDER BY upcoming_appointments DESC')).fetchall()
    return render_template('views/doctor_workload.html', workload=doctor_workload)


@main_bp.route('/views/bills-summary')
def bills_summary_view():
    from sqlalchemy import text
    bills_summary = db.session.execute(text('SELECT * FROM bills_summary')).fetchall()
    return render_template('views/bills_summary.html', bills=bills_summary)


@main_bp.route('/views/department-stats')
def department_stats_view():
    from sqlalchemy import text
    dept_stats = db.session.execute(text('SELECT * FROM department_stats')).fetchall()
    return render_template('views/department_stats.html', departments=dept_stats)
