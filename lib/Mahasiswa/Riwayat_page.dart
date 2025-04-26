import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magangku/Mahasiswa/detail_riwayat_page.dart'; // Pastikan path ini benar

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key});

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<dynamic>> _riwayatPresensi;
  final String _baseUrl =
      'http://192.168.64.142:8000'; // PASTIKAN BASE URL INI BENAR

  @override
  void initState() {
    super.initState();
    _riwayatPresensi = _fetchRiwayatPresensi();
  }

  Future<List<dynamic>> _fetchRiwayatPresensi() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_riwayat_presensi.php'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat riwayat kehadiran');
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
      appBar: AppBar(
        title: const Text(
          'Daftar Hadir',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        backgroundColor: const Color(0xFF1C3B70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              print('Ikon Unduh Ditekan!');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _riwayatPresensi,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> riwayatList = snapshot.data!;
            return ListView.builder(
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, riwayatList[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 16.0),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, dynamic item) {
    String nama = item['nama'] ?? 'Nama Tidak Tersedia';
    String tanggal = DateFormat('dd MMMM yyyy', 'id_ID').format(
      DateTime.parse(item['tanggal'] ?? DateTime.now().toIso8601String()),
    );
    String waktuMasuk = item['waktu_masuk'] ?? '-';
    String waktuPulang = item['waktu_pulang'] ?? '-';
    String fotoMasukPath = item['foto_masuk'];
    String fotoPulangPath = item['foto_pulang'];
    String lokasiMasuk = item['lokasi_masuk'] ?? '-';
    String lokasiPulang = item['lokasi_pulang'] ?? '-';

    int? mahasiswaIdForItem;
    if (item['user_id'] != null) {
      if (item['user_id'] is String) {
        mahasiswaIdForItem = int.tryParse(item['user_id']);
      } else if (item['user_id'] is int) {
        mahasiswaIdForItem = item['user_id'];
      }
    }

    String fotoMasukUrl =
        fotoMasukPath != null
            ? '$_baseUrl/$fotoMasukPath'
            : 'https://via.placeholder.com/60/00FF00/FFFFFF?Text=Masuk';
    String fotoPulangUrl =
        fotoPulangPath != null
            ? '$_baseUrl/$fotoPulangPath'
            : 'https://via.placeholder.com/60/FF0000/FFFFFF?Text=Pulang';

    return InkWell(
      onTap: () {
        const int fixedMahasiswaId = 21;
        const String newBaseUrl =
            'http://192.168.64.142:8000/get_riwayat_presensi.php'; // Ganti dengan URL server baru Anda

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetailRiwayatPage(
                  mahasiswaId: fixedMahasiswaId,
                  baseUrl: newBaseUrl,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      tanggal,
                      style: const TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 160, // Lebar disesuaikan
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: NetworkImage(fotoMasukUrl),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                print(
                                  'Error loading image (masuk): $exception',
                                );
                              },
                            ),
                            border: Border.all(
                              color: const Color.fromARGB(255, 116, 116, 116),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                waktuMasuk,
                                style: const TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Lokasi: $lokasiMasuk',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: NetworkImage(fotoPulangUrl),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                print(
                                  'Error loading image (pulang): $exception',
                                );
                              },
                            ),
                            border: Border.all(
                              color: const Color.fromARGB(255, 108, 108, 108),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                'Pulang',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                waktuPulang,
                                style: const TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Lokasi: $lokasiPulang',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 26.0,
                        ),
                      ],
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
