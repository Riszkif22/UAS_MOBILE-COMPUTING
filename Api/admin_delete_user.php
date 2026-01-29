<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include 'koneksi.php';

$id = $_POST['id'];

if ($id) {
    // Pakai $conn di sini
    mysqli_query($conn, "DELETE FROM registrations WHERE user_id = '$id'"); 

    $query = "DELETE FROM users WHERE id = '$id'";
    
    // Pakai $conn di sini juga
    if (mysqli_query($conn, $query)) {
        echo json_encode(array("status" => "success", "message" => "User berhasil dihapus"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Gagal menghapus user"));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "ID tidak ditemukan"));
}
?>