-- MySQL dump 10.13  Distrib 8.4.8, for Linux (x86_64)
--
-- Host: localhost    Database: smart_health
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `scheduled_at` datetime NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (1,1,1,'2026-03-25 09:30:00','Routine cardiac checkup'),(2,2,2,'2026-03-25 10:15:00','Migraine evaluation'),(3,3,3,'2026-03-26 14:00:00','Knee pain consultation'),(4,4,4,'2026-03-26 11:45:00','General checkup'),(5,5,5,'2026-03-27 09:00:00','Pre-surgery consultation'),(6,6,1,'2026-03-27 15:30:00','Heart disease follow-up'),(7,7,6,'2026-03-28 10:30:00','Arrhythmia monitoring'),(8,8,2,'2026-03-28 13:15:00','Neurological assessment');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `table_name` varchar(50) NOT NULL,
  `record_id` int DEFAULT NULL,
  `old_values` text,
  `new_values` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `appointment_id` int DEFAULT NULL,
  `total_amount` float NOT NULL,
  `paid_amount` float DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  KEY `appointment_id` (`appointment_id`),
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`),
  CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1,1,1,787.2,787.2,'paid','2026-04-07 17:53:29'),(2,2,2,269.86,100,'partial','2026-04-07 17:53:29'),(3,3,3,349.8,0,'unpaid','2026-04-07 17:53:29'),(4,4,4,120,120,'paid','2026-04-07 17:53:29'),(5,5,5,500,250,'partial','2026-04-07 17:53:29'),(6,6,6,555,555,'paid','2026-04-07 17:53:29');
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_item`
--

DROP TABLE IF EXISTS `bill_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_id` int NOT NULL,
  `description` varchar(200) NOT NULL,
  `category` varchar(50) NOT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` float NOT NULL,
  `total_price` float NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_id` (`bill_id`),
  CONSTRAINT `bill_item_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_item`
--

LOCK TABLES `bill_item` WRITE;
/*!40000 ALTER TABLE `bill_item` DISABLE KEYS */;
INSERT INTO `bill_item` VALUES (1,1,'Consultation Fee','treatment',1,100,100),(2,1,'ECG Test','treatment',1,50,50),(3,1,'Aspirin - 81mg','medication',30,5.99,179.7),(4,1,'Atorvastatin - 20mg','medication',30,15.25,457.5),(5,2,'Neurological Consultation','treatment',1,150,150),(6,2,'MRI Scan','treatment',1,50,50),(7,2,'Ibuprofen - 400mg','medication',14,4.99,69.86),(8,3,'Orthopedic Consultation','treatment',1,120,120),(9,3,'X-Ray','treatment',2,65,130),(10,3,'Ibuprofen - 600mg','medication',20,4.99,99.8),(11,4,'General Checkup','treatment',1,80,80),(12,4,'Blood Tests','treatment',1,40,40),(13,5,'Pre-Surgery Consultation','treatment',1,200,200),(14,5,'Lab Tests','treatment',1,150,150),(15,5,'Anesthesia Consultation','treatment',1,150,150),(16,6,'Cardiac Follow-up','treatment',1,120,120),(17,6,'Echocardiogram','treatment',1,60,60),(18,6,'Lisinopril - 10mg','medication',30,12.5,375);
/*!40000 ALTER TABLE `bill_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Cardiology'),(4,'General Medicine'),(2,'Neurology'),(3,'Orthopedics'),(6,'Pharmacy'),(5,'Surgery');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispensing_record`
--

DROP TABLE IF EXISTS `dispensing_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispensing_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prescription_id` int NOT NULL,
  `pharmacist_id` int NOT NULL,
  `quantity_dispensed` int NOT NULL,
  `dispensed_at` datetime NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `prescription_id` (`prescription_id`),
  KEY `pharmacist_id` (`pharmacist_id`),
  CONSTRAINT `dispensing_record_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`id`),
  CONSTRAINT `dispensing_record_ibfk_2` FOREIGN KEY (`pharmacist_id`) REFERENCES `pharmacist` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispensing_record`
--

LOCK TABLES `dispensing_record` WRITE;
/*!40000 ALTER TABLE `dispensing_record` DISABLE KEYS */;
INSERT INTO `dispensing_record` VALUES (1,1,1,30,'2026-04-07 17:53:29','First fill'),(2,2,1,30,'2026-04-07 17:53:29','First fill'),(3,3,2,14,'2026-04-07 17:53:29','Emergency fill'),(4,4,3,20,'2026-04-07 17:53:29','Partial fill'),(5,6,4,30,'2026-04-07 17:53:29','New prescription');
/*!40000 ALTER TABLE `dispensing_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docters`
--

DROP TABLE IF EXISTS `docters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docters` (
  `id` int NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docters`
--

LOCK TABLES `docters` WRITE;
/*!40000 ALTER TABLE `docters` DISABLE KEYS */;
INSERT INTO `docters` VALUES (1,'moses damiso','mosesdamiso@jilc.com',NULL),(2,'elija damiso','elijahdmiso@jilc.com',NULL),(3,'hellen damiso','hellendmiso@jilc.com',NULL);
/*!40000 ALTER TABLE `docters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `specialty` varchar(120) DEFAULT NULL,
  `department_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'Dr. James Smith','Cardiology',1),(2,'Dr. Sarah Johnson','Neurology',2),(3,'Dr. Michael Chen','Orthopedics',3),(4,'Dr. Emily Davis','General Medicine',4),(5,'Dr. Robert Wilson','Surgery',5),(6,'Dr. Lisa Anderson','Cardiology',1);
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `general_worker`
--

DROP TABLE IF EXISTS `general_worker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_worker` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `position` varchar(120) NOT NULL,
  `department_id` int DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `general_worker_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general_worker`
--

LOCK TABLES `general_worker` WRITE;
/*!40000 ALTER TABLE `general_worker` DISABLE KEYS */;
INSERT INTO `general_worker` VALUES (1,'John Helper','Orderly',1,'555-2001'),(2,'Maria Support','Clerk',2,'555-2002'),(3,'Carlos Maintenance','Maintenance Staff',3,'555-2003'),(4,'Lisa Cleaning','Cleaning Staff',4,'555-2004'),(5,'Robert Transport','Patient Transport',5,'555-2005'),(6,'Sofia Assistant','Medical Assistant',1,'555-2006');
/*!40000 ALTER TABLE `general_worker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medication`
--

DROP TABLE IF EXISTS `medication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medication` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `description` text,
  `unit_price` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medication`
--

LOCK TABLES `medication` WRITE;
/*!40000 ALTER TABLE `medication` DISABLE KEYS */;
INSERT INTO `medication` VALUES (1,'Aspirin','Pain reliever and anti-inflammatory',5.99),(2,'Lisinopril','ACE inhibitor for blood pressure',12.5),(3,'Metformin','Diabetes medication',8.75),(4,'Atorvastatin','Cholesterol medication',15.25),(5,'Omeprazole','Acid reflux medication',9.99),(6,'Amoxicillin','Antibiotic',18.5),(7,'Ibuprofen','Pain and fever reducer',4.99),(8,'Warfarin','Blood thinner',22);
/*!40000 ALTER TABLE `medication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nurse`
--

DROP TABLE IF EXISTS `nurse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nurse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `department_id` int DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_number` (`license_number`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `nurse_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nurse`
--

LOCK TABLES `nurse` WRITE;
/*!40000 ALTER TABLE `nurse` DISABLE KEYS */;
INSERT INTO `nurse` VALUES (1,'Nurse Amanda Bell','RN-2021-001',1,'555-1001'),(2,'Nurse David Carter','RN-2020-045',2,'555-1002'),(3,'Nurse Emma Davis','RN-2022-012',3,'555-1003'),(4,'Nurse Frank Miller','RN-2021-034',4,'555-1004'),(5,'Nurse Grace Robinson','RN-2019-089',5,'555-1005'),(6,'Nurse Hannah Thomas','RN-2023-008',1,'555-1006');
/*!40000 ALTER TABLE `nurse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(120) NOT NULL,
  `last_name` varchar(120) NOT NULL,
  `dob` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'John','Doe','1975-05-15','555-0101'),(2,'Jane','Smith','1982-03-22','555-0102'),(3,'Michael','Brown','1990-08-10','555-0103'),(4,'Emma','Wilson','1988-12-05','555-0104'),(5,'David','Martinez','1995-01-18','555-0105'),(6,'Lisa','Garcia','1980-06-30','555-0106'),(7,'James','Taylor','1992-11-12','555-0107'),(8,'Maria','Rodriguez','1985-09-25','555-0108'),(9,'Isaac','Damiso',NULL,'0987618341');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `id` int DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `ward` varchar(50) DEFAULT NULL,
  `bed` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'isaac damiso','moomba','b13',12),(2,'racheal chulu','moomba','e11',4);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacist`
--

DROP TABLE IF EXISTS `pharmacist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `department_id` int DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `license_number` (`license_number`),
  KEY `department_id` (`department_id`),
  CONSTRAINT `pharmacist_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacist`
--

LOCK TABLES `pharmacist` WRITE;
/*!40000 ALTER TABLE `pharmacist` DISABLE KEYS */;
INSERT INTO `pharmacist` VALUES (1,'Pharmacist Rachel Green','PH-2020-001',6,'555-3001'),(2,'Pharmacist Mark Johnson','PH-2019-045',6,'555-3002'),(3,'Pharmacist Sarah Williams','PH-2021-012',6,'555-3003'),(4,'Pharmacist David Brown','PH-2022-034',6,'555-3004');
/*!40000 ALTER TABLE `pharmacist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacy_inventory`
--

DROP TABLE IF EXISTS `pharmacy_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `medication_id` int NOT NULL,
  `quantity_in_stock` int NOT NULL,
  `reorder_level` int NOT NULL,
  `last_updated` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `medication_id` (`medication_id`),
  CONSTRAINT `pharmacy_inventory_ibfk_1` FOREIGN KEY (`medication_id`) REFERENCES `medication` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacy_inventory`
--

LOCK TABLES `pharmacy_inventory` WRITE;
/*!40000 ALTER TABLE `pharmacy_inventory` DISABLE KEYS */;
INSERT INTO `pharmacy_inventory` VALUES (1,1,20,10,'2026-04-07 19:45:36'),(2,2,100,30,'2026-04-07 17:53:29'),(3,3,120,40,'2026-04-07 17:53:29'),(4,4,80,25,'2026-04-07 17:53:29'),(5,5,90,30,'2026-04-07 17:53:29'),(6,6,60,20,'2026-04-07 17:53:29'),(7,7,200,75,'2026-04-07 17:53:29'),(8,8,45,15,'2026-04-07 17:53:29');
/*!40000 ALTER TABLE `pharmacy_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `medication_id` int NOT NULL,
  `dosage` varchar(120) NOT NULL,
  `frequency` varchar(120) NOT NULL,
  `duration_days` int NOT NULL,
  `prescribed_at` datetime NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `medication_id` (`medication_id`),
  CONSTRAINT `prescription_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`),
  CONSTRAINT `prescription_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctor` (`id`),
  CONSTRAINT `prescription_ibfk_3` FOREIGN KEY (`medication_id`) REFERENCES `medication` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,1,1,'81mg','Once daily',30,'2026-04-07 17:53:29','Take with food'),(2,1,1,4,'20mg','Once daily',30,'2026-04-07 17:53:29','Take in evening'),(3,2,2,7,'400mg','Every 6 hours',7,'2026-04-07 17:53:29','As needed for pain'),(4,3,3,7,'600mg','Every 8 hours',10,'2026-04-07 17:53:29','For knee pain'),(5,4,4,3,'500mg','Twice daily',90,'2026-04-07 17:53:29','With meals'),(6,5,5,6,'500mg','Three times daily',10,'2026-04-07 17:53:29','Complete full course'),(7,6,1,2,'10mg','Once daily',30,'2026-04-07 17:53:29','Monitor blood pressure'),(8,7,6,8,'5mg','Once daily',30,'2026-04-07 17:53:29','Monitor INR levels');
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salary`
--

DROP TABLE IF EXISTS `salary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_type` varchar(50) NOT NULL,
  `staff_id` int NOT NULL,
  `base_salary` float NOT NULL,
  `bonuses` float DEFAULT NULL,
  `deductions` float DEFAULT NULL,
  `net_salary` float NOT NULL,
  `payment_date` date NOT NULL,
  `payment_period_start` date NOT NULL,
  `payment_period_end` date NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary`
--

LOCK TABLES `salary` WRITE;
/*!40000 ALTER TABLE `salary` DISABLE KEYS */;
INSERT INTO `salary` VALUES (1,'doctor',1,150000,5000,1200,153800,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(2,'doctor',2,145000,3000,1100,146900,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(3,'doctor',3,140000,4000,1000,143000,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(4,'nurse',1,75000,1500,600,75900,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(5,'nurse',2,72000,1200,550,72650,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(6,'pharmacist',1,85000,2000,700,86300,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(7,'pharmacist',2,82000,1800,650,83150,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(8,'worker',1,45000,500,300,45200,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment'),(9,'worker',2,42000,400,280,42120,'2026-03-31','2026-03-01','2026-03-31','Monthly salary payment');
/*!40000 ALTER TABLE `salary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(128) NOT NULL,
  `role` varchar(20) NOT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-07 22:05:47
