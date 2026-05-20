-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 20, 2026 at 09:42 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `examen`
--

-- --------------------------------------------------------

--
-- Table structure for table `etudiant`
--

CREATE TABLE `etudiant` (
  `num_etudiant` varchar(20) NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `prenoms` varchar(50) DEFAULT NULL,
  `niveau` enum('L1','L2','L3','M1','M2') DEFAULT NULL,
  `adr_email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `etudiant`
--

INSERT INTO `etudiant` (`num_etudiant`, `nom`, `prenoms`, `niveau`, `adr_email`) VALUES
('003', 'Robert', 'Lol', 'L1', 'kk@gmail.com'),
('004', 'Henry', 'Henry ', 'L2', 'henry@gmail.com'),
('1996', 'Manjakavelo', 'Anjara', 'L3', 'anjaramanjakavelo@gmail.com'),
('E001', 'Test', 'Atest', 'L1', 'test@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `examen`
--

CREATE TABLE `examen` (
  `num_exam` int(11) NOT NULL,
  `num_etudiant` varchar(20) DEFAULT NULL,
  `annee_univ` varchar(9) DEFAULT NULL,
  `note` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `examen`
--

INSERT INTO `examen` (`num_exam`, `num_etudiant`, `annee_univ`, `note`) VALUES
(4, '1996', '2025-2026', 1);

-- --------------------------------------------------------

--
-- Table structure for table `qcm`
--

CREATE TABLE `qcm` (
  `num_quest` int(11) NOT NULL,
  `question` text DEFAULT NULL,
  `reponse1` text DEFAULT NULL,
  `reponse2` text DEFAULT NULL,
  `reponse3` text DEFAULT NULL,
  `reponse4` text DEFAULT NULL,
  `bonne_reponse` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qcm`
--

INSERT INTO `qcm` (`num_quest`, `question`, `reponse1`, `reponse2`, `reponse3`, `reponse4`, `bonne_reponse`) VALUES
(2, 'poutqoui?', 'car', 'parceque', 'oui', 'sinon', 2);

-- --------------------------------------------------------

--
-- Table structure for table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `role` enum('ADMIN','ETUDIANT') NOT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `utilisateur`
--

INSERT INTO `utilisateur` (`id_user`, `username`, `mot_de_passe`, `role`, `email`) VALUES
(1, 'admin', 'admin123', 'ADMIN', 'admin@gmail.com'),
(2, 'test@gmail.com', 'qwerty', 'ETUDIANT', 'test@gmail.com'),
(3, 'anjaramanjakavelo@gmail.com', 'azerty', 'ETUDIANT', 'anjaramanjakavelo@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `etudiant`
--
ALTER TABLE `etudiant`
  ADD PRIMARY KEY (`num_etudiant`);

--
-- Indexes for table `examen`
--
ALTER TABLE `examen`
  ADD PRIMARY KEY (`num_exam`),
  ADD KEY `num_etudiant` (`num_etudiant`);

--
-- Indexes for table `qcm`
--
ALTER TABLE `qcm`
  ADD PRIMARY KEY (`num_quest`);

--
-- Indexes for table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `examen`
--
ALTER TABLE `examen`
  MODIFY `num_exam` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `qcm`
--
ALTER TABLE `qcm`
  MODIFY `num_quest` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `examen`
--
ALTER TABLE `examen`
  ADD CONSTRAINT `examen_ibfk_1` FOREIGN KEY (`num_etudiant`) REFERENCES `etudiant` (`num_etudiant`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
