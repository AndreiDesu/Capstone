-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 05, 2025 at 04:22 PM
-- Server version: 9.4.0
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `capstone`
--

-- --------------------------------------------------------

--
-- Table structure for table `amenities`
--

CREATE TABLE `amenities` (
  `amenity_id` int NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `amenities`
--

INSERT INTO `amenities` (`amenity_id`, `name`) VALUES
(1, 'Kiddie pool'),
(2, 'Adult pool'),
(4, 'Queen-sized beds'),
(5, 'Wifi'),
(6, 'Smart TV'),
(7, 'Kitchen'),
(8, 'Karaoke'),
(9, 'Grill'),
(10, 'Gas Stove'),
(11, 'Water Dispenser'),
(12, 'Electric Fan'),
(13, 'Electric Kettle'),
(14, 'Billiards table');

-- --------------------------------------------------------

--
-- Table structure for table `carousel`
--

CREATE TABLE `carousel` (
  `id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `image_url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `carousel`
--

INSERT INTO `carousel` (`id`, `title`, `image_url`) VALUES
(1, 'Promo 1', 'Pict1.jpg'),
(2, 'Promo 2', 'pict2.jpg'),
(3, 'Promo 3', 'pict3.jpg'),
(4, 'Promo 4', 'pict4.jpg'),
(5, 'Promo 5', 'pict5.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `package_type_id` int NOT NULL,
  `package_name` varchar(50) DEFAULT NULL,
  `week_schedule` varchar(50) DEFAULT NULL,
  `day_type` varchar(50) DEFAULT NULL,
  `hours` varchar(50) DEFAULT NULL,
  `price` varchar(50) DEFAULT NULL,
  `amenities_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `packages`
--

INSERT INTO `packages` (`package_type_id`, `package_name`, `week_schedule`, `day_type`, `hours`, `price`, `amenities_id`) VALUES
(1, 'Phase 1 / Phase 2', 'Weekday', 'Day Tour', '9 Hours', '8500', 1),
(2, 'Phase 1 / Phase 2', 'Weekend', 'Day Tour', '9 Hours', '9500', NULL),
(3, 'Phase 1 / Phase 2', 'Weekday', 'Overnight', '9 Hours', '11000', NULL),
(4, 'Phase 1 / Phase 2', 'Weekend', 'Overnight', '9 Hours', '10000', 1),
(5, 'Phase 1 / Phase 2', 'Weekday', 'Whole Day', '21 Hours', '18000', NULL),
(6, 'Phase 1 / Phase 2', 'Weekend', 'Whole Day', '21 Hours', '19000', NULL),
(7, 'All-in', 'Weekday', 'Day Tour', '9 Hours', '10000', NULL),
(8, 'All-in', 'Weekend', 'Day Tour', '9 Hours', '11000', NULL),
(9, 'All-in', 'Weekday', 'Overnight', '9 Hours', '11000', NULL),
(10, 'All-in', 'Weekend', 'Overnight', '9 Hours', '11000', 1),
(13, 'Events Place', 'Weekday / Weekend', 'Day Tour / Whole Day', '5 hours + Succeeding', '10000 + 1500 per succeeding', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `package_amenity`
--

CREATE TABLE `package_amenity` (
  `package_type_id` int NOT NULL,
  `amenity_id` varchar(99) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL,
  `user_id` int NOT NULL,
  `package_type_id` int NOT NULL,
  `reservation_date` date NOT NULL,
  `check_in` datetime NOT NULL,
  `check_out` datetime NOT NULL,
  `guests_count` int DEFAULT '1',
  `special_request` text,
  `status` enum('Pending','Approved','Declined','Cancelled','Completed') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `note` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `roleid` int NOT NULL,
  `rolename` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`roleid`, `rolename`) VALUES
(1, 'Admin'),
(2, 'User'),
(3, 'Staff');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `mi` varchar(5) DEFAULT NULL,
  `address` text,
  `email` varchar(100) DEFAULT NULL,
  `contact` varchar(15) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `roleid` int DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `firstname`, `lastname`, `mi`, `address`, `email`, `contact`, `password`, `roleid`) VALUES
(10, 'admin', 'admin', 'admin', 'admin', 'admin@gmail.com', '123123131', 'admin', 1),
(11, 'user', 'user', 'user', 'user', 'user@gmail.com', '12312312', 'user', 2),
(12, 'staff', 'staff', 'staff', 'staff', 'staff@gmail.com', '123123123123', 'staff', 3),
(13, 'arjay', 'dagoro', 'asd', 'asdasdasd', 'arjaydagoro1234@gmail.com', '09354062459', 'dagoro123', 2),
(14, 'tes', 'test', 'test', 'test', 'test@gmail.com', '123', 'test', 2),
(17, 'Mc Neil', 'Dela Pena', 'P.', 'B2 L9', 'mcneil@gmail.com', '09756084702', 'mcneil', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `amenities`
--
ALTER TABLE `amenities`
  ADD PRIMARY KEY (`amenity_id`);

--
-- Indexes for table `carousel`
--
ALTER TABLE `carousel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`package_type_id`);

--
-- Indexes for table `package_amenity`
--
ALTER TABLE `package_amenity`
  ADD PRIMARY KEY (`package_type_id`,`amenity_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reservation_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `package_type_id` (`package_type_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`roleid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `amenities`
--
ALTER TABLE `amenities`
  MODIFY `amenity_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `carousel`
--
ALTER TABLE `carousel`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `roleid` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`package_type_id`) REFERENCES `packages` (`package_type_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
