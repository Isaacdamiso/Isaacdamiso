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
-- Temporary view structure for view `active_appointments`
--

DROP TABLE IF EXISTS `active_appointments`;
/*!50001 DROP VIEW IF EXISTS `active_appointments`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `active_appointments` AS SELECT 
 1 AS `appointment_id`,
 1 AS `scheduled_at`,
 1 AS `patient_name`,
 1 AS `doctor_info`,
 1 AS `department`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1,1,1,787.2,787.2,'paid','2026-04-08 06:57:16'),(2,2,2,269.86,100,'partial','2026-04-08 06:57:16'),(3,3,3,349.8,0,'unpaid','2026-04-08 06:57:16'),(4,4,4,120,120,'paid','2026-04-08 06:57:16'),(5,5,5,500,250,'partial','2026-04-08 06:57:16'),(6,6,6,555,555,'paid','2026-04-08 06:57:16'),(7,7,NULL,0,0,'unpaid','2026-04-08 06:59:32');
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
-- Temporary view structure for view `bills_summary`
--

DROP TABLE IF EXISTS `bills_summary`;
/*!50001 DROP VIEW IF EXISTS `bills_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `bills_summary` AS SELECT 
 1 AS `patient_name`,
 1 AS `created_at`,
 1 AS `total_amount`,
 1 AS `status`,
 1 AS `itemized_total`*/;
SET character_set_client = @saved_cs_client;

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
-- Temporary view structure for view `department_stats`
--

DROP TABLE IF EXISTS `department_stats`;
/*!50001 DROP VIEW IF EXISTS `department_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `department_stats` AS SELECT 
 1 AS `dept_id`,
 1 AS `department_name`,
 1 AS `doctor_count`,
 1 AS `nurse_count`,
 1 AS `total_appointments`,
 1 AS `worker_count`*/;
SET character_set_client = @saved_cs_client;

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
INSERT INTO `dispensing_record` VALUES (1,1,1,30,'2026-04-08 06:57:15','First fill'),(2,2,1,30,'2026-04-08 06:57:15','First fill'),(3,3,2,14,'2026-04-08 06:57:15','Emergency fill'),(4,4,3,20,'2026-04-08 06:57:15','Partial fill'),(5,6,4,30,'2026-04-08 06:57:15','New prescription');
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
-- Temporary view structure for view `doctor_workload`
--

DROP TABLE IF EXISTS `doctor_workload`;
/*!50001 DROP VIEW IF EXISTS `doctor_workload`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `doctor_workload` AS SELECT 
 1 AS `doctor_id`,
 1 AS `doctor_name`,
 1 AS `specialty`,
 1 AS `department`,
 1 AS `total_appointments`,
 1 AS `upcoming_appointments`*/;
SET character_set_client = @saved_cs_client;

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
-- Temporary view structure for view `low_stock_alert`
--

DROP TABLE IF EXISTS `low_stock_alert`;
/*!50001 DROP VIEW IF EXISTS `low_stock_alert`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `low_stock_alert` AS SELECT 
 1 AS `inventory_id`,
 1 AS `medication_name`,
 1 AS `quantity_in_stock`,
 1 AS `reorder_level`,
 1 AS `shortage_amount`,
 1 AS `last_updated`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'John','Doe','1975-05-15','555-0101'),(2,'Jane','Smith','1982-03-22','555-0102'),(3,'Michael','Brown','1990-08-10','555-0103'),(4,'Emma','Wilson','1988-12-05','555-0104'),(5,'David','Martinez','1995-01-18','555-0105'),(6,'Lisa','Garcia','1980-06-30','555-0106'),(7,'James','Taylor','1992-11-12','555-0107'),(8,'Maria','Rodriguez','1985-09-25','555-0108');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `patient_medications`
--

DROP TABLE IF EXISTS `patient_medications`;
/*!50001 DROP VIEW IF EXISTS `patient_medications`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patient_medications` AS SELECT 
 1 AS `patient_id`,
 1 AS `patient_name`,
 1 AS `medication_name`,
 1 AS `dosage`,
 1 AS `frequency`,
 1 AS `prescribed_at`,
 1 AS `expiry_date`,
 1 AS `days_remaining`*/;
SET character_set_client = @saved_cs_client;

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
INSERT INTO `pharmacy_inventory` VALUES (1,1,150,50,'2026-04-08 06:57:15'),(2,2,100,30,'2026-04-08 06:57:15'),(3,3,120,40,'2026-04-08 06:57:15'),(4,4,80,25,'2026-04-08 06:57:15'),(5,5,90,30,'2026-04-08 06:57:15'),(6,6,60,20,'2026-04-08 06:57:15'),(7,7,200,75,'2026-04-08 06:57:15'),(8,8,45,15,'2026-04-08 06:57:15');
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
INSERT INTO `prescription` VALUES (1,1,1,1,'81mg','Once daily',30,'2026-04-08 06:57:15','Take with food'),(2,1,1,4,'20mg','Once daily',30,'2026-04-08 06:57:15','Take in evening'),(3,2,2,7,'400mg','Every 6 hours',7,'2026-04-08 06:57:15','As needed for pain'),(4,3,3,7,'600mg','Every 8 hours',10,'2026-04-08 06:57:15','For knee pain'),(5,4,4,3,'500mg','Twice daily',90,'2026-04-08 06:57:15','With meals'),(6,5,5,6,'500mg','Three times daily',10,'2026-04-08 06:57:15','Complete full course'),(7,6,1,2,'10mg','Once daily',30,'2026-04-08 06:57:15','Monitor blood pressure'),(8,7,6,8,'5mg','Once daily',30,'2026-04-08 06:57:15','Monitor INR levels');
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

--
-- Final view structure for view `active_appointments`
--

/*!50001 DROP VIEW IF EXISTS `active_appointments`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`isaac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `active_appointments` AS select `a`.`id` AS `appointment_id`,`a`.`scheduled_at` AS `scheduled_at`,concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,concat(`d`.`name`,' (',`d`.`specialty`,')') AS `doctor_info`,`dept`.`name` AS `department` from (((`appointment` `a` join `patient` `p` on((`a`.`patient_id` = `p`.`id`))) join `doctor` `d` on((`a`.`doctor_id` = `d`.`id`))) join `department` `dept` on((`d`.`department_id` = `dept`.`id`))) where (`a`.`scheduled_at` >= now()) order by `a`.`scheduled_at` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `bills_summary`
--

/*!50001 DROP VIEW IF EXISTS `bills_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`isaac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `bills_summary` AS select concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,`b`.`created_at` AS `created_at`,`b`.`total_amount` AS `total_amount`,`b`.`status` AS `status`,sum(`bi`.`total_price`) AS `itemized_total` from ((`bill` `b` join `patient` `p` on((`b`.`patient_id` = `p`.`id`))) left join `bill_item` `bi` on((`b`.`id` = `bi`.`bill_id`))) group by `b`.`id` order by `b`.`created_at` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `department_stats`
--

/*!50001 DROP VIEW IF EXISTS `department_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`isaac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `department_stats` AS select `dept`.`id` AS `dept_id`,`dept`.`name` AS `department_name`,count(distinct `d`.`id`) AS `doctor_count`,count(distinct `n`.`id`) AS `nurse_count`,count(distinct `a`.`id`) AS `total_appointments`,count(distinct `w`.`id`) AS `worker_count` from ((((`department` `dept` left join `doctor` `d` on((`dept`.`id` = `d`.`department_id`))) left join `nurse` `n` on((`dept`.`id` = `n`.`department_id`))) left join `appointment` `a` on((`d`.`id` = `a`.`doctor_id`))) left join `general_worker` `w` on((`dept`.`id` = `w`.`department_id`))) group by `dept`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `doctor_workload`
--

/*!50001 DROP VIEW IF EXISTS `doctor_workload`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`isaac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `doctor_workload` AS select `d`.`id` AS `doctor_id`,`d`.`name` AS `doctor_name`,`d`.`specialty` AS `specialty`,`dept`.`name` AS `department`,count(`a`.`id`) AS `total_appointments`,sum((case when (`a`.`scheduled_at` >= now()) then 1 else 0 end)) AS `upcoming_appointments` from ((`doctor` `d` left join `department` `dept` on((`d`.`department_id` = `dept`.`id`))) left join `appointment` `a` on((`d`.`id` = `a`.`doctor_id`))) group by `d`.`id` order by `upcoming_appointments` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `low_stock_alert`
--

/*!50001 DROP VIEW IF EXISTS `low_stock_alert`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`isaac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `low_stock_alert` AS select `pi`.`id` AS `inventory_id`,`m`.`name` AS `medication_name`,`pi`.`quantity_in_stock` AS `quantity_in_stock`,`pi`.`reorder_level` AS `reorder_level`,(`pi`.`reorder_level` - `pi`.`quantity_in_stock`) AS `shortage_amount`,`pi`.`last_updated` AS `last_updated` from (`pharmacy_inventory` `pi` join `medication` `m` on((`pi`.`medication_id` = `m`.`id`))) where (`pi`.`quantity_in_stock` <= `pi`.`reorder_level`) order by (`pi`.`reorder_level` - `pi`.`quantity_in_stock`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patient_medications`
--

/*!50001 DROP VIEW IF EXISTS `patient_medications`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`isaac`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patient_medications` AS select `p`.`id` AS `patient_id`,concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`,`m`.`name` AS `medication_name`,`pr`.`dosage` AS `dosage`,`pr`.`frequency` AS `frequency`,`pr`.`prescribed_at` AS `prescribed_at`,(`pr`.`prescribed_at` + interval `pr`.`duration_days` day) AS `expiry_date`,(to_days((`pr`.`prescribed_at` + interval `pr`.`duration_days` day)) - to_days(now())) AS `days_remaining` from ((`patient` `p` join `prescription` `pr` on((`p`.`id` = `pr`.`patient_id`))) join `medication` `m` on((`pr`.`medication_id` = `m`.`id`))) where ((`pr`.`prescribed_at` + interval `pr`.`duration_days` day) >= now()) order by (`pr`.`prescribed_at` + interval `pr`.`duration_days` day) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08 10:13:56
