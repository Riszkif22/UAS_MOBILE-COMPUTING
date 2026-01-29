<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include 'koneksi.php';

$id = $_POST['id'];
$shirt_size = $_POST['shirt_size'];

if ($id && $shirt_size) {
    $query = "UPDATE registrations SET shirt_size = '$shirt_size' WHERE id = '$id'";
    
    // Pakai $conn
    if (mysqli_query($conn, $query)) {
        echo json_encode(array("status" => "success", "message" => "Ukuran baju berhasil diubah"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Gagal mengubah data"));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Data tidak lengkap"));
}
?>