<?php
include 'koneksi.php';
$user_id = $_POST['user_id'];
$category_id = $_POST['category_id'];
$bib = $_POST['bib_name'];
$size = $_POST['shirt_size'];
$contact = $_POST['emergency_contact'];

$sql = "INSERT INTO registrations (user_id, category_id, bib_name, shirt_size, emergency_contact) VALUES ('$user_id', '$category_id', '$bib', '$size', '$contact')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success", "message" => "Berhasil Mendaftar"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal Mendaftar"]);
}
?>