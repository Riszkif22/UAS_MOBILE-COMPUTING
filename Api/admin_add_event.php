<?php
include 'koneksi.php';

$title = $_POST['title'];
$distance = $_POST['distance'];
$desc = $_POST['description'];
$date = $_POST['event_date']; // Tangkap Tanggal
$image_url = ""; 

if(isset($_FILES['image']['name']) && $_FILES['image']['name'] != ""){
    $target_dir = "uploads/";
    if (!file_exists($target_dir)) mkdir($target_dir, 0777, true);
    
    $file_ext = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));
    $new_name = "event_" . time() . "." . $file_ext;
    $target_file = $target_dir . $new_name;

    if(move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)){
        $image_url = "https://rilah.ujangkedu.my.id/api/" . $target_file;
    }
} else {
    $image_url = $_POST['image_url_text']; 
}

$sql = "INSERT INTO categories (title, distance, description, event_date, image_url) VALUES ('$title', '$distance', '$desc', '$date', '$image_url')";

if(mysqli_query($conn, $sql)){ 
    echo json_encode(["status" => "success"]); 
} else { 
    echo json_encode(["status" => "error"]); 
}
?>