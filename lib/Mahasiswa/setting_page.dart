import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _alarmMasukEnabled = true;
  bool _alarmPulangEnabled = true;
  TimeOfDay _alarmMasukTime = const TimeOfDay(hour: 7, minute: 30);
  TimeOfDay _alarmPulangTime = const TimeOfDay(hour: 16, minute: 0);

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
      _alarmMasukTime = TimeOfDay(
        hour: prefs.getInt('alarmMasukHour') ?? 7,
        minute: prefs.getInt('alarmMasukMinute') ?? 30,
      );
      _alarmPulangTime = TimeOfDay(
        hour: prefs.getInt('alarmPulangHour') ?? 16,
        minute: prefs.getInt('alarmPulangMinute') ?? 0,
      );
      _alarmMasukEnabled = prefs.getBool('alarmMasukEnabled') ?? true;
      _alarmPulangEnabled = prefs.getBool('alarmPulangEnabled') ?? true;

      _namaPerusahaanController.text = prefs.getString('namaPerusahaan') ?? '';
      _namaPimpinanController.text = prefs.getString('namaPimpinan') ?? '';
      _noTeleponController.text = prefs.getString('noTelepon') ?? '';
      _alamatController.text = prefs.getString('alamat') ?? '';
    });
  }

  Future<void> _selectTime(BuildContext context, bool isMasuk) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMasuk ? _alarmMasukTime : _alarmPulangTime,
    );
    if (picked != null) {
      setState(() {
        if (isMasuk) {
          _alarmMasukTime = picked;
        } else {
          _alarmPulangTime = picked;
        }
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('alarmMasukHour', _alarmMasukTime.hour);
    prefs.setInt('alarmMasukMinute', _alarmMasukTime.minute);
    prefs.setInt('alarmPulangHour', _alarmPulangTime.hour);
    prefs.setInt('alarmPulangMinute', _alarmPulangTime.minute);
    prefs.setBool('alarmMasukEnabled', _alarmMasukEnabled);
    prefs.setBool('alarmPulangEnabled', _alarmPulangEnabled);

    // Menyimpan data textfield
    prefs.setString('namaPerusahaan', _namaPerusahaanController.text);
    prefs.setString('namaPimpinan', _namaPimpinanController.text);
    prefs.setString('noTelepon', _noTeleponController.text);
    prefs.setString('alamat', _alamatController.text);

    print(
      'Jam Masuk Disimpan: ${_alarmMasukTime.hour}:${_alarmMasukTime.minute}',
    );
    print(
      'Jam Pulang Disimpan: ${_alarmPulangTime.hour}:${_alarmPulangTime.minute}',
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pengaturan disimpan!')));

    // Mengirim data alarm kembali ke halaman utama
    Navigator.pop(context, {
      'alarmMasukTime': _alarmMasukTime,
      'alarmPulangTime': _alarmPulangTime,
    });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Alarm Masuk'),
                Row(
                  children: <Widget>[
                    Text(
                      DateFormat('HH:mm').format(
                        DateTime(
                          2020,
                          1,
                          1,
                          _alarmMasukTime.hour,
                          _alarmMasukTime.minute,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, true),
                    ),
                    Switch(
                      value: _alarmMasukEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _alarmMasukEnabled = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Alarm Pulang'),
                Row(
                  children: <Widget>[
                    Text(
                      DateFormat('HH:mm').format(
                        DateTime(
                          2020,
                          1,
                          1,
                          _alarmPulangTime.hour,
                          _alarmPulangTime.minute,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _selectTime(context, false),
                    ),
                    Switch(
                      value: _alarmPulangEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _alarmPulangEnabled = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
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
