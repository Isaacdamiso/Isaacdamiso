-- Useful Views for Hospital Management System

-- View for active appointments with doctor and patient details
CREATE OR REPLACE VIEW active_appointments AS
SELECT 
    a.id as appointment_id,
    a.scheduled_at,
    CONCAT(p.first_name, ' ', p.last_name) as patient_name,
    CONCAT(d.name, ' (', d.specialty, ')') as doctor_info,
    dept.name as department
FROM appointment a
JOIN patient p ON a.patient_id = p.id
JOIN doctor d ON a.doctor_id = d.id
JOIN department dept ON d.department_id = dept.id
WHERE a.scheduled_at >= NOW()
ORDER BY a.scheduled_at;

-- View for patients with active prescriptions and medications
CREATE OR REPLACE VIEW patient_medications AS
SELECT 
    p.id as patient_id,
    CONCAT(p.first_name, ' ', p.last_name) as patient_name,
    m.name as medication_name,
    pr.dosage,
    pr.frequency,
    pr.prescribed_at,
    DATE_ADD(pr.prescribed_at, INTERVAL pr.duration_days DAY) as expiry_date,
    DATEDIFF(DATE_ADD(pr.prescribed_at, INTERVAL pr.duration_days DAY), NOW()) as days_remaining
FROM patient p
JOIN prescription pr ON p.id = pr.patient_id
JOIN medication m ON pr.medication_id = m.id
WHERE DATE_ADD(pr.prescribed_at, INTERVAL pr.duration_days DAY) >= NOW()
ORDER BY expiry_date;

-- View for low stock medications
CREATE OR REPLACE VIEW low_stock_alert AS
SELECT 
    pi.id as inventory_id,
    m.name as medication_name,
    pi.quantity_in_stock,
    pi.reorder_level,
    (pi.reorder_level - pi.quantity_in_stock) as shortage_amount,
    pi.last_updated
FROM pharmacy_inventory pi
JOIN medication m ON pi.medication_id = m.id
WHERE pi.quantity_in_stock <= pi.reorder_level
ORDER BY shortage_amount DESC;

-- View for doctor workload (appointments per doctor)
CREATE OR REPLACE VIEW doctor_workload AS
SELECT 
    d.id as doctor_id,
    d.name as doctor_name,
    d.specialty,
    dept.name as department,
    COUNT(a.id) as total_appointments,
    SUM(CASE WHEN a.scheduled_at >= NOW() THEN 1 ELSE 0 END) as upcoming_appointments
FROM doctor d
LEFT JOIN department dept ON d.department_id = dept.id
LEFT JOIN appointment a ON d.id = a.doctor_id
GROUP BY d.id
ORDER BY upcoming_appointments DESC;

-- View for bills summary
CREATE OR REPLACE VIEW bills_summary AS
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) as patient_name,
    b.created_at,
    b.total_amount,
    b.status,
    SUM(bi.total_price) as itemized_total
FROM bill b
JOIN patient p ON b.patient_id = p.id
LEFT JOIN bill_item bi ON b.id = bi.bill_id
GROUP BY b.id
ORDER BY b.created_at DESC;

-- View for department statistics
CREATE OR REPLACE VIEW department_stats AS
SELECT 
    dept.id as dept_id,
    dept.name as department_name,
    COUNT(DISTINCT d.id) as doctor_count,
    COUNT(DISTINCT n.id) as nurse_count,
    COUNT(DISTINCT a.id) as total_appointments,
    COUNT(DISTINCT w.id) as worker_count
FROM department dept
LEFT JOIN doctor d ON dept.id = d.department_id
LEFT JOIN nurse n ON dept.id = n.department_id
LEFT JOIN appointment a ON d.id = a.doctor_id
LEFT JOIN general_worker w ON dept.id = w.department_id
GROUP BY dept.id;
