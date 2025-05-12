<?php
include 'koneksi.php';

$username = $_POST['username'];
$password = $_POST['password'];

$response = array();

// Cek di tabel users (mahasiswa)
$queryMahasiswa = $conn->query("SELECT id, nama, role, program_studi, foto_profil, pembimbing_id, email FROM users WHERE username = '" . $username . "' AND password = '" . $password . "'");

if ($queryMahasiswa->num_rows > 0) {
    $user = $queryMahasiswa->fetch_assoc();
    $response = array(
        "success" => true,
        "message" => "Login berhasil",
        "user" => $user
    );
} else {
    // Jika tidak ditemukan di tabel users, cek di tabel admins
    $queryAdmin = $conn->query("SELECT id, nama, role, jabatan, foto_profil FROM admins WHERE username = '" . $username . "' AND password = '" . $password . "'");

    if ($queryAdmin->num_rows > 0) {
        $user = $queryAdmin->fetch_assoc();
        $response = array(
            "success" => true,
            "message" => "Login berhasil",
            "user" => $user
        );
    } else {
        // Jika tidak ditemukan di tabel admins, cek di tabel pembimbings (mentor)
        $queryPembimbing = $conn->query("SELECT id, nama, role, foto_profil FROM pembimbings WHERE username = '" . $username . "' AND password = '" . $password . "'");

        if ($queryPembimbing->num_rows > 0) {
            $user = $queryPembimbing->fetch_assoc();
            $response = array(
                "success" => true,
                "message" => "Login berhasil",
                "user" => $user
            );
        } else {
            $response = array(
                "success" => false,
                "message" => "Login gagal. Periksa username dan password Anda."
            );
        }
    }
}

echo json_encode($response);
?>