// index.php - Halaman Utama/Redirect
<?php
session_start();

// Cek apakah user sudah login
if(isset($_SESSION['user_id'])) {
    // Jika sudah login, redirect ke dashboard
    header("Location: dashboard.php");
    exit;
} else {
    // Jika belum login, redirect ke halaman login
    header("Location: login.php");
    exit;
}
?>