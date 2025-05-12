<?php

require_once 'koneksi.php';

// Mengatur user_id menjadi statis 21
$user_id = $_GET['id'];

$sql = "SELECT
    u.id AS user_id,
    u.username,
    u.nama,
    COALESCE(pm.tanggal, pp.tanggal) AS tanggal,
    MIN(TIME(pm.waktu)) AS waktu_masuk,
    MAX(TIME(pp.waktu)) AS waktu_pulang,
    MAX(pm.path_foto) AS foto_masuk,
    MAX(pp.path_foto) AS foto_pulang,
    MAX(pm.lokasi) AS lokasi_masuk,
    MAX(pp.lokasi) AS lokasi_pulang,
    MAX(pm.aktivitas) AS catatan_kegiatan_masuk,
    MAX(pp.aktivitas) AS catatan_kegiatan_pulang,
    COALESCE(pm.status, pp.status) AS status
FROM users u
LEFT JOIN presensi_masuk pm ON u.id = pm.user_id
LEFT JOIN presensi_pulang pp ON u.id = pp.user_id AND pm.tanggal = pp.tanggal
WHERE u.id = $user_id AND u.role = 'mahasiswa'
GROUP BY tanggal, u.id, u.username, u.nama
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
        // error_log("Tidak ada data riwayat ditemukan untuk user ID: " . $user_id);
        // Jika tidak ada data yang digabungkan, coba ambil data masuk dan pulang terpisah
        $sql_masuk = "SELECT tanggal, TIME(waktu) AS waktu_masuk, path_foto AS foto_masuk, lokasi AS lokasi_masuk FROM presensi_masuk WHERE user_id = $user_id ORDER BY tanggal DESC, waktu DESC";
        $result_masuk = $conn->query($sql_masuk);
        $data_masuk = [];
        if ($result_masuk && $result_masuk->num_rows > 0) {
            while ($row_masuk = $result_masuk->fetch_assoc()) {
                $data[] = [
                    'user_id' => $user_id,
                    'username' => 'N/A', // Informasi pengguna mungkin tidak tersedia di sini
                    'nama' => 'N/A',
                    'tanggal' => $row_masuk['tanggal'],
                    'waktu_masuk' => $row_masuk['waktu_masuk'],
                    'foto_masuk' => $row_masuk['foto_masuk'],
                    'lokasi_masuk' => $row_masuk['lokasi_masuk'],
                    'lokasi_pulang' => null,
                    'catatan_kegiatan_masuk' => $row_masuk['catatan_kegiatan_masuk']
                    
                ];
            }
            $result_masuk->free();
        }

        $sql_pulang = "SELECT tanggal, TIME(waktu) AS waktu_pulang, path_foto AS foto_pulang, lokasi AS lokasi_pulang FROM presensi_pulang WHERE user_id = $user_id ORDER BY tanggal DESC, waktu DESC";
        $result_pulang = $conn->query($sql_pulang);
        if ($result_pulang && $result_pulang->num_rows > 0) {
            while ($row_pulang = $result_pulang->fetch_assoc()) {
                $tanggal_pulang_sudah_ada = false;
                foreach ($data as &$item) {
                    if ($item['tanggal'] == $row_pulang['tanggal'] && $item['waktu_pulang'] === null) {
                        $item['waktu_pulang'] = $row_pulang['waktu_pulang'];
                        $item['foto_pulang'] = $row_pulang['foto_pulang'];
                        $item['lokasi_pulang'] = $row_pulang['lokasi_pulang'];
                        $tanggal_pulang_sudah_ada = true;
                        $item['catatan_kegiatan_pilang'] = $row_masuk['catatan_kegiatan_pulang'] = $row_pulang['catatan_kegiatan_pulang'];
                        break;
                    }
                }
                if (!$tanggal_pulang_sudah_ada) {
                    $data[] = [
                        'user_id' => $user_id,
                        'username' => 'N/A',
                        'nama' => 'N/A',
                        'tanggal' => $row_pulang['tanggal'],
                        'waktu_masuk' => null,
                        'waktu_pulang' => $row_pulang['waktu_pulang'],
                        'foto_masuk' => null,
                        'foto_pulang' => $row_pulang['foto_pulang'],
                        'lokasi_masuk' => null,
                        'lokasi_pulang' => null,
                    ];
                }
            }
            $result_pulang->free();
        }

        usort($data, function ($a, $b) {
            return strtotime($b['tanggal']) - strtotime($a['tanggal']);
        });
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