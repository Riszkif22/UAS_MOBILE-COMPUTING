<?php
// 1. Nyalakan laporan error untuk debugging (biar ketahuan kalau ada salah)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// 2. Header agar bisa diakses dari Flutter
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 3. Cek file koneksi
if (!file_exists('koneksi.php')) {
    die(json_encode(["status" => "error", "message" => "File koneksi.php tidak ditemukan"]));
}

include 'koneksi.php';

// 4. Deteksi otomatis nama variabel koneksi (Jaga-jaga jika beda nama)
if (isset($conn)) {
    $db_connection = $conn;
} elseif (isset($koneksi)) {
    $db_connection = $koneksi;
} else {
    die(json_encode(["status" => "error", "message" => "Variabel koneksi tidak ditemukan (cek apakah \$conn atau \$koneksi)"]));
}

// 5. Cek status koneksi
if (!$db_connection) {
    die(json_encode(["status" => "error", "message" => "Koneksi Database Gagal: " . mysqli_connect_error()]));
}

// 6. Jalankan Query (Sesuai tabel 'users' Anda)
$query = "SELECT id, username, full_name, role, photo_url FROM users ORDER BY id DESC";
$result = mysqli_query($db_connection, $query);

if (!$result) {
    die(json_encode(["status" => "error", "message" => "Query Error: " . mysqli_error($db_connection)]));
}

// 7. Ambil data dan tampilkan sebagai JSON
$response = array();
while ($row = mysqli_fetch_assoc($result)) {
    $response[] = $row;
}

echo json_encode($response);
?>