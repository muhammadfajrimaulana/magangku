<?php

require_once 'koneksi.php';

// Memeriksa koneksi
if ($conn->connect_error) {
    $response = array(
        'success' => false,
        'message' => 'Koneksi database gagal: ' . $conn->connect_error
    );
    header('Content-Type: application/json');
    echo json_encode($response);
    exit();
}

// Memeriksa apakah ID mahasiswa diterima melalui POST
if (isset($_POST['id_mahasiswa'])) {
    $id_mahasiswa = $_POST['id_mahasiswa'];

    // Query untuk mengambil data profil mahasiswa berdasarkan ID dan role 'mahasiswa'
    $sql = "SELECT nama, program_studi, foto_profil, pembimbing_id FROM users WHERE id = ? AND role = 'mahasiswa'";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $id_mahasiswa); // "s" karena id diasumsikan string, sesuaikan jika integer

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $response = array(
                'success' => true,
                'data' => array(
                    'nama' => $row['nama'],
                    'program_studi' => $row['program_studi'], // Menggunakan snake_case agar konsisten
                    'foto_profil' => $row['foto_profil'], // Path foto profil dari database
                    'pembimbing_id' => $row['pembimbing_id'] // Path foto profil dari database
                ),
                'message' => 'Data profil mahasiswa berhasil diambil.'
            );
        } else {
            $response = array(
                'success' => false,
                'message' => 'Data mahasiswa dengan ID tersebut tidak ditemukan atau bukan merupakan mahasiswa.'
            );
        }
        $result->free();
    } else {
        $response = array(
            'success' => false,
            'message' => 'Gagal menjalankan query: ' . $stmt->error
        );
    }
    $stmt->close();

} else {
    $response = array(
        'success' => false,
        'message' => 'ID mahasiswa tidak diterima.'
    );
}

// Mengirimkan response dalam format JSON
header('Content-Type: application/json');
echo json_encode($response);

// Menutup koneksi database
$conn->close();
?>