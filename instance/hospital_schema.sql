-- Create Tables
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY AUTOINCREMENT,
    dept_name TEXT NOT NULL UNIQUE,
    location TEXT,
    head_id INTEGER
);

CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    dept_id INTEGER NOT NULL,
    position TEXT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    dob DATE,
    gender TEXT,
    phone TEXT,
    email TEXT,
    address TEXT,
    admission_date DATE
);

CREATE TABLE medical_records (
    record_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER NOT NULL,
    emp_id INTEGER NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    record_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE appointments (
    appt_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER NOT NULL,
    emp_id INTEGER NOT NULL,
    appt_date DATETIME,
    status TEXT DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE departments_staff (
    dept_id INTEGER NOT NULL,
    emp_id INTEGER NOT NULL,
    PRIMARY KEY (dept_id, emp_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Create Views for Different Departments
CREATE VIEW cardiology_staff AS
SELECT e.emp_id, e.first_name, e.last_name, e.position
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Cardiology';

CREATE VIEW pediatrics_patients AS
SELECT p.patient_id, p.first_name, p.last_name, p.dob, p.admission_date
FROM patients p
JOIN medical_records mr ON p.patient_id = mr.patient_id
JOIN employees e ON mr.emp_id = e.emp_id
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Pediatrics';

CREATE VIEW oncology_treatments AS
SELECT p.patient_id, p.first_name, p.last_name, mr.diagnosis, mr.treatment, mr.record_date
FROM patients p
JOIN medical_records mr ON p.patient_id = mr.patient_id
JOIN employees e ON mr.emp_id = e.emp_id
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Oncology';

CREATE VIEW department_summary AS
SELECT d.dept_name, COUNT(DISTINCT e.emp_id) as staff_count, COUNT(DISTINCT mr.patient_id) as patient_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN medical_records mr ON e.emp_id = mr.emp_id
GROUP BY d.dept_id, d.dept_name;