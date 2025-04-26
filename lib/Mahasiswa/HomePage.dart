import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:magangku/Mahasiswa/LoginPage.dart';
import 'package:magangku/Mahasiswa/Kelola_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magangku/Mahasiswa/Presensi_page.dart';
import 'package:magangku/Mahasiswa/Presensi_pagePulang.dart';
import 'package:magangku/Mahasiswa/Izin_page.dart';
import 'package:magangku/Mahasiswa/Riwayat_page.dart';
import 'package:magangku/Mahasiswa/template_page.dart';
import 'package:magangku/Mahasiswa/Setting_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:magangku/Mahasiswa/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _location = 'Mencari lokasi...';
  String _nama = '';
  String _programStudi = '';
  String _fotoProfilPath = 'assets/profiles/default.png';
  TimeOfDay _masukTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _pulangTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadUserData(); // Memuat data pengguna dari SharedPreferences
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {});
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? namaMahasiswa = prefs.getString('namaMahasiswa');
    String? programStudiMahasiswa = prefs.getString('programStudiMahasiswa');
    String? fotoProfilMahasiswa = prefs.getString('fotoProfilMahasiswa');
    String? namaAdmin = prefs.getString('namaAdmin');
    String? jabatanAdmin = prefs.getString('jabatanAdmin');
    String? fotoProfilAdmin = prefs.getString('fotoProfilAdmin');
    String? namaPembimbing = prefs.getString('namaPembimbing');
    String? fotoProfilPembimbing = prefs.getString('fotoProfilPembimbing');
    String? role = prefs.getString('role');

    setState(() {
      if (role == 'mahasiswa') {
        _nama = namaMahasiswa ?? '';
        _programStudi = programStudiMahasiswa ?? '';
        _fotoProfilPath =
            fotoProfilMahasiswa != null && fotoProfilMahasiswa.isNotEmpty
                ? 'http://192.168.64.142:8000/' + fotoProfilMahasiswa
                : 'assets/profiles/default.png';
      } else if (role == 'admin') {
        _nama = namaAdmin ?? '';
        _programStudi = jabatanAdmin ?? '';
        _fotoProfilPath =
            fotoProfilAdmin != null && fotoProfilAdmin.isNotEmpty
                ? 'http://192.168.64.142:8000/' + fotoProfilAdmin
                : 'assets/profiles/default.png';
      } else if (role == 'mentor') {
        _nama = namaPembimbing ?? '';
        _programStudi = '';
        _fotoProfilPath =
            fotoProfilPembimbing != null && fotoProfilPembimbing.isNotEmpty
                ? 'http://192.168.64.142:8000/' + fotoProfilPembimbing
                : 'assets/profiles/default.png';
      }
      print('HomePage - Nama dari SharedPreferences: $_nama');
      print(
        'HomePage - Program Studi/Jabatan dari SharedPreferences: $_programStudi',
      );
      print('HomePage - Foto Profil dari SharedPreferences: $_fotoProfilPath');
      print('HomePage - Role dari SharedPreferences: $role');
    });
  }

  String _getUserProfileAssetPath() {
    return _fotoProfilPath;
  }

  void _updateProfile(dynamic profileData) {
    print(
      'HomePage - Data Profil Diterima dari KelolaProfilDetail: $profileData',
    );
    if (profileData is Map<String, dynamic>) {
      setState(() {
        _nama = profileData['nama'] ?? _nama;
        _programStudi = profileData['programStudi'] ?? _programStudi;
        if (profileData['foto_profil'] != null &&
            profileData['foto_profil'].isNotEmpty) {
          _fotoProfilPath =
              'http://192.168.64.142:8000/' + profileData['foto_profil'];
          print(
            'HomePage - _fotoProfilPath diupdate menjadi: $_fotoProfilPath',
          );
        }
      });
    } else {
      print("HomePage - Data profile bukan bertipe map");
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _masukTime = TimeOfDay(
        hour: prefs.getInt('alarmMasukHour') ?? 8,
        minute: prefs.getInt('alarmMasukMinute') ?? 0,
      );
      _pulangTime = TimeOfDay(
        hour: prefs.getInt('alarmPulangHour') ?? 17,
        minute: prefs.getInt('alarmPulangMinute') ?? 0,
      );
      print(
        'Jam Masuk Dimuat: <span class="math-inline">\{\_masukTime\.hour\}\:</span>{_masukTime.minute}',
      );
      print(
        'Jam Pulang Dimuat: <span class="math-inline">\{\_pulangTime\.hour\}\:</span>{_pulangTime.minute}',
      );
    });
  }

  Future<void> _navigateToSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingPage()),
    );

    if (result != null) {
      setState(() {
        _masukTime = result['alarmMasukTime'];
        _pulangTime = result['alarmPulangTime'];
        _loadSettings();
      });
    }
  }

  Future<void> _doPresensi(bool isMasuk) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      var response = await http.post(
        Uri.parse('http://192.168.64.142:8000/presensi.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'isMasuk': isMasuk,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          _showSnackBar('Presensi berhasil dicatat.');
        } else {
          _showSnackBar(data['message'] ?? 'Gagal mencatat presensi.');
        }
      } else {
        _showSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan. Silakan coba lagi.');
      print('Error: $e');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildHeader(),
                _buildDateTime(),
                _buildFeatureBackground(),
                _buildAttendanceTime(),
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
                        role:
                            'mahasiswa', // Asumsi peran mahasiswa dari HomePage ini
                      ),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  key: ValueKey(
                    _fotoProfilPath +
                        DateTime.now().millisecondsSinceEpoch.toString(),
                  ), // Pindahkan Key ke CircleAvatar
                  radius: 30,
                  backgroundImage:
                      _fotoProfilPath.startsWith('http')
                          ? NetworkImage(_fotoProfilPath)
                          : const AssetImage('assets/profiles/default.png')
                              as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
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
                    Text(
                      _programStudi,
                      style: const TextStyle(color: Colors.white),
                    ),
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
                      builder: (context) => const NotificationPage(),
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
              const SizedBox(width: 16),
              GestureDetector(
                onTap: _navigateToSettings,
                child: const Icon(Icons.settings, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

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
          '$formattedDate\n$formattedTime WIB',
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
        }, isButton: true),
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

  Widget _buildMenuItem(
    IconData icon,
    String text,
    VoidCallback onTap, {
    bool isButton = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          if (isButton)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8EAF6),
                padding: const EdgeInsets.all(16.0),
                shape: const CircleBorder(),
                shadowColor: Colors.grey.withOpacity(0.3),
                elevation: 3,
              ),
              child: Icon(icon, size: 30, color: const Color(0xFF283B71)),
            )
          else
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
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

  Widget _buildAttendanceTime() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildAttendanceButton(
                DateFormat('HH:mm').format(
                      DateTime(2020, 1, 1, _masukTime.hour, _masukTime.minute),
                    ) +
                    ' WIB',
                'MASUK',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PresensiPage(),
                    ),
                  );
                },
              ),
              _buildAttendanceButton(
                DateFormat('HH:mm').format(
                      DateTime(
                        2020,
                        1,
                        1,
                        _pulangTime.hour,
                        _pulangTime.minute,
                      ),
                    ) +
                    ' WIB',
                'PULANG',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PresensiPulangPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            children: <Widget>[
              const Text(
                'Lokasi Anda Saat Ini:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Container(
                width: 350,
                height: 100,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(_location, textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton(
    String time,
    String text,
    VoidCallback onPressed,
  ) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(time, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF283B71),
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _alarmMasukEnabled = true;
  bool _alarmPulangEnabled = true;
  late TimeOfDay _alarmMasukTime;
  late TimeOfDay _alarmPulangTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _alarmMasukTime = TimeOfDay(
        hour: prefs.getInt('alarmMasukHour') ?? 8,
        minute: prefs.getInt('alarmMasukMinute') ?? 0,
      );
      _alarmPulangTime = TimeOfDay(
        hour: prefs.getInt('alarmPulangHour') ?? 17,
        minute: prefs.getInt('alarmPulangMinute') ?? 0,
      );
      _alarmMasukEnabled = prefs.getBool('alarmMasukEnabled') ?? true;
      _alarmPulangEnabled = prefs.getBool('alarmPulangEnabled') ?? true;
      print(
        'SettingPage - Jam Masuk Disimpan: ${_alarmMasukTime.hour}:${_alarmMasukTime.minute}',
      );
      print(
        'SettingPage - Jam Pulang Disimpan: ${_alarmPulangTime.hour}:${_alarmPulangTime.minute}',
      );
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarmMasukHour', _alarmMasukTime.hour);
    await prefs.setInt('alarmMasukMinute', _alarmMasukTime.minute);
    await prefs.setInt('alarmPulangHour', _alarmPulangTime.hour);
    await prefs.setInt('alarmPulangMinute', _alarmPulangTime.minute);
    await prefs.setBool('alarmMasukEnabled', _alarmMasukEnabled);
    await prefs.setBool('alarmPulangEnabled', _alarmPulangEnabled);
    print(
      'SettingPage - Jam Masuk Disimpan: ${_alarmMasukTime.hour}:${_alarmMasukTime.minute}',
    );
    print(
      'SettingPage - Jam Pulang Disimpan: ${_alarmPulangTime.hour}:${_alarmPulangTime.minute}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('Alarm Masuk'),
              subtitle: Text(
                '${_alarmMasukTime.hour}:${_alarmMasukTime.minute}',
              ),
              trailing: Switch(
                value: _alarmMasukEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _alarmMasukEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              onTap: () async {
                final TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: _alarmMasukTime,
                );
                if (newTime != null) {
                  setState(() {
                    _alarmMasukTime = newTime;
                  });
                  _saveSettings();
                }
              },
            ),
            ListTile(
              title: const Text('Alarm Pulang'),
              subtitle: Text(
                '${_alarmPulangTime.hour}:${_alarmPulangTime.minute}',
              ),
              trailing: Switch(
                value: _alarmPulangEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _alarmPulangEnabled = value;
                  });
                  _saveSettings();
                },
              ),
              onTap: () async {
                final TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: _alarmPulangTime,
                );
                if (newTime != null) {
                  setState(() {
                    _alarmPulangTime = newTime;
                  });
                  _saveSettings();
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'alarmMasukTime': _alarmMasukTime,
                  'alarmPulangTime': _alarmPulangTime,
                });
              },
              child: const Text('Simpan Pengaturan'),
            ),
          ],
        ),
      ),
    );
  }
}
