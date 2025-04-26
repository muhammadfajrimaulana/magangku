import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PembimbingNotificationPage extends StatefulWidget {
  const PembimbingNotificationPage({super.key});

  @override
  State<PembimbingNotificationPage> createState() =>
      _PembimbingNotificationPageState();
}

class _PembimbingNotificationPageState
    extends State<PembimbingNotificationPage> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(now);
    final formattedTime = DateFormat('HH:mm:ss WIB').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Notifikasi Baru!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Tanggal: $formattedDate'),
                  Text('Waktu: $formattedTime'),
                  const SizedBox(height: 8),
                  const Text('Ini adalah contoh notifikasi untuk pembimbing.'),
                ],
              ),
            ),
          ),
          // Tambahkan notifikasi lainnya di sini (sesuai kebutuhan aplikasi Anda)
        ],
      ),
    );
  }
}
