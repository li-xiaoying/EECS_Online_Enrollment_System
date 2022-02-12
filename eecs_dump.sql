-- MariaDB dump 10.17  Distrib 10.4.11-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: 
-- ------------------------------------------------------
-- Server version	10.4.15-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;




--
-- Table structure for table `eecs_classrooms`
--

DROP TABLE IF EXISTS `eecs_classrooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eecs_classrooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `capacity` int(11) NOT NULL,
  `building` varchar(50) NOT NULL,
  `floor` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eecs_classrooms`
--

LOCK TABLES `eecs_classrooms` WRITE;
/*!40000 ALTER TABLE `eecs_classrooms` DISABLE KEYS */;
INSERT INTO `eecs_classrooms` VALUES (1,100,'building#1',3,'type#1'),(2,90,'building#4',4,'type#2'),(3,120,'building#6',5,'type#3'),(4,150,'building#8',6,'type#4');
/*!40000 ALTER TABLE `eecs_classrooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eecs_courses`
--

DROP TABLE IF EXISTS `eecs_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eecs_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `current_term_offered` tinyint(1) NOT NULL,
  `capacity` int(11) NOT NULL,
  `instructor_id` int(11) DEFAULT NULL,
  `classroom_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),

  CONSTRAINT `eecs_courses_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `eecs_instructors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `eecs_courses_ibfk_2` FOREIGN KEY (`classroom_id`) REFERENCES `eecs_classrooms` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eecs_courses`
--

LOCK TABLES `eecs_courses` WRITE;
/*!40000 ALTER TABLE `eecs_courses` DISABLE KEYS */;
INSERT INTO `eecs_courses` VALUES (1,'CS340',1,90,1,1),(2,'CS290',1,80,2,2),(3,'CS275',1,90,1,3),(4,'CS360',0,80,2,1);
/*!40000 ALTER TABLE `eecs_courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eecs_instructors`
--

DROP TABLE IF EXISTS `eecs_instructors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eecs_instructors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(10) NOT NULL,
  `last_name` varchar(10) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `date_of_birth` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eecs_instructors`
--

LOCK TABLES `eecs_instructors` WRITE;
/*!40000 ALTER TABLE `eecs_instructors` DISABLE KEYS */;
INSERT INTO `eecs_instructors` VALUES (1,'Corbin','Davidson','male','1990-10-16'),(2,'Alana','Jordan','female','1993-04-01'),(3,'Arsalan','Wormald','other','1975-11-21');
/*!40000 ALTER TABLE `eecs_instructors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eecs_students`
--

DROP TABLE IF EXISTS `eecs_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eecs_students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(10) NOT NULL,
  `last_name` varchar(10) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `date_of_birth` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eecs_students`
--

LOCK TABLES `eecs_students` WRITE;
/*!40000 ALTER TABLE `eecs_students` DISABLE KEYS */;
INSERT INTO `eecs_students` VALUES (1,'Jeanne','Trevino','male','2000-08-16'),(2,'Kayla','Sullivan','female','2001-09-01'),(3,'Monique','Sims','other','2002-07-21');
/*!40000 ALTER TABLE `eecs_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eecs_students_courses`
--

DROP TABLE IF EXISTS `eecs_students_courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eecs_students_courses` (
  `student_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  UNIQUE (`student_id`,`course_id`),
  
  CONSTRAINT `eecs_students_courses_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `eecs_students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `eecs_students_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `eecs_courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eecs_students_courses`
--

LOCK TABLES `eecs_students_courses` WRITE;
/*!40000 ALTER TABLE `eecs_students_courses` DISABLE KEYS */;
INSERT INTO `eecs_students_courses` VALUES (1,1),(1,2),(2,1),(3,3);
/*!40000 ALTER TABLE `eecs_students_courses` ENABLE KEYS */;
UNLOCK TABLES;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-14 20:26:40
