<?php
$host = "localhost";
$user = "ujat7577_rilah"; 
$pass = "Sjtalj234567";
$db   = "ujat7577_rilah";

$conn = mysqli_connect($host, $user, $pass, $db);
if (!$conn) { die("Connection failed: " . mysqli_connect_error()); }

header('Content-Type: application/json');
?>