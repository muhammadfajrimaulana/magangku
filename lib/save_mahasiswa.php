<?php
require_once 'koneksi.php';

$conn->set_charset("utf8");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Process form submission for update
if (isset($_POST['id'])) {
    $id = $_POST['id'];
    $nim = $_POST['nim'];
    $nama = $_POST['nama'];
    $jurusan = $_POST['jurusan'];
    $mentor = $_POST['pembimbing_id'];
    
    // Validate input
    if (empty($nama) || empty($mentor)) {
        $update_message = "Name and email are required fields!";
    } else {
        // Prepare update statement
        $sql = "UPDATE users SET nim = ?, nama = ?, program_studi = ?, pembimbing_id = ? WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssi", $nim, $nama, $jurusan, $mentor, $id);
        
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
}
?>