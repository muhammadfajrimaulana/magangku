<?php
require_once 'koneksi.php';

$conn->set_charset("utf8");

// Set headers to allow cross-origin requests (if needed)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");

function response($status, $message, $data = null) {
    header('Content-Type: application/json');
    $response = [
        'status' => $status,
        'message' => $message
    ];
    
    if ($data !== null) {
        $response['data'] = $data;
    }
    
    echo json_encode($response);
    exit();
}

try {
    // Query to get all mahasiswa data
    $sql = "SELECT * FROM users WHERE role = 'mahasiswa' ORDER BY id DESC";
    $result = $conn->query($sql);
    
    if ($result) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            // Convert numeric values
            $row['id'] = (int)$row['id'];
            $row['nama'] = $row['nama'];
            $row['program_studi'] = $row['program_studi'];
            $row['email'] = $row['email'];
            
            $data[] = $row;
        }
        
        response('success', 'Data berhasil dimuat', $data);
    } else {
        response('error', 'Gagal mengambil data: ' . $conn->error);
    }
} catch (Exception $e) {
    response('error', 'Terjadi kesalahan: ' . $e->getMessage());
}

$conn->close();
?>