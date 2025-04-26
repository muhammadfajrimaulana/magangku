import 'package:flutter/material.dart';

class PresensiPage extends StatelessWidget {
  const PresensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Izin', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items:
                        <String>['Tahun'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Cari ...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildIzinItem(
              context,
              'M Fajri Maulana',
              'Teknik Informatika - 2021\nDinas PPKUKM DKI Jakarta',
              'assets/images/mahasiswa1.jpg', // Ganti dengan path gambar yang sesuai
              Colors.grey[300]!, // Warna kotak abu-abu di sebelah kanan
            ),
            const SizedBox(height: 8),
            _buildIzinItem(
              context,
              'Karyadi',
              'Teknik Informatika - Tahun 2022\nPT salindo jaya karta jkt uhuy',
              'assets/images/placeholder.jpg', // Ganti dengan path gambar placeholder
              Colors.blue, // Warna kotak biru di sebelah kanan
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIzinItem(
    BuildContext context,
    String name,
    String description,
    String imagePath,
    Color rightBoxColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: AssetImage(imagePath), radius: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(description),
                ],
              ),
            ),
            Container(width: 20, height: 40, color: rightBoxColor),
          ],
        ),
      ),
    );
  }
}
