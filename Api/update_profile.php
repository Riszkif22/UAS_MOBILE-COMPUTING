<?php
include 'koneksi.php';

// Tangkap data dari Flutter
$user_id = $_POST['user_id'];
// Gunakan real_escape_string untuk keamanan tanda kutip pada nama/password
$full_name = mysqli_real_escape_string($conn, $_POST['full_name']);
$password = mysqli_real_escape_string($conn, $_POST['password']);

// 1. Cek apakah user valid
$cek = mysqli_query($conn, "SELECT * FROM users WHERE id = '$user_id'");
if(mysqli_num_rows($cek) == 0){
    echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
    exit();
}

// 2. Mulai query update dasar (Nama)
$query = "UPDATE users SET full_name = '$full_name'";

// 3. Cek jika password diisi, update password
if(!empty($password)){
    $query .= ", password = '$password'";
}

// 4. Handle Upload Foto
if(isset($_FILES['image']['name']) && $_FILES['image']['name'] != ""){
    $target_dir = "uploads/";
    
    // PERBAIKAN: Buat folder jika belum ada (Penting!)
    if (!file_exists($target_dir)) {
        mkdir($target_dir, 0777, true);
    }

    // Generate nama file unik: profile_ID_TIMESTAMP.jpg
    $imageFileType = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));
    $new_name = "profile_" . $user_id . "_" . time() . "." . $imageFileType;
    $target_file = $target_dir . $new_name;

    // Proses upload
    if(move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)){
        // Simpan URL lengkap ke database
        // Pastikan domain sesuai dengan hosting Anda
        $full_url = "https://rilah.ujangkedu.my.id/api/" . $target_file;
        $query .= ", photo_url = '$full_url'";
    }
}

// Tambahkan WHERE clause
$query .= " WHERE id = '$user_id'";

// 5. Eksekusi Query
if(mysqli_query($conn, $query)){
    // PERBAIKAN FINAL: Ambil data user TERBARU setelah update
    // Ini wajib agar Flutter menerima URL foto yang baru saja diupload
    $get_user = mysqli_fetch_assoc(mysqli_query($conn, "SELECT * FROM users WHERE id='$user_id'"));
    
    echo json_encode([
        "status" => "success", 
        "message" => "Profil Berhasil Diupdate",
        "name" => $get_user['full_name'],     // Kirim nama terbaru
        "photo_url" => $get_user['photo_url'] // Kirim URL foto terbaru
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal Update Database"]);
}
?>