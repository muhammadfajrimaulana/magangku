<?php
require_once 'koneksi.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nama = $_POST['nama'] ?? '';
    $nim = $_POST['nim'] ?? '';
    $lokasi = $_POST['lokasi'] ?? '';
    $aktivitas = $_POST['aktivitas'] ?? '';
    $user_id = $_POST['id'] ?? '';

    $query = "SELECT pembimbing_id FROM users WHERE id = ?";
    $stmt_id = $conn->prepare($query);
    $stmt_id->bind_param("s", $user_id);
    $stmt_id->execute();
    $stmt_id->bind_result($pembimbing_id);
    $stmt_id->fetch();
    $stmt_id->close();

    // Terima parameter status, default 'Hadir' jika tidak dikirim
    $status = $_POST['status'] ?? 'Hadir';

    // Handle file upload (foto)
    if (isset($_FILES['foto'])) {
        $uploadDir = 'uploads/presensi/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }
        $fileTmpName = $_FILES['foto']['tmp_name'];
        $fileName = uniqid() . '_' . basename($_FILES['foto']['name']);
        $fileDestination = $uploadDir . $fileName;

        if (move_uploaded_file($fileTmpName, $fileDestination)) {
            $pathFoto = $fileDestination;
        } else {
            $response = ['success' => false, 'message' => 'Gagal mengupload foto.'];
            echo json_encode($response);
            exit();
        }
    } else {
        $pathFoto = null; // Jika tidak ada foto yang diunggah
    }

    // Simpan data presensi ke database, termasuk status
    $query = "INSERT INTO presensi_pulang (nama, user_id, nim, tanggal, waktu, lokasi, aktivitas, path_foto, status_presensi, pembimbing_id) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP(), ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $tanggal_sekarang = date('Y-m-d H:i:s'); // Format datetime yang sesuai
    $stmt->bind_param("sssssssss", $nama, $user_id, $nim, $tanggal_sekarang, $lokasi, $aktivitas, $pathFoto, $status, $pembimbing_id);

    if ($stmt->execute()) {
        $response = [
            'success' => true,
            'message' => 'Presensi berhasil disimpan.',
            'nama' => $nama, // Sertakan nama dalam respons
            'nim' => $nim,   // Sertakan NIM dalam respons
            'status' => $status, // Sertakan status dalam respons
        ];
    } else {
        $response = ['success' => false, 'message' => 'Gagal menyimpan presensi: ' . $stmt->error];
    }

    $stmt->close();
} else {
    $response = ['success' => false, 'message' => 'Metode request tidak valid. Gunakan POST.'];
}

echo json_encode($response);

$conn->close();
?>