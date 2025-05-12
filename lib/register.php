<?php
require_once 'koneksi.php';
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
if (isset($data['username']) && isset($data['email']) && isset($data['password']) && isset($data['role'])) {
    $username = $data['username'];
    $name = $data['nama'];
    $prodi = $data['prodi'];
    $telepon = $data['telepon'];
    $nim = $data['nim'];
    $email = $data['email'];
    $password = $data['password'];
    $role = $data['role'];

    // Tambahan data nama perusahaan dan alamat perusahaan
    $nama_perusahaan = isset($data['nama_perusahaan']) ? $data['nama_perusahaan'] : '';
    $alamat_perusahaan = isset($data['alamat_perusahaan']) ? $data['alamat_perusahaan'] : '';

    $allowedRoles = ['admin', 'pembimbing', 'mahasiswa'];
    if (!in_array($role, $allowedRoles)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Role tidak valid. Pilih antara admin, pembimbing, atau mahasiswa.']);
        exit();
    }

    $checkUsernameStmt = $conn->prepare("SELECT username FROM users WHERE username = ?");
    $checkUsernameStmt->bind_param("s", $username);
    $checkUsernameStmt->execute();
    $checkUsernameStmt->store_result();
    if ($checkUsernameStmt->num_rows > 0) {
        http_response_code(409);
        echo json_encode(['message' => 'Username sudah terdaftar']);
        $checkUsernameStmt->close();
        $conn->close();
        exit();
    }
    $checkUsernameStmt->close();

    $checkEmailStmt = $conn->prepare("SELECT email FROM users WHERE email = ?");
    $checkEmailStmt->bind_param("s", $email);
    $checkEmailStmt->execute();
    $checkEmailStmt->store_result();
    if ($checkEmailStmt->num_rows > 0) {
        http_response_code(409);
        echo json_encode(['message' => 'Email sudah terdaftar']);
        $checkEmailStmt->close();
        $conn->close();
        exit();
    }
    $checkEmailStmt->close();

    // Modifikasi kueri INSERT untuk menyertakan nama_perusahaan dan alamat_perusahaan
    $stmt = $conn->prepare("INSERT INTO users (nama, username, email, password, role, program_studi, nim, telepon, nama_perusahaan, alamat_perusahaan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    // Modifikasi bind_param untuk menyertakan tipe data string untuk kedua field baru
    $stmt->bind_param("ssssssssss", $name, $username, $email, $password, $role, $prodi, $nim, $telepon, $nama_perusahaan, $alamat_perusahaan);

    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode(['success' => true, 'message' => 'Pendaftaran berhasil', 'data' => ['username' => $username, 'email' => $email, 'role' => $role]]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Gagal melakukan pendaftaran: ' . $stmt->error]);
    }
    $stmt->close();
} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Field yang dibutuhkan tidak lengkap']);
}

$conn->close();
?>