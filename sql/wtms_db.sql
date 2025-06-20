-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 15, 2025 at 06:26 AM
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
-- Database: `wtms_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_submissions`
--

CREATE TABLE `tbl_submissions` (
  `submission_id` int(11) NOT NULL,
  `work_id` int(11) DEFAULT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `report` text DEFAULT NULL,
  `submitted_at` datetime DEFAULT current_timestamp(),
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_submissions`
--

INSERT INTO `tbl_submissions` (`submission_id`, `work_id`, `worker_id`, `report`, `submitted_at`, `timestamp`) VALUES
(1, 1, 12, 'AC not cooling properly\nDone fix✔️ ', '2025-05-29 20:47:38', '2025-06-15 11:25:15'),
(2, 7, 2, 'Done updating the system software to latest version.\n', '2025-05-29 23:27:14', '2025-06-15 11:25:15'),
(3, 8, 2, 'Repaired fan and confirmed it\'s working fine', '2025-05-29 23:27:54', '2025-06-15 11:25:15'),
(4, 5, 14, 'Light are all in good condition.', '2025-05-29 23:28:47', '2025-06-15 11:25:15');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_works`
--

CREATE TABLE `tbl_works` (
  `work_id` int(11) NOT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_works`
--

INSERT INTO `tbl_works` (`work_id`, `worker_id`, `title`, `description`, `deadline`) VALUES
(1, 12, 'Fix Air Conditioner', 'Check compressor in meeting room', '2025-09-01'),
(2, 12, 'Replace Fuse Box', 'Old fuse in store room needs change', '2025-09-03'),
(3, 12, 'Clean Roof Gutter', 'Before next rain season', '2025-09-05'),
(4, 14, 'Fix broken pipe', 'Check and repair the pipe in the kitchen', '2025-08-30'),
(5, 14, 'Replace light bulb', 'Change all corridor bulbs', '2025-08-31'),
(6, 14, 'Clean storage room', 'Complete by next Monday', '2025-09-01'),
(7, 2, 'Update the system software', 'During the maintenance period', '2025-09-11'),
(8, 2, 'Modify the system security', 'During the maintenance period', '2025-09-05'),
(9, 2, 'Test the new system', 'Check if there is error or something wrong with the interface', '2025-09-05');

-- --------------------------------------------------------

--
-- Table structure for table `workers`
--

CREATE TABLE `workers` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `workers`
--

INSERT INTO `workers` (`id`, `full_name`, `email`, `password`, `phone`, `address`) VALUES
(1, '', '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '', ''),
(2, 'paktai-class', 'umairnorazlan@gmail.com', '9a7149a5a7786bb368e06d08c5d77774eb43a49e', '01223325424', '2A318, TNB, UUM'),
(9, 'John Petrucci', 'johnpetrucci@gmail.com', '9a7149a5a7786bb368e06d08c5d77774eb43a49e', '0123325424', 'Metropolis Pt2, Home'),
(10, 'Yngwie Malmsteen', 'yjm@gmail.com', '9a7149a5a7786bb368e06d08c5d77774eb43a49e', '0123757350', 'Rising Force, Leningrad, 1989'),
(11, 'hadif nasarudin', 'hadif@gmail.com', '9a7149a5a7786bb368e06d08c5d77774eb43a49e', '012345678', 'jempoi'),
(12, 'aimey ruzaimey', 'aiman@gmail.com', '9a7149a5a7786bb368e06d08c5d77774eb43a49e', '012345678', 'Kota Bharu, Kelantan'),
(14, 'Atok Hensem', 'atok@gmail.com', 'ccaa8d8dcc7d030cd6a6768db81f90d0ef976c3d', '01111222333', 'Updated, Kelantan');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `work_id` (`work_id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- Indexes for table `tbl_works`
--
ALTER TABLE `tbl_works`
  ADD PRIMARY KEY (`work_id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- Indexes for table `workers`
--
ALTER TABLE `workers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_works`
--
ALTER TABLE `tbl_works`
  MODIFY `work_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `workers`
--
ALTER TABLE `workers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_submissions`
--
ALTER TABLE `tbl_submissions`
  ADD CONSTRAINT `tbl_submissions_ibfk_1` FOREIGN KEY (`work_id`) REFERENCES `tbl_works` (`work_id`),
  ADD CONSTRAINT `tbl_submissions_ibfk_2` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`);

--
-- Constraints for table `tbl_works`
--
ALTER TABLE `tbl_works`
  ADD CONSTRAINT `tbl_works_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;