import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KelolaProfilDetail extends StatefulWidget {
  final Function(dynamic profileData) onProfileUpdated;
  final String role;

  const KelolaProfilDetail({
    super.key,
    required this.onProfileUpdated,
    required this.role,
  });

  @override
  _KelolaProfilDetailState createState() => _KelolaProfilDetailState();
}

class _KelolaProfilDetailState extends State<KelolaProfilDetail> {
  File? _image;
  String _nama = '';
  String _programStudi = '';
  String _telepon = '';
  String _email = '';
  String _jabatan = '';
  String _nim = ''; // Tambahkan variabel NIM
  String _namaPerusahaan = ''; // Tambahkan variabel nama perusahaan
  String _alamatPerusahaan = ''; // Tambahkan variabel alamat perusahaan
  String? _fotoProfilPath;
  String? _currentlyEditing;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nama;
    String? programStudi;
    String? telepon;
    String? email;
    String? fotoProfil;
    String? jabatan;
    String? nim; // Tambahkan pengambilan NIM
    String? namaPerusahaan; // Tambahkan pengambilan nama perusahaan
    String? alamatPerusahaan; // Tambahkan pengambilan alamat perusahaan

    if (widget.role == 'admin') {
      nama = prefs.getString('namaAdmin');
      jabatan = prefs.getString('jabatanAdmin');
      fotoProfil = prefs.getString('fotoProfilAdmin');
      nim = prefs.getString('nimAdmin'); // Mungkin tidak ada untuk admin
      namaPerusahaan = prefs.getString(
        'namaPerusahaanAdmin',
      ); // Mungkin tidak ada untuk admin
      alamatPerusahaan = prefs.getString(
        'alamatPerusahaanAdmin',
      ); // Mungkin tidak ada untuk admin
      print('Ambil nama dari data admin: $nama, foto: $fotoProfil');
    } else if (widget.role == 'pembimbing') {
      nama = prefs.getString('namaPembimbing');
      fotoProfil = prefs.getString('fotoProfilPembimbing');
      nim = prefs.getString(
        'nimPembimbing',
      ); // Mungkin tidak ada untuk pembimbing
      namaPerusahaan = prefs.getString(
        'namaPerusahaanPembimbing',
      ); // Mungkin tidak ada untuk pembimbing
      alamatPerusahaan = prefs.getString(
        'alamatPerusahaanPembimbing',
      ); // Mungkin tidak ada untuk pembimbing
      print('Ambil nama dari data pembimbing: $nama, foto: $fotoProfil');
    } else if (widget.role == 'mahasiswa') {
      nama = prefs.getString('namaMahasiswa');
      programStudi = prefs.getString('programStudiMahasiswa');
      telepon = prefs.getString('teleponMahasiswa');
      email = prefs.getString('emailMahasiswa');
      fotoProfil = prefs.getString('fotoProfilMahasiswa');
      nim = prefs.getString('nimMahasiswa'); // Ambil NIM mahasiswa
      namaPerusahaan = prefs.getString(
        'namaPerusahaanMahasiswa',
      ); // Ambil nama perusahaan mahasiswa
      alamatPerusahaan = prefs.getString(
        'alamatPerusahaanMahasiswa',
      ); // Ambil alamat perusahaan mahasiswa
      print(
        'Ambil nama dari data mahasiswa: $nama, foto: $fotoProfil, NIM: $nim, Perusahaan: $namaPerusahaan, Alamat: $alamatPerusahaan',
      );
    }

    setState(() {
      _nama = nama ?? '';
      _programStudi = programStudi ?? '';
      _telepon = telepon ?? '';
      _email = email ?? '';
      _jabatan = jabatan ?? '';
      _nim = nim ?? ''; // Set nilai NIM
      _namaPerusahaan = namaPerusahaan ?? ''; // Set nilai nama perusahaan
      _alamatPerusahaan = alamatPerusahaan ?? ''; // Set nilai alamat perusahaan
      _fotoProfilPath = fotoProfil;
      _image = null; // Reset _image saat data awal dimuat
    });
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print('Gambar baru dipilih: ${_image?.path}');
      } else {
        print('Tidak ada gambar yang dipilih.');
      }
    });
  }

  Future<void> _saveProfileChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId;
    String apiUrl = 'http://192.168.64.142:8000/update_profile.php';

    if (widget.role == 'mahasiswa') {
      userId = prefs.getString('idMahasiswa');
    } else if (widget.role == 'admin') {
      userId = prefs.getString('idAdmin');
    } else if (widget.role == 'pembimbing') {
      userId = prefs.getString('idPembimbing');
    }

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ID pengguna tidak ditemukan. Logout dan login kembali.',
          ),
        ),
      );
      print('Error: ID pengguna tidak ditemukan untuk peran ${widget.role}');
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['role'] = widget.role;
    request.fields['id'] = userId;
    request.fields['nama'] = _nama;
    if (widget.role == 'mahasiswa') {
      request.fields['program_studi'] = _programStudi;
      request.fields['telepon'] = _telepon;
      request.fields['email'] = _email;
      request.fields['nim'] = _nim; // Kirim NIM
      request.fields['nama_perusahaan'] =
          _namaPerusahaan; // Kirim nama perusahaan
      request.fields['alamat_perusahaan'] =
          _alamatPerusahaan; // Kirim alamat perusahaan
    } else if (widget.role == 'admin') {
      request.fields['jabatan'] = _jabatan;
      // Mungkin tidak perlu mengirim NIM, nama perusahaan, alamat perusahaan untuk admin
    } else if (widget.role == 'pembimbing') {
      // Mungkin tidak perlu mengirim NIM, nama perusahaan, alamat perusahaan untuk pembimbing
    }

    if (_image != null) {
      print(
        'Mengirim gambar: ${_image!.path}, ukuran: ${_image!.lengthSync()} bytes',
      );
      String fileName = _image!.path.split('/').last;
      String extension = fileName.split('.').last.toLowerCase();
      print('Nama file: $fileName, ekstensi: $extension');
      if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto_profil',
              _image!.path,
              filename: fileName,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan file gambar ke permintaan: $e'),
            ),
          );
          print('Error menambahkan file gambar: $e');
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Jenis file tidak didukung. Hanya JPG dan PNG yang diizinkan.',
            ),
          ),
        );
        return;
      }
    } else {
      print('Tidak ada gambar yang diunggah.');
    }

    print('Data yang dikirim: ${request.fields}');

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Status code dari server: ${response.statusCode}');
      print('Body dari server: ${response.body}');

      if (response.statusCode == 201) {
        try {
          var data = jsonDecode(response.body);
          if (data['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Profil berhasil diperbarui untuk ${widget.role}!',
                ),
              ),
            );

            String? newFotoProfilPath = data['data']['foto_profil'];
            print('Path foto profil baru dari API: $newFotoProfilPath');

            widget.onProfileUpdated({
              'nama': _nama,
              'programStudi': _programStudi,
              'jabatan': _jabatan,
              'foto_profil': newFotoProfilPath,
              'nim': _nim, // Kirim kembali NIM ke callback
              'namaPerusahaan':
                  _namaPerusahaan, // Kirim kembali nama perusahaan
              'alamatPerusahaan':
                  _alamatPerusahaan, // Kirim kembali alamat perusahaan
            });

            // Simpan ke SharedPreferences dan update tampilan
            if (widget.role == 'mahasiswa') {
              await prefs.setString('namaMahasiswa', _nama);
              await prefs.setString('programStudiMahasiswa', _programStudi);
              await prefs.setString('teleponMahasiswa', _telepon);
              await prefs.setString('emailMahasiswa', _email);
              await prefs.setString('nimMahasiswa', _nim); // Simpan NIM
              await prefs.setString(
                'namaPerusahaanMahasiswa',
                _namaPerusahaan,
              ); // Simpan nama perusahaan
              await prefs.setString(
                'alamatPerusahaanMahasiswa',
                _alamatPerusahaan,
              ); // Simpan alamat perusahaan
              if (newFotoProfilPath != null && newFotoProfilPath.isNotEmpty) {
                await prefs.setString('fotoProfilMahasiswa', newFotoProfilPath);
                setState(() {
                  _fotoProfilPath = newFotoProfilPath;
                  _image = null;
                });
              }
            } else if (widget.role == 'admin') {
              await prefs.setString('namaAdmin', _nama);
              await prefs.setString('jabatanAdmin', _jabatan);
              // Mungkin tidak perlu menyimpan NIM, nama perusahaan, alamat perusahaan untuk admin
              if (newFotoProfilPath != null && newFotoProfilPath.isNotEmpty) {
                await prefs.setString('fotoProfilAdmin', newFotoProfilPath);
                setState(() {
                  _fotoProfilPath = newFotoProfilPath;
                  _image = null;
                });
              }
            } else if (widget.role == 'pembimbing') {
              await prefs.setString('namaPembimbing', _nama);
              // Mungkin tidak perlu menyimpan NIM, nama perusahaan, alamat perusahaan untuk pembimbing
              if (newFotoProfilPath != null && newFotoProfilPath.isNotEmpty) {
                await prefs.setString(
                  'fotoProfilPembimbing',
                  newFotoProfilPath,
                );
                setState(() {
                  _fotoProfilPath = newFotoProfilPath;
                  _image = null;
                });
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal memperbarui profil: ${data['message']}'),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memproses response server: $e')),
          );
          print('Error decoding JSON response: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memperbarui profil. Status code: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat mengirim permintaan: $e'),
        ),
      );
      print('Error sending request: $e');
    }
  }

  void _updateProfile(String newValue, {String? jabatan}) {
    setState(() {
      if (_currentlyEditing == 'Nama') {
        _nama = newValue;
      } else if (_currentlyEditing == 'Program Studi') {
        _programStudi = newValue;
      } else if (_currentlyEditing == 'Telepon') {
        _telepon = newValue;
      } else if (_currentlyEditing == 'Email') {
        _email = newValue;
      } else if (_currentlyEditing == 'Jabatan') {
        _jabatan = jabatan ?? newValue;
      } else if (_currentlyEditing == 'NIM') {
        _nim = newValue;
      } else if (_currentlyEditing == 'Nama Perusahaan') {
        _namaPerusahaan = newValue;
      } else if (_currentlyEditing == 'Alamat Perusahaan') {
        _alamatPerusahaan = newValue;
      }
    });
    // Data akan dikirim ke API saat tombol "Simpan" ditekan
  }

  void _showEditDialog(
    BuildContext context,
    String title,
    String value,
    String role, // Terima role di sini
    Function(String) onSave,
  ) {
    _currentlyEditing = title; // Set field yang sedang diedit
    final TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Profil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saveProfileChanges,
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  key: ValueKey(_fotoProfilPath),
                  radius: 50,
                  backgroundImage:
                      _image != null
                          ? FileImage(_image!)
                          : _fotoProfilPath != null &&
                              _fotoProfilPath!.isNotEmpty
                          ? NetworkImage(
                            'http://192.168.64.142:8000/' + _fotoProfilPath!,
                          )
                          : const AssetImage('assets/profiles/default.png')
                              as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: const Icon(
                        Icons.brush,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildProfileColumn('Nama', _nama, () {
              _showEditDialog(context, 'Nama', _nama, widget.role, (value) {
                _updateProfile(value);
              });
            }),
            if (widget.role == 'mahasiswa')
              _buildProfileColumn('NIM', _nim, () {
                _showEditDialog(context, 'NIM', _nim, widget.role, (value) {
                  _updateProfile(value);
                });
              }),
            if (widget.role == 'mahasiswa')
              _buildProfileColumn('Program Studi', _programStudi, () {
                _showEditDialog(
                  context,
                  'Program Studi',
                  _programStudi,
                  widget.role,
                  (value) {
                    _updateProfile(value);
                  },
                );
              }),
            if (widget.role == 'mahasiswa')
              _buildProfileColumn('Telepon', _telepon, () {
                _showEditDialog(context, 'Telepon', _telepon, widget.role, (
                  value,
                ) {
                  _updateProfile(value);
                });
              }),
            if (widget.role == 'mahasiswa')
              _buildProfileColumn('Email', _email, () {
                _showEditDialog(context, 'Email', _email, widget.role, (value) {
                  _updateProfile(value);
                });
              }),
            if (widget.role == 'mahasiswa')
              _buildProfileColumn('Nama Perusahaan', _namaPerusahaan, () {
                _showEditDialog(
                  context,
                  'Nama Perusahaan',
                  _namaPerusahaan,
                  widget.role,
                  (value) {
                    _updateProfile(value);
                  },
                );
              }),
            if (widget.role == 'mahasiswa')
              _buildProfileColumn('Alamat Perusahaan', _alamatPerusahaan, () {
                _showEditDialog(
                  context,
                  'Alamat Perusahaan',
                  _alamatPerusahaan,
                  widget.role,
                  (value) {
                    _updateProfile(value);
                  },
                );
              }),
            if (widget.role == 'admin')
              _buildProfileColumn('Jabatan', _jabatan, () {
                _showEditDialog(context, 'Jabatan', _jabatan, widget.role, (
                  value,
                ) {
                  _updateProfile(value, jabatan: value);
                });
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileColumn(String label, String value, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}
