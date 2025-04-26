import 'package:flutter/material.dart';
import 'package:magangku/Mahasiswa/LoginPage.dart';
import 'package:magangku/Mahasiswa/Kelola_profile_page.dart';
import 'package:magangku/Admin/Presensi_page.dart';
import 'package:magangku/Admin/Izin_page.dart';
import 'package:magangku/Admin/Riwayat_page.dart';
import 'package:magangku/Admin/Template_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magangku/Admin/admin_notification_page.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // Import untuk File

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String _nama = '';
  String _jabatan = 'admin';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('namaAdmin') ?? 'Admin';
      _jabatan = prefs.getString('jabatanAdmin') ?? 'Staf Fakultas';
      String? imagePath = prefs.getString('fotoAdmin');
      if (imagePath != null) {
        _imageFile = File(imagePath);
      }
    });
  }

  void _updateProfile(dynamic profileData) {
    if (profileData is Map<String, dynamic>) {
      setState(() {
        _nama = profileData['nama'] ?? _nama;
        _jabatan = profileData['jabatan'] ?? _jabatan;
        if (profileData['image'] != null && profileData['image'] is File) {
          _imageFile = profileData['image'];
          _saveImageToPrefs(_imageFile!.path);
        }
      });
    } else {
      print("Data profile bukan bertipe map");
    }
  }

  Future<void> _saveImageToPrefs(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fotoAdmin', imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildHeader(),
                _buildDateTime(),
                _buildFeatureBackground(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C3B70),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => KelolaProfilePage(
                        onProfileUpdated: _updateProfile,
                        role: 'admin',
                      ),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider<Object>?
                          : const AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(_jabatan, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminNotificationPage(),
                    ),
                  );
                },
                child: const Icon(Icons.notifications, color: Colors.white),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMM', 'id_ID').format(now);
    final formattedTime = DateFormat('HH:mm:ss WIB').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF283B71),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$formattedDate\n$formattedTime',
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFeatureBackground() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C3B70),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _buildMenu(),
    );
  }

  Widget _buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildMenuItem(Icons.assignment, 'PRESENSI', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PresensiPage()),
          );
        }),
        _buildMenuItem(Icons.mail, 'IZIN', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IzinPage()),
          );
        }),
        _buildMenuItem(Icons.history, 'RIWAYAT', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RiwayatPage()),
          );
        }),
        _buildMenuItem(Icons.description, 'TEMPLATE', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TemplatePage()),
          );
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(icon, size: 28, color: const Color(0xFF1C3B70)),
          ),
          const SizedBox(height: 15),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
