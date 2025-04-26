import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Notifikasi 1: Presensi berhasil dicatat pada 14 April 2025 pukul 08:05 WIB.',
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Notifikasi 2: Izin Anda untuk tanggal 15 April 2025 telah disetujui.',
              ),
            ),
          ),
          // Tambahkan notifikasi lainnya di sini
        ],
      ),
    );
  }
}
