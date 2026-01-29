<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

// Pastikan koneksi berhasil
if (!$conn) {
    die(json_encode([]));
}

// PERBAIKAN DI SINI: tambahkan "ORDER BY id DESC"
// DESC (Descending) artinya urutkan dari ID paling besar (terbaru) ke kecil (terlama)
$query = "SELECT * FROM categories ORDER BY id DESC"; 

$result = mysqli_query($conn, $query);
$response = array();

if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $response[] = $row;
    }
}

echo json_encode($response);
?>