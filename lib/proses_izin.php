<?php
require_once 'koneksi.php';

header('Content-Type: application/json');

// Periksa apakah koneksi database berhasil
if (!$conn) {
    $response = ['success' => false, 'message' => 'Gagal terhubung ke database. Periksa file koneksi.php.'];
    echo json_encode($response);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $jenis_cuti = $_POST['jenis_cuti'] ?? '';
    $tanggal_mulai_flutter = $_POST['tanggal_mulai'] ?? '';
    $tanggal_selesai_flutter = $_POST['tanggal_selesai'] ?? '';
    $keterangan = $_POST['keterangan'] ?? '';
    $user_id = $_POST['user_id'] ?? ''; // Mengambil user_id dari POST
    $lampiran_tmp = $_FILES['lampiran']['tmp_name'] ?? '';
    $lampiran_name = $_FILES['lampiran']['name'] ?? '';
    $lampiran_path_db = null;

    // Validasi user_id (pastikan tidak kosong)
    if (empty($user_id)) {
        $response = ['success' => false, 'message' => 'User ID tidak valid.'];
        echo json_encode($response);
        exit();
    }

    // Konversi format tanggal
    $tanggal_mulai_obj = DateTime::createFromFormat('d M Y', $tanggal_mulai_flutter);
    $tanggal_selesai_obj = DateTime::createFromFormat('d M Y', $tanggal_selesai_flutter);

    if ($tanggal_mulai_obj && $tanggal_selesai_obj) {
        $tanggal_mulai_db = $tanggal_mulai_obj->format('Y-m-d');
        $tanggal_selesai_db = $tanggal_selesai_obj->format('Y-m-d');
    } else {
        $response = ['success' => false, 'message' => 'Format tanggal tidak valid.'];
        echo json_encode($response);
        exit();
    }

    // Proses penyimpanan gambar
    if ($lampiran_tmp != '') {
        $upload_dir = 'uploads/';
        if (!is_dir($upload_dir)) {
            mkdir($upload_dir, 0777, true);
        }
        $lampiran_ext = pathinfo($lampiran_name, PATHINFO_EXTENSION);
        $lampiran_new_name = uniqid() . '.' . $lampiran_ext;
        $lampiran_path_server = $upload_dir . $lampiran_new_name;

        if (move_uploaded_file($lampiran_tmp, $lampiran_path_server)) {
            $lampiran_path_db = $lampiran_path_server;
        } else {
            $response = ['success' => false, 'message' => 'Gagal mengupload gambar. Pastikan direktori uploads writable.'];
            echo json_encode($response);
            exit();
        }
    }

    // Query untuk menyimpan data izin
    $query = "INSERT INTO izin_cuti (user_id, jenis_cuti, tanggal_mulai, tanggal_selesai, keterangan, lampiran_path) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("isssss", $user_id, $jenis_cuti, $tanggal_mulai_db, $tanggal_selesai_db, $keterangan, $lampiran_path_db);

    if ($stmt->execute()) {
        $response = ['success' => true, 'message' => 'Pengajuan izin berhasil dikirim.'];
    } else {
        $response = ['success' => false, 'message' => 'Gagal menyimpan data izin: ' . $stmt->error];
        error_log("Error database: " . $stmt->error);
    }

    $stmt->close();

    echo json_encode($response);
} else {
    $response = ['success' => false, 'message' => 'Metode request tidak valid.'];
    echo json_encode($response);
}

// Tutup koneksi
if ($conn) {
    $conn->close();
}
?>