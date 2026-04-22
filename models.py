from datetime import datetime
from database import db


class Department(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), unique=True, nullable=False)
    doctors = db.relationship('Doctor', backref='department', lazy=True)
    nurses = db.relationship('Nurse', backref='department', lazy=True)
    workers = db.relationship('GeneralWorker', backref='department', lazy=True)
    pharmacists = db.relationship('Pharmacist', backref='department', lazy=True)


class Doctor(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    specialty = db.Column(db.String(120))
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=True)
    appointments = db.relationship('Appointment', backref='doctor', lazy=True)
    prescriptions = db.relationship('Prescription', backref='doctor', lazy=True)


class Nurse(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    license_number = db.Column(db.String(50), unique=True, nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=True)
    phone = db.Column(db.String(20))


class GeneralWorker(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    position = db.Column(db.String(120), nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=True)
    phone = db.Column(db.String(20))


class Pharmacist(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    license_number = db.Column(db.String(50), unique=True, nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=True)
    phone = db.Column(db.String(20))


class Salary(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    staff_type = db.Column(db.String(50), nullable=False)  # 'doctor', 'nurse', 'pharmacist', 'worker'
    staff_id = db.Column(db.Integer, nullable=False)
    base_salary = db.Column(db.Float, nullable=False)
    bonuses = db.Column(db.Float, default=0.0)
    deductions = db.Column(db.Float, default=0.0)
    net_salary = db.Column(db.Float, nullable=False)
    payment_date = db.Column(db.Date, nullable=False, default=datetime.utcnow().date)
    payment_period_start = db.Column(db.Date, nullable=False)
    payment_period_end = db.Column(db.Date, nullable=False)
    notes = db.Column(db.Text)

    @property
    def staff_name(self):
        """Get the staff member's name based on type and id"""
        if self.staff_type == 'doctor':
            staff = Doctor.query.get(self.staff_id)
        elif self.staff_type == 'nurse':
            staff = Nurse.query.get(self.staff_id)
        elif self.staff_type == 'pharmacist':
            staff = Pharmacist.query.get(self.staff_id)
        elif self.staff_type == 'worker':
            staff = GeneralWorker.query.get(self.staff_id)
        else:
            return "Unknown"
        return staff.name if staff else "Not Found"

    @property
    def department_name(self):
        """Get the staff member's department"""
        if self.staff_type == 'doctor':
            staff = Doctor.query.get(self.staff_id)
        elif self.staff_type == 'nurse':
            staff = Nurse.query.get(self.staff_id)
        elif self.staff_type == 'pharmacist':
            staff = Pharmacist.query.get(self.staff_id)
        elif self.staff_type == 'worker':
            staff = GeneralWorker.query.get(self.staff_id)
        else:
            return "Unknown"
        return staff.department.name if staff and staff.department else "No Department"


class PharmacyInventory(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    medication_id = db.Column(db.Integer, db.ForeignKey('medication.id'), nullable=False)
    quantity_in_stock = db.Column(db.Integer, nullable=False, default=0)
    reorder_level = db.Column(db.Integer, nullable=False, default=10)
    last_updated = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)


class DispensingRecord(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    prescription_id = db.Column(db.Integer, db.ForeignKey('prescription.id'), nullable=False)
    pharmacist_id = db.Column(db.Integer, db.ForeignKey('pharmacist.id'), nullable=False)
    quantity_dispensed = db.Column(db.Integer, nullable=False)
    dispensed_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    notes = db.Column(db.Text)
    
    prescription = db.relationship('Prescription', back_populates='dispensing_records', lazy=True)
    pharmacist = db.relationship('Pharmacist', backref='dispensing_records', lazy=True)


class Patient(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(120), nullable=False)
    last_name = db.Column(db.String(120), nullable=False)
    dob = db.Column(db.Date, nullable=True)
    phone = db.Column(db.String(20))
    appointments = db.relationship('Appointment', backref='patient', lazy=True)
    prescriptions = db.relationship('Prescription', backref='patient', lazy=True)
    bills = db.relationship('Bill', backref='patient', lazy=True)


class Medication(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    description = db.Column(db.Text)
    unit_price = db.Column(db.Float, nullable=False)
    prescriptions = db.relationship('Prescription', backref='medication', lazy=True)
    inventory = db.relationship('PharmacyInventory', backref='medication', lazy=True, uselist=False)


class Prescription(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patient.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctor.id'), nullable=False)
    medication_id = db.Column(db.Integer, db.ForeignKey('medication.id'), nullable=False)
    dosage = db.Column(db.String(120), nullable=False)
    frequency = db.Column(db.String(120), nullable=False)
    duration_days = db.Column(db.Integer, nullable=False)
    prescribed_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    notes = db.Column(db.Text)
    dispensing_records = db.relationship('DispensingRecord', back_populates='prescription', lazy=True)


class Bill(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patient.id'), nullable=False)
    appointment_id = db.Column(db.Integer, db.ForeignKey('appointment.id'), nullable=True)
    total_amount = db.Column(db.Float, nullable=False)
    paid_amount = db.Column(db.Float, default=0.0)
    status = db.Column(db.String(20), default='unpaid')  # unpaid, partial, paid
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    bill_items = db.relationship('BillItem', backref='bill', lazy=True)

    @property
    def medication_cost(self):
        return sum(item.total_price for item in self.bill_items if item.category == 'medication')

    @property
    def treatment_cost(self):
        return sum(item.total_price for item in self.bill_items if item.category == 'treatment')


class BillItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    bill_id = db.Column(db.Integer, db.ForeignKey('bill.id'), nullable=False)
    description = db.Column(db.String(200), nullable=False)
    category = db.Column(db.String(50), nullable=False, default='treatment')  # medication, treatment
    quantity = db.Column(db.Integer, default=1)
    unit_price = db.Column(db.Float, nullable=False)
    total_price = db.Column(db.Float, nullable=False)


class Appointment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patient.id'), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey('doctor.id'), nullable=False)
    scheduled_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    notes = db.Column(db.Text)
    bills = db.relationship('Bill', backref='appointment', lazy=True)

