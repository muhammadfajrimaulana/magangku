import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _namaPerusahaanController =
      TextEditingController();
  final TextEditingController _namaPimpinanController = TextEditingController();
  final TextEditingController _noTeleponController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaPerusahaanController.text = prefs.getString('namaPerusahaan') ?? '';
      _namaPimpinanController.text = prefs.getString('namaPimpinan') ?? '';
      _noTeleponController.text = prefs.getString('noTelepon') ?? '';
      _alamatController.text = prefs.getString('alamat') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('namaPerusahaan', _namaPerusahaanController.text);
    prefs.setString('namaPimpinan', _namaPimpinanController.text);
    prefs.setString('noTelepon', _noTeleponController.text);
    prefs.setString('alamat', _alamatController.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pengaturan disimpan!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Silahkan Lengkapi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Mohon isi informasi yang dibutuhkan.'),
            const SizedBox(height: 24),
            _buildTextField(
              'Nama Perusahaan',
              'nama perusahaan',
              _namaPerusahaanController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Nama Pimpinan',
              'nama pimpinan',
              _namaPimpinanController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'No Telepon',
              'nomor telepon',
              _noTeleponController,
            ),
            const SizedBox(height: 16),
            _buildTextField('Alamat', 'masukan alamat', _alamatController),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C3B70),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    String hintText,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(labelText),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
