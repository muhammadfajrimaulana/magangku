import 'package:flutter/material.dart';

class PresensiPage extends StatelessWidget {
  const PresensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presensi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(child: Text('Halaman Presensi')),
    );
  }
}
