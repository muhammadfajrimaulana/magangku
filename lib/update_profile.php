<?php
require('koneksi.php');
header('Content-Type: application/json');

// Aktifkan error reporting untuk debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// echo json_encode($_POST); // Debugging line to check the received data
// echo json_encode($_FILES); // Debugging line to check the received files
// die();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nama = $_POST['nama'] ?? '';
    $NIM = $_POST['NIM'] ?? '';
    $program_studi = $_POST['program_studi'] ?? 'prodi';
    $telepon = $_POST['telepon'] ?? '';
    $email = $_POST['email'] ?? '';
    $nama_perusahaan = $_POST['nama_perusahaan'] ?? '';
    $alamat_perusahaan = $_POST['alamat_perusahaan'] ?? '';
    $id = $_POST['id'];
    $pathFoto = null; // Inisialisasi pathFoto di luar blok if
    $oldFotoPath = null;
    $updateFotoSql = ''; // Inisialisasi bagian SQL untuk update foto

    // Ambil path foto profil lama dari database jika ada
    $sql_select_foto = "SELECT foto_profil FROM users WHERE id=$id";
    $result_foto = $conn->query($sql_select_foto);
    if ($result_foto && $result_foto->num_rows > 0) {
        $row = $result_foto->fetch_assoc();
        $oldFotoPath = $row['foto_profil'];
    }

    if (isset($_FILES['foto_profil']) && $_FILES['foto_profil']['error'] === UPLOAD_ERR_OK) {
        $uploadDir = 'uploads/profile/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }
        $fileTmpName = $_FILES['foto_profil']['tmp_name'];
        $fileName = uniqid() . '_' . basename($_FILES['foto_profil']['name']);
        $fileDestination = $uploadDir . $fileName;

        if (move_uploaded_file($fileTmpName, $fileDestination)) {
            $pathFoto = $fileDestination;
            $updateFotoSql = ", foto_profil='$pathFoto'";
            // Hapus foto profil lama jika ada dan berbeda dari yang baru
            if ($oldFotoPath !== null && file_exists($oldFotoPath) && $oldFotoPath !== $pathFoto) {
                unlink($oldFotoPath);
            }
        } else {
            $response = ['success' => false, 'message' => 'Gagal mengupload foto. Error saat memindahkan file.'];
            echo json_encode($response);
            exit();
        }
    } elseif (isset($_FILES['foto_profil']) && $_FILES['foto_profil']['error'] !== UPLOAD_ERR_NO_FILE) {
        // Terjadi error upload selain tidak ada file
        $response = ['success' => false, 'message' => 'Terjadi kesalahan saat mengupload foto. Error code: ' . $_FILES['foto_profil']['error']];
        echo json_encode($response);
        exit();
    }
    // Jika tidak ada file yang diunggah (UPLOAD_ERR_NO_FILE), $updateFotoSql akan tetap kosong,
    // sehingga field foto_profil tidak akan diubah.

    $sql_update = "UPDATE users SET nama='$nama', NIM='$NIM', program_studi='$program_studi', telepon='$telepon', email='$email', nama_perusahaan='$nama_perusahaan', alamat_perusahaan='$alamat_perusahaan' $updateFotoSql WHERE id=$id";

    if ($conn->query($sql_update) === TRUE) {
        http_response_code(201);
        echo json_encode([
            'success' => true,
            'message' => 'Perubahan data berhasil',
            'data' => [
                'nama' => $nama,
                'NIM' => $NIM,
                'program_studi' => $program_studi,
                'telepon' => $telepon,
                'email' => $email,
                'nama_perusahaan' => $nama_perusahaan,
                'alamat_perusahaan' => $alamat_perusahaan,
                'foto_profil' => $pathFoto !== null ? $pathFoto : $oldFotoPath // Kembalikan path baru atau path lama jika tidak ada update
            ]
        ]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Gagal melakukan perubahan data: ' . $conn->error]);
    }

} else {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['success' => false, 'message' => 'Metode request tidak diizinkan. Hanya POST yang diterima.']);
}

$conn->close();
?>