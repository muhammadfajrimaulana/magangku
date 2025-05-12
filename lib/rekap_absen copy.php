<?php

require '../vendor/autoload.php'; // Pastikan Anda sudah menginstal PhpSpreadsheet melalui Composer

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

require_once 'koneksi.php';
header('Content-Type: application/json');

/////////////////-----------------
$user_id = $_GET['mahasiswa_id'];

// table.column alias/as nama alias
$sql = "SELECT
u.nama,
    COALESCE(pm.tanggal, pp.tanggal) AS tanggal,
    MIN(TIME(pm.waktu)) AS waktu_masuk,
    MAX(TIME(pp.waktu)) AS waktu_pulang,
    pm.aktivitas as catatan_masuk,
    pp.aktivitas as catatan_pulang,
    pp.nim as nim_mhs,

FROM users u
LEFT JOIN presensi_masuk pm ON u.id = pm.user_id
LEFT JOIN presensi_pulang pp ON u.id = pp.user_id AND pm.tanggal = pp.tanggal
WHERE u.id = $user_id AND u.role = 'mahasiswa'
GROUP BY tanggal, u.id, u.username, u.nama
ORDER BY tanggal DESC";


$dataAbsensi = $conn->query($sql);

$spreadsheet = new Spreadsheet();
$sheet = $spreadsheet->getActiveSheet();

// Tambahkan header
$header = ['Nama', 'Tanggal', 'Waktu Masuk', 'Waktu Keluar', 'Catatan Masuk', 'Catatan Pulang', 'NIM'];
$sheet->fromArray([$header], null, 'A1');

$row = 2;
foreach ($dataAbsensi as $absensi) {
    $rowData = [
        $absensi['nama'],
        $absensi['tanggal'],
        $absensi['waktu_masuk'],
        $absensi['waktu_pulang'],
        $absensi['catatan_masuk'],
        $absensi['catatan_pulang'],
        $absensi['nim_mhs'],
    ];
    $sheet->fromArray([$rowData], null, 'A' . $row);
    $row++;
}

$writer = new Xlsx($spreadsheet);
$filename = 'rekap_absen_' . date('YmdHis') . '.xlsx';

// Kirim file sebagai response untuk diunduh
header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
header('Content-Disposition: attachment;filename="' . $filename . '"');
header('Cache-Control: max-age=0');

$writer->save('php://output');
exit();

?>