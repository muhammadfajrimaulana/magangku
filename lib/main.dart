import 'package:flutter/material.dart';
import 'package:magangku/Mahasiswa/OnboardingView.dart';
import 'package:magangku/Mahasiswa/kelola_profil_detail.dart';
import 'package:magangku/Mahasiswa/ubah_kata_sandi_page.dart';
import 'package:magangku/Mahasiswa/setting_page.dart';
import 'package:magangku/Mahasiswa/tentang_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _getStartingPage(),
      routes: {
        '/kelola-profil-detail': (context) {
          // Ambil nilai role dari halaman sebelumnya atau state management.
          // Ganti 'mahasiswa' dengan logika untuk mendapatkan role pengguna.
          String userRole = 'mahasiswa';
          return KelolaProfilDetail(
            onProfileUpdated: (profileData) {
              // Tangani pembaruan profil di sini
              if (profileData is Map<String, dynamic>) {
                String nama = profileData['nama'];
                String programStudi = profileData['programStudi'];
                var image = profileData['image'];

                print('Nama: $nama');
                print('Program Studi: $programStudi');
                print('Image: $image');
              } else {
                print('Data profil tidak valid.');
              }
            },
            role: userRole, // Tambahkan parameter role
          );
        },
        '/ubah-kata-sandi': (context) => const UbahKataSandiPage(),
        '/setting': (context) => const SettingPage(),
        '/tentang': (context) => const TentangPage(),
        '/kelola-profile':
            (context) => KelolaProfilePage(
              onProfileUpdated: (profileData) {
                // Tangani pembaruan profil di sini
                if (profileData is Map<String, dynamic>) {
                  String nama = profileData['nama'];
                  String programStudi = profileData['programStudi'];
                  var image = profileData['image'];

                  print('Nama: $nama');
                  print('Program Studi: $programStudi');
                  print('Image: $image');
                } else {
                  print('Data profil tidak valid.');
                }
              },
            ),
      },
    );
  }

  Widget _getStartingPage() {
    return const OnboardingView();
  }
}

class KelolaProfilePage extends StatelessWidget {
  final Function(dynamic profileData) onProfileUpdated;

  const KelolaProfilePage({super.key, required this.onProfileUpdated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kembali', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          _ProfileItem(
            icon: Icons.person_outline,
            title: 'Kelola Profil',
            route: '/kelola-profil-detail',
            onTap: () {
              Navigator.pushNamed(context, '/kelola-profil-detail');
            },
          ),
          _ProfileItem(
            icon: Icons.visibility_outlined,
            title: 'Ubah Kata Sandi',
            route: '/ubah-kata-sandi',
            onTap: () {
              Navigator.pushNamed(context, '/ubah-kata-sandi');
            },
          ),
          _ProfileItem(
            icon: Icons.settings_outlined,
            title: 'Setting',
            route: '/setting',
            onTap: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          _ProfileItem(
            icon: Icons.home_outlined,
            title: 'Tentang',
            route: '/tentang',
            onTap: () {
              Navigator.pushNamed(context, '/tentang');
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
