-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 29 Jan 2026 pada 18.04
-- Versi server: 11.4.9-MariaDB-cll-lve
-- Versi PHP: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ujat7577_rilah`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `distance` varchar(20) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `event_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `title`, `distance`, `description`, `image_url`, `event_date`) VALUES
(1, 'Fun Run 5K', '5KM', 'Lari santai cocok untuk pemula.', 'https://rilah.ujangkedu.my.id/images/5.jpeg', '2026-01-31'),
(2, 'Challenger 10K', '10KM', 'Tantang diri anda untuk jarak menengah.', 'https://rilah.ujangkedu.my.id/images/3.jpeg', '2026-01-31'),
(4, 'Full Marathon', '42KM', 'Lari jarak jauh untuk profesional.', 'https://rilah.ujangkedu.my.id/images/4.jpeg', '2026-01-31'),
(6, 'Half Marathon', '21KM', 'Lari sekuat tenaga dan selesaikan penderitaannya', 'https://rilah.ujangkedu.my.id/api/uploads/event_1769091007.jpg', '2026-01-31'),
(7, 'Jakarta International Marathon', '10KM', 'berlari bersama atlet atlet manca negara', 'https://rilah.ujangkedu.my.id/api/uploads/event_1768930246.jpg', '2026-05-30'),
(9, 'Jakarta International Marathon', '21KM', 'Berlari bersama atlet atlet manca negara', 'https://rilah.ujangkedu.my.id/api/uploads/event_1769019498.jpg', '2026-05-30'),
(10, 'Jakarta International Marathon ', '42KM', 'Berlari bersama atlet atlet manca negara', 'https://rilah.ujangkedu.my.id/api/uploads/event_1769019594.jpg', '2026-05-30'),
(12, 'asdsada', '42KM', '', '', '2026-01-31');

-- --------------------------------------------------------

--
-- Struktur dari tabel `registrations`
--

CREATE TABLE `registrations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `reg_date` datetime DEFAULT current_timestamp(),
  `bib_name` varchar(50) DEFAULT NULL,
  `shirt_size` varchar(5) DEFAULT NULL,
  `emergency_contact` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `registrations`
--

INSERT INTO `registrations` (`id`, `user_id`, `category_id`, `reg_date`, `bib_name`, `shirt_size`, `emergency_contact`) VALUES
(6, 4, 6, '2026-01-21 11:45:06', 'riszki', 'XL', '085874221437'),
(7, 5, 9, '2026-01-22 10:45:11', 'ujang', 'XL', '085864221437'),
(8, 7, 1, '2026-01-22 21:23:51', 'hshshs', '5454', '72828272');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` varchar(10) DEFAULT 'user',
  `photo_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `role`, `photo_url`) VALUES
(2, 'admin', 'admin123', 'Administrator', 'admin', 'https://rilah.ujangkedu.my.id/api/uploads/profile_2_1768919601.jpg'),
(4, 'riszki', 'riszki123', 'riszki fadhillah', 'user', 'https://rilah.ujangkedu.my.id/api/uploads/profile_4_1768927226.jpg'),
(5, 'ujangkedu', '123456', 'ujang kedu', 'user', 'https://rilah.ujangkedu.my.id/api/uploads/profile_5_1768961261.jpg'),
(6, 'akhdan12', '12345678', 'akhdan', 'user', NULL),
(7, 'test1', '123456789', 'test1', 'user', NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `registrations`
--
ALTER TABLE `registrations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `registrations`
--
ALTER TABLE `registrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `registrations`
--
ALTER TABLE `registrations`
  ADD CONSTRAINT `registrations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `registrations_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
