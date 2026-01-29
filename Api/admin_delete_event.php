<?php
include 'koneksi.php';
$id = $_POST['id'];
// Hapus registrasi terkait dulu agar tidak error constraint
mysqli_query($conn, "DELETE FROM registrations WHERE category_id='$id'");
$sql = "DELETE FROM categories WHERE id='$id'";
if(mysqli_query($conn, $sql)){ echo json_encode(["status" => "success"]); }
else { echo json_encode(["status" => "error"]); }
?>