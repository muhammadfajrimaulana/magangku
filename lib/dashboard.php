<!-- dashboard.php - Halaman Dashboard Setelah Login -->
<?php
// Memulai session
session_start();

// Cek apakah user belum login
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true) {
    // Redirect ke halaman login
    header("location: login.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistem Presensi Magang</title>
    <style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        background-color: #f5f5f5;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    header {
        background-color: #4a6fdc;
        color: white;
        padding: 20px;
        border-radius: 8px 8px 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    header h1 {
        font-size: 24px;
    }

    .user-info {
        display: flex;
        align-items: center;
    }

    .user-info .user-name {
        margin-right: 20px;
        font-weight: bold;
    }

    .logout-btn {
        padding: 8px 15px;
        background-color: rgba(255, 255, 255, 0.2);
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        text-decoration: none;
        font-size: 14px;
    }

    .logout-btn:hover {
        background-color: rgba(255, 255, 255, 0.3);
    }

    .dashboard-content {
        background-color: white;
        padding: 20px;
        border-radius: 0 0 8px 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .welcome-message {
        margin-bottom: 30px;
    }

    .welcome-message h2 {
        color: #333;
        margin-bottom: 10px;
    }

    .welcome-message p {
        color: #666;
        line-height: 1.6;
    }

    .stats-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    }

    .stat-card h3 {
        font-size: 18px;
        color: #555;
        margin-bottom: 10px;
    }

    .stat-card .stat-value {
        font-size: 36px;
        font-weight: bold;
        color: #4a6fdc;
        margin-bottom: 5px;
    }

    .stat-card .stat-description {
        color: #777;
        font-size: 14px;
    }

    .quick-actions {
        margin-bottom: 30px;
    }

    .quick-actions h3 {
        margin-bottom: 15px;
        color: #333;
    }

    .actions-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
    }

    .action-card {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        transition: background-color 0.3s;
        text-decoration: none;
        color: #333;
    }

    .action-card:hover {
        background-color: #f0f4ff;
    }

    .action-card span {
        display: block;
        font-size: 36px;
        margin-bottom: 10px;
        color: #4a6fdc;
    }

    .action-card h4 {
        margin-bottom: 10px;
    }

    .action-card p {
        color: #666;
        font-size: 14px;
    }

    .recent-activity {
        margin-bottom: 30px;
    }

    .recent-activity h3 {
        margin-bottom: 15px;
        color: #333;
    }

    .activity-list {
        list-style: none;
    }

    .activity-item {
        padding: 15px;
        border-bottom: 1px solid #eee;
        display: flex;
        align-items: center;
    }

    .activity-item:last-child {
        border-bottom: none;
    }

    .activity-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #e6f7e6;
        color: #28a745;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-right: 15px;
        font-size: 18px;
    }

    .activity-icon.edit {
        background-color: #fff3cd;
        color: #ffc107;
    }

    .activity-icon.delete {
        background-color: #f8d7da;
        color: #dc3545;
    }

    .activity-content {
        flex: 1;
    }

    .activity-title {
        font-weight: bold;
        margin-bottom: 5px;
    }

    .activity-time {
        font-size: 12px;
        color: #777;
    }
    </style>
</head>

<body>
    <div class="container">
        <header>
            <h1>Sistem Informasi Magang</h1>
            <div class="user-info">
                <span class="user-name">Halo, <?php echo htmlspecialchars($_SESSION["nama_lengkap"]); ?></span>
                <a href="logout.php" class="logout-btn">Logout</a>
            </div>
        </header>

        <div class="dashboard-content">
            <div class="welcome-message">
                <h2>Selamat Datang di Sistem Informasi Magang</h2>
                <p>Silakan gunakan menu di bawah ini untuk mengelola data mahasiswa dan informasi presensi lainnya.</p>
            </div>

            <div class="stats-container">
                <div class="stat-card">
                    <h3>Total Mahasiswa</h3>
                    <div class="stat-value">
                        0
                    </div>
                    <div class="stat-description">Terdaftar dalam sistem</div>
                </div>

                <div class="stat-card">
                    <h3>Mahasiswa Aktif</h3>
                    <div class="stat-value">
                        0
                    </div>
                    <div class="stat-description">Mahasiswa dengan status aktif</div>
                </div>

                <div class="stat-card">
                    <h3>Mahasiswa Cuti</h3>
                    <div class="stat-value">
                        0
                    </div>
                    <div class="stat-description">Mahasiswa dengan status cuti</div>
                </div>

                <div class="stat-card">
                    <h3>Mahasiswa Selesai</h3>
                    <div class="stat-value">
                        0
                    </div>
                    <div class="stat-description">Mahasiswa dengan status selesai magang</div>
                </div>
            </div>

            <div class="quick-actions">
                <h3>Aksi Cepat</h3>
                <div class="actions-grid">
                    <a href="list-mahasiswa.php" class="action-card">
                        <span>📋</span>
                        <h4>Daftar Mahasiswa</h4>
                        <p>Lihat dan kelola data mahasiswa</p>
                    </a>

                    <a href="list-pembingbing.php" class="action-card">
                        <span>📋</span>
                        <h4>Daftar Pembingbing</h4>
                        <p>Lihat dan kelola data mahasiswa</p>
                    </a>

                    <!-- <a href="laporan.php" class="action-card">
<span>📊</span>
<h4>Laporan</h4>
<p>Lihat dan cetak laporan</p>
</a>

<a href="pengaturan.php" class="action-card">
<span>⚙️</span>
<h4>Pengaturan</h4>
<p>Kelola pengaturan sistem</p>
</a> -->
                </div>
            </div>
        </div>
    </div>
</body>

</html>