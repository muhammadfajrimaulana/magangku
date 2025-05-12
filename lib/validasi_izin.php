<?php
require_once 'koneksi.php';

header('Content-Type: application/json');

$conn->set_charset("utf8");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Process form submission for update
if (isset($_POST['izin_id'])) {
    $id = $_POST['izin_id'];
    $status = $_POST['status_izin'];
    
    // Validate input
    if (empty($id) || empty($status)) {
        $update_message = "Name and email are required fields!";
    } else {
        // Prepare update statement
        $sql = "UPDATE izin_cuti SET status = ?  WHERE id = ?";
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