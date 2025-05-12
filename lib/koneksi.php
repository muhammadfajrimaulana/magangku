<?php
// $host = "127.0.0.1";
// $username = "root";
// $password = "";
// $dbname = "magangku_db";

$host = "110.138.94.188";
$username = "hondakum_globdbdma";
$password = "!!globdbdma";
$dbname = "hondakum_magangku";
$port = 3306;

$conn = new mysqli($host, $username, $password, $dbname, $port); // Menggunakan $dbname

if ($conn->connect_error) {
    die("Koneksi database gagal: " . $conn->connect_error);
}
?>