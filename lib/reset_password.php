<?php
require_once 'koneksi.php';

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$email = $_POST['email']; // Ambil id mahasiswa
$password = $_POST['password']; // Ambil id mahasiswa

header('Content-Type: application/json');

$conn->set_charset("utf8");


// cek dulu email nya

$cekEmail = "SELECT id, email FROM users WHERE email = '" . $email . "'";
$result = mysqli_query($conn, $cekEmail);
if (mysqli_num_rows($result) > 0) {
    // jika email nya ada maka proses reset
    $row = mysqli_fetch_assoc($result);
    $idUser = $row['id'];
    $sql = "UPDATE users SET password = ?  WHERE email = ? and id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssi", $password,  $email, $idUser);
    
    // Execute the update
    if ($stmt->execute()) {
        $update_message = "Reset password berhasil successfully!";
    } else {
        $update_message = "Error updating record: " . $conn->error;
    }
    $stmt->close();
    $response = ['status' => 'success', 'message' => $update_message];
    echo json_encode($response);
} else {
    $response = ['status' => 'error', 'message' => 'Email tidak ditemukan'];
    echo json_encode($response);
}

$conn->close();
?>