import 'package:flutter/material.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Unduh Template',
          style: TextStyle(
            color: Colors.white,
          ), // Ubah warna teks menjadi putih
        ),
        backgroundColor: const Color(0xFF1C3B70),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Ubah warna ikon menjadi putih
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: const <Widget>[
          _TemplateItem(title: 'Template Laporan'),
          _TemplateItem(title: 'Lembar Persetujuan'),
          _TemplateItem(title: 'Pernyataan Keaslian Laporan'),
        ],
      ),
    );
  }
}

class _TemplateItem extends StatelessWidget {
  final String title;

  const _TemplateItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C3B70),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: Colors.white, // Ikon unduh berwarna putih
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
