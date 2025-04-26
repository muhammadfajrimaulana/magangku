import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<dynamic> _riwayatPresensi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayatPresensi();
  }

  // Dummy data sementara untuk tampilan
  final List<Map<String, dynamic>> _dummyRiwayat = [
    {
      'nama': 'M Fajri maulana',
      'tanggal': '2025-12-04',
      'waktu_masuk': '08.00',
      'status_masuk': 'Sesuai',
      'waktu_pulang': '18.30',
      'status_pulang': 'Terlambat',
      'foto': 'https://via.placeholder.com/60/blue/fff?Text=Foto',
    },
    {
      'nama': 'M Fajri maulana',
      'tanggal': '2025-12-04',
      'waktu_masuk': '08.00',
      'status_masuk': 'Sesuai',
      'waktu_pulang': '18.30',
      'status_pulang': 'Terlambat',
      'foto': 'https://via.placeholder.com/60/grey/fff?Text=Foto',
    },
    {
      'nama': 'M Fajri maulana',
      'tanggal': '2025-12-04',
      'waktu_masuk': '08.00',
      'status_masuk': 'Sesuai',
      'waktu_pulang': '18.30',
      'status_pulang': 'Terlambat',
      'foto': 'https://via.placeholder.com/60/blue/fff?Text=Foto',
    },
  ];

  Future<void> _fetchRiwayatPresensi() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _riwayatPresensi = _dummyRiwayat;
      _isLoading = false;
    });
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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C3B70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Tambahkan widget actions di sini
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ), // Ganti Icons.donut_large dengan ikon "untuh" yang Anda inginkan
            onPressed: () {
              // Tambahkan logika ketika ikon "untuh" ditekan
              print('Ikon Untuh Ditekan!');
            },
          ),
          const SizedBox(width: 8.0), // Berikan sedikit jarak dari tepi kanan
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _riwayatPresensi.length,
                itemBuilder: (context, index) {
                  return _buildListItem(context, _riwayatPresensi[index]);
                },
              ),
    );
  }

  Widget _buildListItem(BuildContext context, dynamic item) {
    String nama = item['nama'] ?? 'Nama Tidak Tersedia';
    String tanggal = DateFormat(
      'dd MMMM<\ctrl3348>',
    ).format(DateTime.parse(item['tanggal']));
    String waktuMasuk = item['waktu_masuk'] ?? '-';
    String statusMasuk = (item['status_masuk'] ?? '').toLowerCase();
    String waktuPulang = item['waktu_pulang'] ?? '-';
    String statusPulang = (item['status_pulang'] ?? '').toLowerCase();
    String fotoUrl = item['foto'] ?? 'https://via.placeholder.com/60';

    return Container(
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
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                Text(tanggal, style: const TextStyle(fontSize: 11.0)),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 128,
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: NetworkImage(fotoUrl),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {},
                          ),
                          border: Border.all(
                            color: const Color.fromARGB(255, 6, 180, 255),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Masuk',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              waktuMasuk,
                              style: const TextStyle(fontSize: 11.0),
                            ),
                            Text(
                              statusMasuk[0].toUpperCase() +
                                  statusMasuk.substring(1),
                              style: TextStyle(
                                color:
                                    statusMasuk == 'sesuai'
                                        ? Colors.green
                                        : (statusMasuk == 'terlambat'
                                            ? Colors.red
                                            : Colors.black),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 0.0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: const Color.fromARGB(255, 6, 180, 255),
                          ),
                          color: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const Text(
                            'Pulang',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            waktuPulang,
                            style: const TextStyle(fontSize: 11.0),
                          ),
                          Text(
                            statusPulang[0].toUpperCase() +
                                statusPulang.substring(1),
                            style: TextStyle(
                              color:
                                  statusPulang == 'sesuai'
                                      ? Colors.green
                                      : (statusPulang == 'terlambat'
                                          ? Colors.red
                                          : Colors.black),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24.0),
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
