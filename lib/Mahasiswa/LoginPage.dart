import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:magangku/Mahasiswa/LupaPassword.dart';
import 'package:magangku/Mahasiswa/SignUpPage.dart';
import 'package:magangku/mahasiswa/HomePage.dart';
import 'package:magangku/Pembimbing/pembimbing.dart'; // Pastikan path ke halaman Pembimbing benar
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:magangku/admin/AdminHomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_userController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Username dan password harus diisi.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String username = _userController.text;
    String password = _passwordController.text;

    try {
      var response = await http.post(
        Uri.parse('http://192.168.64.142:8000/login.php'),
        body: {'username': username, 'password': password},
      );

      print('LoginPage - Response status code: ${response.statusCode}');
      print('LoginPage - Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['success'] == true && data['user'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('role', data['user']['role']);

          if (data['user']['role'] == 'mahasiswa') {
            await prefs.setString('idMahasiswa', data['user']['id'].toString());
            await prefs.setString('namaMahasiswa', data['user']['nama']);
            await prefs.setString(
              'programStudiMahasiswa',
              data['user']['program_studi'],
            );
            if (data['user']['foto_profil'] != null &&
                data['user']['foto_profil'].isNotEmpty) {
              await prefs.setString(
                'fotoProfilMahasiswa',
                data['user']['foto_profil'],
              );
            } else {
              await prefs.remove('fotoProfilMahasiswa');
            }
          } else if (data['user']['role'] == 'admin') {
            await prefs.setString('idAdmin', data['user']['id'].toString());
            await prefs.setString('namaAdmin', data['user']['nama']);
            await prefs.setString('jabatanAdmin', data['user']['jabatan']);
            if (data['user']['foto_profil'] != null &&
                data['user']['foto_profil'].isNotEmpty) {
              await prefs.setString(
                'fotoProfilAdmin',
                data['user']['foto_profil'],
              );
            } else {
              await prefs.remove('fotoProfilAdmin');
            }
          } else if (data['user']['role'] == 'mentor') {
            await prefs.setString(
              'idPembimbing',
              data['user']['id'].toString(),
            );
            await prefs.setString('namaPembimbing', data['user']['nama']);
            if (data['user']['foto_profil'] != null &&
                data['user']['foto_profil'].isNotEmpty) {
              await prefs.setString(
                'fotoProfilPembimbing',
                data['user']['foto_profil'],
              );
            } else {
              await prefs.remove('fotoProfilPembimbing');
            }
          }

          _navigateToprogramstudiPage(data['user']['role']);
        } else {
          _showSnackBar(
            data['message'] ??
                'Login gagal. Periksa username dan password Anda.',
          );
        }
      } else {
        _showSnackBar('Error koneksi ke server: ${response.statusCode}');
      }
    } catch (e) {
      print('LoginPage - Error: $e');
      _showSnackBar('Terjadi kesalahan. Silakan coba lagi.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToprogramstudiPage(String roleName) {
    if (roleName == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    } else if (roleName == 'mahasiswa') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (roleName == "mentor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Pembimbing(),
        ), // Navigasi ke Pembimbing
      );
    } else {
      _showSnackBar('ID pengguna tidak dikenal: $roleName');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C3B70),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo2.png', height: 80),
              const SizedBox(height: 20),
              const Text(
                'Masuk dan Verifikasi',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Baru! Masuk ke akun Anda dan nikmati kemudahan mengelola absensi serta aktivitas magang dengan Absensi Online.',
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  hintStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Lupapassword(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                          'Login',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum Punya Akun?',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Buat',
                      style: TextStyle(color: Color.fromARGB(255, 55, 20, 255)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
