<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$user_id = $_GET['user_id'];

// PERBAIKAN DI SINI:
// Saya menambahkan kolom 'bib_name', 'shirt_size', 'emergency_contact', dll.
$sql = "SELECT 
            registrations.id, 
            registrations.reg_date,
            registrations.bib_name, 
            registrations.shirt_size, 
            registrations.emergency_contact,
            categories.title, 
            categories.distance,
            categories.event_date,
            categories.description,
            categories.image_url
        FROM registrations 
        JOIN categories ON registrations.category_id = categories.id 
        WHERE registrations.user_id = '$user_id'
        ORDER BY registrations.id DESC"; // Urutkan dari yang terbaru

$query = mysqli_query($conn, $sql);
$data = array();

while($row = mysqli_fetch_assoc($query)) {
    $data[] = $row;
}

echo json_encode($data);
?>