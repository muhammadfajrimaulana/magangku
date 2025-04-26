import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({super.key});

  @override
  _IzinPageState createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  TextEditingController jenisCutiController = TextEditingController();
  TextEditingController tanggalMulaiController = TextEditingController();
  TextEditingController tanggalSelesaiController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> _userData = {};
  String? _userId; // Tambahkan variabel untuk menyimpan userId

  @override
  void initState() {
    super.initState();
    _loadUserDataAndId(); // Gabungkan pemuatan data pengguna dan ID
    // keteranganController.text = 'Isi Keterangan yang sesuai';
  }

  Future<void> _loadUserDataAndId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userRole = prefs.getString('role');
    String? nama;
    String? programStudi;
    String? userId;

    if (userRole == 'mahasiswa') {
      nama = prefs.getString('namaMahasiswa');
      programStudi = prefs.getString('programStudiMahasiswa');
      userId = prefs.getString('idMahasiswa');
    } else if (userRole == 'admin') {
      nama = prefs.getString('namaAdmin');
      programStudi = 'N/A';
      userId = prefs.getString('idAdmin');
    } else if (userRole == 'mentor') {
      // Menggunakan 'mentor' sesuai presensi
      nama = prefs.getString('namaPembimbing');
      programStudi = 'N/A';
      userId = prefs.getString('idPembimbing');
    }

    setState(() {
      _userData = {'nama': nama, 'programStudi': programStudi};
      _userId = userId; // Set nilai userId
    });

    print('User Role saat izin: $userRole');
    print('User ID yang didapatkan untuk izin: $_userId'); // Tambahkan log
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2025, 12, 31);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat(
          'd MMM yyyy',
        ).format(picked); // Format lengkap tahun
      });
    }
  }

  Future<void> _kirimIzin() async {
    if (jenisCutiController.text.isEmpty ||
        tanggalMulaiController.text.isEmpty ||
        tanggalSelesaiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom yang wajib.')),
      );
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID tidak ditemukan. Silakan login kembali.'),
        ),
      );
      return;
    }

    var uri = Uri.parse('http://192.168.64.142:8000/proses_izin.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] =
        _userId!; // Gunakan _userId yang sudah didapatkan
    request.fields['nama'] = _userData['nama'] ?? '';
    request.fields['program_studi'] = _userData['programStudi'] ?? '';
    request.fields['jenis_cuti'] = jenisCutiController.text;
    request.fields['tanggal_mulai'] = tanggalMulaiController.text;
    request.fields['tanggal_selesai'] = tanggalSelesaiController.text;
    request.fields['keterangan'] = keteranganController.text;

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('lampiran', _image!.path),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      var decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && decodedResponse['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(decodedResponse['message'])));
        jenisCutiController.clear();
        tanggalMulaiController.clear();
        tanggalSelesaiController.clear();
        // keteranganController.text = 'Isi Keterangan yang sesuai';
        setState(() {
          _image = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              decodedResponse['message'] ??
                  'Terjadi kesalahan saat mengirim izin.',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat menghubungi server.')),
      );
      print('Error mengirim izin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin Cuti', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Jenis Cuti',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: jenisCutiController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tanggal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: tanggalMulaiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed:
                            () => _selectDate(context, tanggalMulaiController),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: tanggalSelesaiController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed:
                            () =>
                                _selectDate(context, tanggalSelesaiController),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Lampiran (Gambar)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3B70),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Lampiran'),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.file(_image!, height: 100),
              ),
            const SizedBox(height: 16),
            const Text(
              'Keterangan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: keteranganController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _kirimIzin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C3B70),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Kirim'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
