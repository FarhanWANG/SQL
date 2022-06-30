-- MySQL dump 10.13  Distrib 8.0.22, for macos10.15 (x86_64)
--
-- Host: localhost    Database: work
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `balance_due_table`
--
use ap;

DROP TABLE IF EXISTS `balance_due_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balance_due_table` (
  `vendor_name` varchar(50) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `invoice_total` decimal(9,2) NOT NULL,
  `payment_total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `credit_total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `balance_due` decimal(11,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balance_due_table`
--

LOCK TABLES `balance_due_table` WRITE;
/*!40000 ALTER TABLE `balance_due_table` DISABLE KEYS */;
INSERT INTO `balance_due_table` VALUES ('Data Reproductions Corp','39104',85.31,0.00,0.00,85.31),('Federal Express Corporation','963253264',52.25,0.00,0.00,52.25),('Ingram','31361833',579.42,0.00,0.00,579.42),('Federal Express Corporation','263253268',59.97,0.00,0.00,59.97),('Federal Express Corporation','263253270',67.92,0.00,0.00,67.92),('Federal Express Corporation','263253273',30.75,0.00,0.00,30.75),('Malloy Lithographing Inc','P-0608',20551.18,0.00,1200.00,19351.18),('Ford Motor Credit Company','9982771',503.20,0.00,300.00,300.00),('Cardinal Business Media, Inc.','134116',90.36,0.00,0.00,90.36),('Malloy Lithographing Inc','0-2436',10976.06,0.00,0.00,10976.06),('Blue Cross','547480102',224.00,0.00,0.00,224.00);
/*!40000 ALTER TABLE `balance_due_table` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-20 13:17:20
