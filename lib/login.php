<!-- login.php - Halaman Form Login -->
<?php
session_start();

// Cek apakah user sudah login
if(isset($_SESSION['user_id'])) {
    // Jika sudah login, redirect ke dashboard
    header("Location: dashboard.php");
    exit;
}

// Variabel untuk pesan error
$error_message = "";

// Cek apakah form sudah di-submit
if($_SERVER["REQUEST_METHOD"] == "POST") {
    // Include file koneksi database
    require_once "koneksi.php";
    
    // Ambil data dari form
    $username = trim($_POST['email']);
    $password = trim($_POST['password']);
    
    // Validasi input
    if(empty($username) || empty($password)) {
        $error_message = "Silakan lengkapi username dan password";
    } else {
        // Query untuk memeriksa user di database
        $sql = "SELECT id, email, password, nama FROM users WHERE email = ? and password = ?";
        
        if($stmt = $conn->prepare($sql)) {
            // Bind parameter
            $stmt->bind_param("ss", $param_username, $param_password);
            
            // Set parameter
            $param_username = $username;
            $param_password = $password;
            
            // Eksekusi query
            if($stmt->execute()) {
                // Simpan hasil
                $stmt->store_result();
                
                // Cek apakah username ada di database
                if($stmt->num_rows == 1) {
                    // Bind hasil ke variabel
                    $stmt->bind_result($id, $username, $hashed_password, $nama_lengkap);
                    if($stmt->fetch()) {
                        // Verifikasi password
                        // if(password_verify($password, $hashed_password)) {
                        // Password benar, mulai session baru
                        session_start();
                        
                        // Simpan data ke session
                        $_SESSION["loggedin"] = true;
                        $_SESSION["user_id"] = $id;
                        $_SESSION["username"] = $username;
                        $_SESSION["nama_lengkap"] = $nama_lengkap;
                        
                        // Redirect ke halaman dashboard
                        header("location: dashboard.php");
                        exit;
                        // } else {
                        //     // Password salah
                        //     $error_message = "Username atau password yang dimasukkan tidak valid";
                        // }
                    }
                } else {
                    // Username tidak ditemukan
                    $error_message = "Username atau password yang dimasukkan tidak valid";
                }
            } else {
                $error_message = "Terjadi kesalahan. Silakan coba lagi nanti.";
            }
            
            // Tutup statement
            $stmt->close();
        }
        
        // Tutup koneksi
        $conn->close();
    }
}
?>

<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistem Informasi Magang</title>
    <style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        background-color: #f5f5f5;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .login-container {
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        width: 400px;
        max-width: 90%;
        padding: 40px;
    }

    .login-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .login-header h1 {
        color: #333;
        font-size: 28px;
        margin-bottom: 10px;
    }

    .login-header p {
        color: #666;
        font-size: 16px;
    }

    .login-form .form-group {
        margin-bottom: 20px;
    }

    .login-form label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 600;
    }

    .login-form input {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 16px;
        transition: border-color 0.3s;
    }

    .login-form input:focus {
        border-color: #4a6fdc;
        outline: none;
    }

    .login-form button {
        width: 100%;
        background-color: #4a6fdc;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 12px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .login-form button:hover {
        background-color: #3a5fcc;
    }

    .remember-me {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }

    .remember-me input {
        margin-right: 10px;
        width: auto;
    }

    .forgot-password {
        text-align: center;
        margin-top: 20px;
    }

    .forgot-password a {
        color: #4a6fdc;
        text-decoration: none;
    }

    .forgot-password a:hover {
        text-decoration: underline;
    }

    .error-message {
        background-color: #f8d7da;
        color: #721c24;
        padding: 10px;
        border-radius: 4px;
        margin-bottom: 20px;
        text-align: center;
    }
    </style>
</head>

<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Sistem Informasi Magang</h1>
            <p>Silakan masuk ke akun Anda</p>
        </div>

        <?php if(!empty($error_message)): ?>
        <div class="error-message">
            <?php echo $error_message; ?>
        </div>
        <?php endif; ?>

        <form class="login-form" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
            <div class="form-group">
                <label for="username">Email</label>
                <input type="text" id="username" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit">Login</button>
        </form>
    </div>
</body>

</html>