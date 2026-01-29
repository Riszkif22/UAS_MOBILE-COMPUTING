<?php
include 'koneksi.php';

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = mysqli_query($conn, $sql);

if ($result && mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    echo json_encode([
        "status" => "success", 
        "user_id" => $row['id'], 
        "name" => $row['full_name'],
        "role" => $row['role'],
        "photo_url" => $row['photo_url'] // PENTING: Kirim URL foto
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Login Gagal"]);
}
?>