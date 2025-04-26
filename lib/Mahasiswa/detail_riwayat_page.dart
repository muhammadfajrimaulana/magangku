import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailRiwayatPage extends StatefulWidget {
  final int mahasiswaId;
  final String baseUrl;

  const DetailRiwayatPage({
    Key? key,
    required this.mahasiswaId,
    this.baseUrl = 'http://192.168.64.142:8000', // Perbaiki baseUrl
  }) : super(key: key);

  @override
  State<DetailRiwayatPage> createState() => _DetailRiwayatPageState();
}

class _DetailRiwayatPageState extends State<DetailRiwayatPage> {
  dynamic _dataRiwayat;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    // Pastikan baseUrl tidak kosong sebelum digunakan
    if (widget.baseUrl.isEmpty) {
      setState(() {
        _errorMessage = 'Base URL tidak valid.';
        _isLoading = false;
      });
      return;
    }

    final String apiUrl =
        '${widget.baseUrl}/api/riwayat?id=${widget.mahasiswaId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            _dataRiwayat = data.first;
            _isLoading = false;
          });
        } else if (data is Map<String, dynamic> && data.isNotEmpty) {
          setState(() {
            _dataRiwayat = data;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Data riwayat tidak ditemukan.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Gagal mengambil data riwayat: Status ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error saat menghubungi backend: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Riwayat'),
          backgroundColor: const Color(0xFF1C3B70),
          titleTextStyle: const TextStyle(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(child: Text(_errorMessage)),
      );
    }

    if (_dataRiwayat == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Riwayat'),
          backgroundColor: const Color(0xFF1C3B70),
          titleTextStyle: const TextStyle(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('Tidak ada data riwayat untuk ditampilkan.'),
        ),
      );
    }

    String nama = _dataRiwayat['nama'] ?? 'Nama Tidak Tersedia';
    String tanggal =
        _dataRiwayat['tanggal'] != null
            ? DateFormat(
              'dd MMMM yyyy',
              'id_ID',
            ).format(DateTime.parse(_dataRiwayat['tanggal']))
            : 'Tanggal Tidak Tersedia';
    String waktuMasuk = _dataRiwayat['waktu_masuk'] ?? '-';
    String waktuPulang = _dataRiwayat['waktu_pulang'] ?? '-';
    String? fotoMasukPath = _dataRiwayat['foto_masuk'];
    String? fotoPulangPath = _dataRiwayat['foto_pulang'];
    String lokasiMasuk = _dataRiwayat['lokasi_masuk'] ?? '-';
    String lokasiPulang = _dataRiwayat['lokasi_pulang'] ?? '-';
    String catatanKegiatanMasuk = _dataRiwayat['catatan_kegiatan_masuk'] ?? '';
    String catatanKegiatanPulang =
        _dataRiwayat['catatan_kegiatan_pulang'] ?? '';

    String fotoMasukUrl =
        fotoMasukPath != null && widget.baseUrl.isNotEmpty
            ? '${widget.baseUrl}/$fotoMasukPath'
            : 'https://via.placeholder.com/60/00FF00/FFFFFF?Text=Masuk';
    String fotoPulangUrl =
        fotoPulangPath != null && widget.baseUrl.isNotEmpty
            ? '${widget.baseUrl}/$fotoPulangPath'
            : 'https://via.placeholder.com/60/FF0000/FFFFFF?Text=Pulang';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Riwayat $nama'),
        backgroundColor: const Color(0xFF1C3B70),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              nama,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3B70),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 8.0),
                        Text(
                          'Username: ${_dataRiwayat['username'] ?? '-'}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.calendar_today, color: Colors.white),
                        const SizedBox(width: 8.0),
                        Text(
                          tanggal,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Presensi Masuk',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Waktu: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(waktuMasuk),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Lokasi: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          lokasiMasuk,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                  if (fotoMasukPath != null && widget.baseUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              fotoMasukUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image (masuk): $error');
                                return const Icon(Icons.error_outline);
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              constraints: const BoxConstraints(
                                minHeight: 100.0,
                              ),
                              child: Text(
                                catatanKegiatanMasuk.isNotEmpty
                                    ? 'Catatan: $catatanKegiatanMasuk'
                                    : 'Tidak ada catatan.',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (fotoMasukPath != null &&
                      widget.baseUrl.isEmpty &&
                      catatanKegiatanMasuk.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Catatan: $catatanKegiatanMasuk',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Presensi Pulang',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Waktu: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(waktuPulang),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Lokasi: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 16.0,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          lokasiPulang,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                  if (fotoPulangPath != null && widget.baseUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              fotoPulangUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image (pulang): $error');
                                return const Icon(Icons.error_outline);
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              constraints: const BoxConstraints(
                                minHeight: 100.0,
                              ),
                              child: Text(
                                catatanKegiatanPulang.isNotEmpty
                                    ? 'Catatan: $catatanKegiatanPulang'
                                    : 'Tidak ada catatan.',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (fotoPulangPath != null &&
                      widget.baseUrl.isEmpty &&
                      catatanKegiatanPulang.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Catatan: $catatanKegiatanPulang',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
