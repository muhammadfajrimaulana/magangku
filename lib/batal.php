<?php
require_once 'koneksi.php';

$user_id = $_POST['user_id_mhs'] ?? null; // Ambil id mahasiswa
$pembimbing_id = $_POST['pembimbing_id'] ?? null;  // Ambil ID Pembimbing
$tanggal_absen = $_POST['tanggal_absen'] ?? null; // Ambil tanggal absen



header('Content-Type: application/json');

$conn->set_charset("utf8");

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
        $status =2; // Status yang ingin diupdate, misalnya 'Batal'
        
        //UPDATE STATUS MASUK
        $masuk = "UPDATE presensi_masuk SET status = ?  WHERE user_id = ? AND pembimbing_id = ? AND tanggal = ?";
        $stmt1 = $conn->prepare($masuk);
        $stmt1->bind_param("iiis", $status, $user_id, $pembimbing_id, $tanggal_absen);
       
        
        // UPDATE STATUS PULANG
        $pulang = "UPDATE presensi_pulang SET status = ?  WHERE user_id = ? AND pembimbing_id = ? AND tanggal = ?";
        $stmt = $conn->prepare($pulang);
        $stmt->bind_param("iiis", $status, $user_id, $pembimbing_id, $tanggal_absen);
        
        // Execute the update
        if ( $stmt->execute() && $stmt1->execute()) {
            $update_message = "Record updated successfully!";
        } else {
            $update_message = "Error updating record: " . $conn->error;
        }
        $stmt->close();
        $stmt1->close();


    $response = ['status' => 'success', 'message' => 'Validasi data berhasil!'];
    echo json_encode($response);

$conn->close();
?>