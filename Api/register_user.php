<?php
include 'koneksi.php';
$username = $_POST['username'];
$password = $_POST['password'];
$full_name = $_POST['full_name'];
$role = 'user'; // Default role

$check = mysqli_query($conn, "SELECT * FROM users WHERE username='$username'");
if(mysqli_num_rows($check) > 0){
    echo json_encode(["status" => "error", "message" => "Username sudah ada"]);
} else {
    $sql = "INSERT INTO users (username, password, full_name, role) VALUES ('$username', '$password', '$full_name', '$role')";
    if(mysqli_query($conn, $sql)){
        echo json_encode(["status" => "success", "message" => "Registrasi Berhasil"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal Register"]);
    }
}
?>