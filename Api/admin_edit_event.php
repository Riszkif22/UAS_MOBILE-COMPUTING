<?php
include 'koneksi.php';

$id = $_POST['id'];
$title = $_POST['title'];
$distance = $_POST['distance'];
$desc = $_POST['description'];
$date = $_POST['event_date']; // Tangkap Tanggal
$image_url = $_POST['image_url_text']; 

if(isset($_FILES['image']['name']) && $_FILES['image']['name'] != ""){
    $target_dir = "uploads/";
    $file_ext = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));
    $new_name = "event_" . time() . "." . $file_ext;
    $target_file = $target_dir . $new_name;

    if(move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)){
        $image_url = "https://rilah.ujangkedu.my.id/api/" . $target_file;
    }
}

$sql = "UPDATE categories SET title='$title', distance='$distance', description='$desc', event_date='$date', image_url='$image_url' WHERE id='$id'";

if(mysqli_query($conn, $sql)){ 
    echo json_encode(["status" => "success"]); 
} else { 
    echo json_encode(["status" => "error"]); 
}
?>