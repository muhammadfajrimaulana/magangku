<?php
require_once 'koneksi.php';

// Mengatur user_id menjadi statis 21
$pembimbing_id = $_GET['pembimbing_id'];

$sql = "SELECT
u.nama,
u.program_studi,
u.nama_perusahaan as instansi,
u.foto_profil,
ic.status as validasi,
ic.jenis_cuti,
ic.keterangan,
ic.id as izin_id,
ic.lampiran_path,
ic.tanggal_pengajuan as tanggal_pengajuan,
ic.tanggal_mulai as tanggal_mulai,
ic.tanggal_selesai as tanggal_selesai
FROM izin_cuti ic
LEFT JOIN users u ON u.id = ic.user_id
WHERE u.pembimbing_id = $pembimbing_id
ORDER BY ic.tanggal_pengajuan DESC";

// error_log("SQL Query (Riwayat): " . $sql);

$result = $conn->query($sql);

$data = [];

if ($result) {
    // error_log("Jumlah baris hasil (Riwayat): " . $result->num_rows);
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            // *** PERUBAHAN PENTING DI SINI ***
            // Ganti 'http://192.168.132.140:8000/' dengan base URL server gambar Anda yang sebenarnya
            $row['foto_profil'] = 'http://192.168.132.140:8000/' . $row['foto_profil'];
            // *** AKHIR PERUBAHAN ***
            $data[] = $row;
        }
        $result->free();
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Tidak ada data izin untuk pembimbing ini.']);
        $conn->close();
        exit();
    }
} else {
    http_response_code(500);
    // error_log("Error menjalankan query (Riwayat): " . $conn->error);
    echo json_encode(['error' => 'Error menjalankan query: ' . $conn->error]);
    $conn->close();
    exit();
}

header('Content-Type: application/json');
echo json_encode($data);

$conn->close();

?>