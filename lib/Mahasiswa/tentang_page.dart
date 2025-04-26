import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView untuk scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3B70),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/logo.png', height: 100),
              ),
              const SizedBox(height: 30),
              const Text(
                'Aplikasi Magangku',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aplikasi ini adalah solusi absensi digital berbasis GPS yang dirancang khusus untuk mahasiswa magang. Dengan fitur pelacakan lokasi, aplikasi ini memungkinkan pencatatan kehadiran yang akurat dan otomatis, serta menyediakan rekap data kehadiran selama masa magang.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                'Dengan memanfaatkan teknologi GPS tracking, aplikasi ini memfasilitasi pencatatan kehadiran mahasiswa magang yang transparan dan akurat, serta menghasilkan laporan rekap kehadiran yang komprehensif.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
