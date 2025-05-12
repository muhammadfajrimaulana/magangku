<?php
$host = "103.146.203.49";
$username = "hondakum_globdbdma";
$password = "!!globdbdma";
$dbname = "hondakum_magangku";
$port = 3306;

$conn = new mysqli ($host, $username, $password, $dbname, $port); // Menggunakan $dbname

if ($conn->connect_error) {
    die("Koneksi database gagal: " . $conn->connect_error);
}
?>