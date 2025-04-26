import 'package:flutter/material.dart';
import 'kelola_profil_detail.dart';

class KelolaProfilePage extends StatelessWidget {
  final Function(dynamic profileData) onProfileUpdated;
  final String role; // Tambahkan parameter role

  const KelolaProfilePage({
    super.key,
    required this.onProfileUpdated,
    required this.role, // Tambahkan role disini
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kembali', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3B70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          _ProfileItem(
            icon: Icons.person_outline,
            title: 'Kelola Profil',
            route: '/kelola-profil-detail',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => KelolaProfilDetail(
                        onProfileUpdated: onProfileUpdated,
                        role: role,
                      ),
                ),
              );
            },
          ),
          _ProfileItem(
            icon: Icons.visibility_outlined,
            title: 'Ubah Kata Sandi',
            route: '/ubah-kata-sandi',
            onTap: () {
              Navigator.pushNamed(context, '/ubah-kata-sandi');
            },
          ),
          _ProfileItem(
            icon: Icons.home_outlined,
            title: 'Tentang',
            route: '/tentang',
            onTap: () {
              Navigator.pushNamed(context, '/tentang');
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
