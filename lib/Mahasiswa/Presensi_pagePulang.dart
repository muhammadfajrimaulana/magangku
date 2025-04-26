import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magangku/Mahasiswa/Kelola_profile_page.dart'; // Pastikan path ini benar

class PresensiPulangPage extends StatefulWidget {
  const PresensiPulangPage({super.key});

  @override
  _PresensiPulangPageState createState() => _PresensiPulangPageState();
}

class _PresensiPulangPageState extends State<PresensiPulangPage> {
  CameraController? _controller;
  bool _showCamera = false;
  String? _imagePath;
  TextEditingController _aktivitasController = TextEditingController();
  String _currentDate = '';
  String _currentLocation = 'Mencari lokasi...';
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;

  Map<String, dynamic> _userData = {}; // Inisialisasi sebagai map kosong

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Panggil fungsi untuk memuat data pengguna
    _initializeCameraPermissions();
    _getCurrentLocation();
    _updateCurrentDate();
    _loadCameras();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userRole = prefs.getString(
      'role',
    ); // Menggunakan kunci 'role'

    if (userRole == 'mahasiswa') {
      final String? nama = prefs.getString('namaMahasiswa');
      final String? programStudi = prefs.getString('programStudiMahasiswa');
      setState(() {
        _userData = {'nama': nama, 'programStudi': programStudi};
      });
    } else if (userRole == 'admin') {
      final String? nama = prefs.getString('namaAdmin');
      setState(() {
        _userData = {
          'nama': nama,
          'programStudi': 'N/A',
        }; // Atau nilai default lain
      });
    } else if (userRole == 'mentor') {
      // Menggunakan 'mentor' sesuai dengan kode login
      final String? nama = prefs.getString('namaPembimbing');
      setState(() {
        _userData = {
          'nama': nama,
          'programStudi': 'N/A',
        }; // Atau nilai default lain
      });
    } else {
      setState(() {
        _userData = {
          'nama': 'Nama Tidak Tersedia',
          'programStudi': 'Program Studi Tidak Tersedia',
        };
      });
    }
  }

  Future<void> _loadCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _initializeCameraController(_cameras[_currentCameraIndex]);
      }
    } catch (e) {
      print('Gagal mendapatkan daftar kamera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendapatkan daftar kamera: $e')),
        );
      }
    }
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);

    _controller!.addListener(() {
      if (mounted && _controller!.value.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error kamera: ${_controller!.value.errorDescription}',
            ),
          ),
        );
      }
    });

    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Izin kamera ditolak.')),
            );
          }
          break;
        default:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error inisialisasi kamera: ${e.description}'),
              ),
            );
          }
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateCurrentDate() async {
    setState(() {
      _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'Izin lokasi ditolak.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() {
        _currentLocation = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  Future<void> _initializeCameraPermissions() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        _loadCameras(); // Load cameras setelah izin diberikan
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Izin kamera ditolak')));
        }
      }
    } else if (status.isGranted) {
      _loadCameras(); // Load cameras jika izin sudah diberikan
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _aktivitasController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final image = await _controller!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/image.jpg';
      await File(image.path).copy(imagePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('Foto diambil: $imagePath')),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.45,
              left: 50,
              right: 50,
            ),
          ),
        );
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://192.168.64.142:8000/presensi_pulang.php',
        ), // Ubah endpoint API menjadi presensi pulang
      );
      request.fields['nama'] = _userData['nama'] ?? 'default';
      request.fields['program_studi'] = _userData['programStudi'] ?? '';
      request.fields['lokasi'] = _currentLocation;
      request.fields['aktivitas'] = _aktivitasController.text;
      request.files.add(await http.MultipartFile.fromPath('foto', imagePath));

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true) {
            print('Presensi pulang berhasil dikirim dan disimpan');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Presensi pulang berhasil disimpan"),
                ), // Ubah pesan sukses
              );
            }
          } else {
            print('Gagal mengirim presensi pulang: ${data['message']}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Gagal mengirim presensi pulang: ${data['message']}',
                  ), // Ubah pesan gagal
                ),
              );
            }
          }
        } else {
          print('Gagal mengirim presensi pulang: ${response.statusCode}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal mengirim presensi pulang, server error: ${response.statusCode}', // Ubah pesan error server
                ),
              ),
            );
          }
        }
      } catch (e) {
        print('Error mengirim presensi pulang: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim presensi pulang: $e'),
            ), // Ubah pesan error
          );
        }
      }

      if (mounted) {
        setState(() {
          _imagePath = imagePath;
          _showCamera = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil foto: $e')));
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.isEmpty) {
      return;
    }
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _initializeCameraController(_cameras[_currentCameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Presensi Pulang', // Ubah judul AppBar
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1C3B70),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _userData['nama'] ?? 'Nama Tidak Tersedia',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _userData['programStudi'] ??
                            'Program Studi Tidak Tersedia',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    _currentDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  const Icon(Icons.access_time, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('HH:mm WIB').format(DateTime.now()),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentLocation,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _aktivitasController,
                decoration: const InputDecoration(
                  hintText:
                      'Mengisi catatan aktivitas yang telah dilakukan', // Ubah hint text sesuai presensi pulang
                  border: InputBorder.none,
                ),
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                if (!_showCamera) {
                  if (_cameras.isNotEmpty) {
                    setState(() {
                      _showCamera = true;
                    });
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tidak ada kamera tersedia.'),
                        ),
                      );
                    }
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(child: Text('Scan Disini')),
              ),
            ),
            const SizedBox(height: 16),
            if (_showCamera &&
                _controller != null &&
                _controller!.value.isInitialized)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _switchCamera,
                        icon: const Icon(
                          Icons.switch_camera,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Ganti Kamera',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C3B70),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _takePicture();
                        },
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text(
                          'Ambil Foto',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C3B70),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (_imagePath != null) ...[
              const SizedBox(height: 16),
              Image.file(File(_imagePath!)),
            ],
          ],
        ),
      ),
    );
  }
}
