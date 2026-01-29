<?php
include 'koneksi.php';
$id = $_POST['id'];
$sql = "DELETE FROM registrations WHERE id = '$id'";
if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error"]);
}
?>