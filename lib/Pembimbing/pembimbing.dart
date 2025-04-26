import 'dart:io'; // Import untuk File
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:magangku/Mahasiswa/LoginPage.dart';
import 'package:magangku/Mahasiswa/Kelola_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magangku/pembimbing/Presensi_page.dart';
import 'package:magangku/pembimbing/Izin_page.dart';
import 'package:magangku/pembimbing/Riwayat_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:magangku/pembimbing/pembimbing_notification_page.dart'; // Import PembimbingNotificationPage

class Pembimbing extends StatefulWidget {
  const Pembimbing({super.key});

  @override
  _PembimbingState createState() => _PembimbingState();
}

class _PembimbingState extends State<Pembimbing> {
  String _location = 'Mencari lokasi...';
  String _nama = '';
  String _jabatan = 'Pembimbing Lapangan';
  File? _imageFile; // Tambahkan untuk menyimpan file gambar
  // late GoogleMapController mapController;
  LatLng _center = const LatLng(0, 0); // Atur inisialisasi awal ke (0, 0)

  @override
  void initState() {
    super.initState();
    _loadPembimbingData();
    _getCurrentLocation();
  }

  Future<void> _loadPembimbingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('namaPembimbing') ?? 'Pembimbing';
      _jabatan = prefs.getString('jabatanPembimbing') ?? 'Pembimbing Lapangan';
      String? imagePath = prefs.getString('fotoPembimbing');
      if (imagePath != null) {
        _imageFile = File(imagePath);
      }
    });
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _location = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
        _center = LatLng(position.latitude, position.longitude);
      });

      // if (mapController != null) {
      //   mapController.animateCamera(CameraUpdate.newLatLng(_center));
      // }
    } catch (e) {
      setState(() {
        _location = 'Gagal mendapatkan lokasi: $e';
      });
    }
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
    await prefs.setString('fotoPembimbing', imagePath);
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
                // _buildDateTime(),
                _buildMenu(),
                // _buildMap(),
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
                        role: 'pembimbing',
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
                      builder: (context) => const PembimbingNotificationPage(),
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

  // Widget _buildDateTime() {
  //   final now = DateTime.now();
  //   final formattedDate = DateFormat(
  //     'EEEE, dd, MMMM yyyy',
  //     'id_ID',
  //   ).format(now);
  //   final formattedTime = DateFormat('HH:mm:ss WIB').format(now);

  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16.0),
  //     margin: const EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF283B71),
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           blurRadius: 5,
  //           offset: const Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Center(
  //       child: Text(
  //         '$formattedDate\n$formattedTime',
  //         style: const TextStyle(color: Colors.white, fontSize: 16),
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMenu() {
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
      child: Row(
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
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFFE8EAF6),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: const Color(0xFF283B71)),
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Widget _buildMap() {
  //   return Expanded(
  //     child: GoogleMap(
  //       // onMapCreated: _onMapCreated,
  //       initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
  //       markers: {
  //         Marker(
  //           markerId: const MarkerId('lokasi_anda'),
  //           position: _center,
  //           infoWindow: InfoWindow(title: 'Lokasi Anda', snippet: _location),
  //         ),
  //       },
  //     ),
  //   );
  // }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _namaPerusahaanController =
      TextEditingController();
  final TextEditingController _namaPimpinanController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaPerusahaanController.text = prefs.getString('namaPerusahaan') ?? '';
      _namaPimpinanController.text = prefs.getString('namaPimpinan') ?? '';
      _noTeleponController.text = prefs.getString('noTelepon') ?? '';
      _alamatController.text = prefs.getString('alamat') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('namaPerusahaan', _namaPerusahaanController.text);
    prefs.setString('namaPimpinan', _namaPimpinanController.text);
    prefs.setString('noTelepon', _noTeleponController.text);
    prefs.setString('alamat', _alamatController.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pengaturan disimpan!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Silahkan Lengkapi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Mohon isi informasi yang dibutuhkan.'),
            const SizedBox(height: 24),
            _buildTextField(
              'Nama Perusahaan',
              'nama perusahaan',
              _namaPerusahaanController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Nama Pimpinan',
              'nama pimpinan',
              _namaPimpinanController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'No Telepon',
              'nomor telepon',
              _noTeleponController,
            ),
            const SizedBox(height: 16),
            _buildTextField('Alamat', 'masukan alamat', _alamatController),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C3B70),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(labelText),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
