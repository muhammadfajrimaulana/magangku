<?php
require_once 'koneksi.php';

// Mengatur user_id menjadi statis 21
$pembimbing_id = $_GET['pembimbing_id'];

$sql = "SELECT
    pm.pembimbing_id,
    pm.user_id,
    pm.nama,
    pp.id as id_pulang,
    COALESCE(pm.status, pp.status) AS status,
    COALESCE(pm.tanggal, pp.tanggal) AS tanggal,
    MIN(TIME(pm.waktu)) AS waktu_masuk,
    -- MAX(TIME(pp.waktu)) AS waktu_pulang,
    pp.waktu AS waktu_pulang,
    MAX(pm.path_foto) AS foto_masuk,
    MAX(pp.path_foto) AS foto_pulang,
    MAX(pm.lokasi) AS lokasi_masuk,
    MAX(pp.lokasi) AS lokasi_pulang,
    MAX(pm.aktivitas) AS catatan_kegiatan_masuk,
    MAX(pp.aktivitas) AS catatan_kegiatan_pulang
FROM presensi_masuk pm
LEFT JOIN presensi_pulang pp ON pp.pembimbing_id = pm.pembimbing_id and pp.tanggal = pm.tanggal and pp.user_id = pm.user_id
WHERE pm.pembimbing_id = $pembimbing_id
GROUP BY pm.user_id, pm.tanggal
ORDER BY tanggal DESC";

// error_log("SQL Query (Riwayat): " . $sql);

$result = $conn->query($sql);

$data = [];

if ($result) {
    // error_log("Jumlah baris hasil (Riwayat): " . $result->num_rows);
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            // error_log("Data baris (Riwayat): " . json_encode($row));
            $data[] = $row;
        }
        $result->free();
    } else {
        http_response_code(400);
        echo json_encode(['error' => 'Error menjalankan query 1: ' . $conn->error]);
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