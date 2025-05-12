<?php
require_once 'koneksi.php';

$id_masuk = $_GET['id_masuk'] ?? null; // Ambil id mahasiswa

header('Content-Type: application/json');

$conn->set_charset("utf8");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Process form submission for update
if (isset($_GET['id_masuk'])) {
    $id = $_GET['id_masuk'];
    $status = $_GET['status_masuk'];
    
    // Validate input
    if (empty($id) || empty($status)) {
        $update_message = "Name and email are required fields!";
    } else {
        // Prepare update statement
        $sql = "UPDATE presensi_masuk SET status = ?  WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("si", $status,  $id);
        
        // Execute the update
        if ($stmt->execute()) {
            $update_message = "Record updated successfully!";
        } else {
            $update_message = "Error updating record: " . $conn->error;
        }
        $stmt->close();
    }
    
    $response = ['status' => 'success', 'message' => $update_message];
    echo json_encode($response);
}else{
    $response = ['status' => 'error', 'message' => 'id tidak ditemukan'];
    echo json_encode($response);
}

$conn->close();
?>