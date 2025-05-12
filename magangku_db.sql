-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2025 at 06:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `magangku_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `izin_cuti`
--

CREATE TABLE `izin_cuti` (
  `id` int(11) NOT NULL,
  `jenis_cuti` varchar(255) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `keterangan` text DEFAULT NULL,
  `lampiran_path` varchar(255) DEFAULT NULL,
  `tanggal_pengajuan` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) DEFAULT 'diajukan',
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `izin_cuti`
--

INSERT INTO `izin_cuti` (`id`, `jenis_cuti`, `tanggal_mulai`, `tanggal_selesai`, `keterangan`, `lampiran_path`, `tanggal_pengajuan`, `status`, `user_id`) VALUES
(165, 'hh', '2025-04-23', '2025-04-24', 'Isi Keterangan yang sesuaikaka', NULL, '2025-04-23 07:25:19', 'diajukan', 19),
(166, 'sakit', '2025-04-23', '2025-04-24', 'saya sakit', NULL, '2025-04-23 07:32:12', 'diajukan', 19),
(167, 'sakit', '2025-04-23', '2025-04-24', 'hhh', NULL, '2025-04-23 15:36:25', 'diajukan', 19);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `used_at` timestamp NULL DEFAULT NULL,
  `new_password` varchar(255) DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `presensi_masuk`
--

CREATE TABLE `presensi_masuk` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `nim` varchar(8) NOT NULL,
  `tanggal` date NOT NULL,
  `waktu` time NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `aktivitas` text NOT NULL,
  `path_foto` varchar(255) NOT NULL,
  `user_id` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `presensi_masuk`
--

INSERT INTO `presensi_masuk` (`id`, `nama`, `nim`, `tanggal`, `waktu`, `lokasi`, `aktivitas`, `path_foto`, `user_id`) VALUES
(21, 'pak tarjo', '', '2025-04-25', '14:48:54', 'Lat: -6.201107, Lng: 106.896134', '', 'uploads/presensi/680b3e65f3d6b_image.jpg', 10),
(63, 'pak tarjo', '', '2025-04-25', '14:23:17', 'Lat: -6.201099, Lng: 106.896132', '', 'uploads/presensi/680b386543c14_image.jpg', 10),
(64, 'pak tarjo', '', '2025-04-25', '14:23:42', 'Lat: -6.201106, Lng: 106.896134', '', 'uploads/presensi/680b387ec0d69_image.jpg', 10),
(65, 'pak tarjo', '', '2025-04-25', '14:43:34', 'Lat: -6.201106, Lng: 106.896137', '', 'uploads/presensi/680b3d263ab34_image.jpg', 21),
(66, 'pak tarjo', '', '2025-04-25', '14:45:42', 'Lat: -6.201099, Lng: 106.896141', '', 'uploads/presensi/680b3da671628_image.jpg', 21),
(68, 'pak tarjo', '', '2025-04-25', '15:37:24', 'Lat: -6.201104, Lng: 106.896141', '', 'uploads/presensi/680b49c423d5c_image.jpg', 10),
(69, 'pak tarjo', '', '2025-04-25', '00:06:18', 'Lat: -6.201107, Lng: 106.896140', '', 'uploads/presensi/680bc10a84952_image.jpg', 10),
(70, 'pak tarjo', '', '2025-04-25', '00:06:19', 'Lat: -6.201107, Lng: 106.896140', '', 'uploads/presensi/680bc10b250f7_image.jpg', 10),
(71, 'pak tarjo', '', '2025-04-25', '00:07:08', 'Lat: -6.201088, Lng: 106.896124', '', 'uploads/presensi/680bc13cd1c65_image.jpg', 10);

-- --------------------------------------------------------

--
-- Table structure for table `presensi_pulang`
--

CREATE TABLE `presensi_pulang` (
  `id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `nim` varchar(8) NOT NULL,
  `tanggal` date NOT NULL,
  `waktu` time NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `aktivitas` text NOT NULL,
  `path_foto` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `presensi_pulang`
--

INSERT INTO `presensi_pulang` (`id`, `user_id`, `nama`, `nim`, `tanggal`, `waktu`, `lokasi`, `aktivitas`, `path_foto`) VALUES
(17, 10, 'pak tarjo', '2025-04-', '0000-00-00', '00:00:00', 'Lat: -6.201107, Lng: 106.896136', '', 'uploads/presensi/680b389aa4ec3_image.jpg'),
(18, 10, 'pak tarjo', '', '2025-04-25', '09:25:46', 'Lat: -6.201102, Lng: 106.896137', '', 'uploads/presensi/680b38fa65ede_image.jpg'),
(19, 10, 'pak tarjo', '', '2025-04-25', '09:45:51', 'Lat: -6.201107, Lng: 106.896141', '', 'uploads/presensi/680b3daf720a5_image.jpg'),
(20, 21, 'pak tarjo', '', '2025-04-25', '09:49:02', 'Lat: -6.201106, Lng: 106.896134', '', 'uploads/presensi/680b3e6e83497_image.jpg'),
(21, 21, 'pak tarjo', '', '2025-04-25', '19:07:21', 'Lat: -6.201100, Lng: 106.896140', '', 'uploads/presensi/680bc149cb672_image.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `program_studi` varchar(255) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `foto_profil` varchar(255) DEFAULT NULL,
  `nim` int(8) NOT NULL,
  `nama_perusahaan` varchar(255) NOT NULL,
  `alamat_perusahaan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `nama`, `program_studi`, `telepon`, `email`, `foto_profil`, `nim`, `nama_perusahaan`, `alamat_perusahaan`) VALUES
(19, 'maulana', '12345', 'mahasiswa', 'mpok yen', 'teknologi agroindustri', '082233499292', 'fajrimaulanamaulana008@gmail.com', '', 0, '', ''),
(20, 'fajri', '12345', 'mahasiswa', 'mpok ', 'sistem', '082233499292', 'fajrimaulanamaulana008@gmail.com', 'uploads/profile/680a5adc2f6dc_1000411758.jpg', 0, '', ''),
(21, 'yuyu', '12345', 'mahasiswa', 'pak tarjo bau', 'Teknologi agroindustri', '082233499292', 'fajrimaulanamaulana008@gmail.com', NULL, 21260009, 'dinas', 'yuhuu'),
(26, 'admin', '12345', 'admin', 'admin', 'Teknik Informatika', NULL, 'admin@gmail.com', NULL, 0, '', ''),
(27, 'pembimbing', '12345', 'mentor', 'pembimbing', 'prodi', '', '', 'uploads/profile/680c838197f2e_1000413883.jpg', 21260009, '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `izin_cuti`
--
ALTER TABLE `izin_cuti`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `email` (`email`),
  ADD KEY `token` (`token`);

--
-- Indexes for table `presensi_masuk`
--
ALTER TABLE `presensi_masuk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `presensi_pulang`
--
ALTER TABLE `presensi_pulang`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `unique_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `izin_cuti`
--
ALTER TABLE `izin_cuti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `presensi_masuk`
--
ALTER TABLE `presensi_masuk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `presensi_pulang`
--
ALTER TABLE `presensi_pulang`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `izin_cuti`
--
ALTER TABLE `izin_cuti`
  ADD CONSTRAINT `izin_cuti_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
