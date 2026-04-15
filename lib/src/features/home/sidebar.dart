import 'package:flutter/material.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/pages/profile_page.dart';
import '../monitoring/network_page.dart';
import '../monitoring/history_page.dart';
import '../../../pages/limit_setting_page.dart';
// ignore: duplicate_import
import '../../../pages/profile_page.dart'; // 

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // 🔥 HEADER PROFILE
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.blue],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  "User",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text("user@email.com",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 MENU PROFIL (BARU)
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),

          // 🔥 MENU LAINNYA
          ListTile(
            leading: const Icon(Icons.network_check),
            title: const Text("Monitoring"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Network()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("History"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          ),

          const Divider(),

          // 🔥 SETTINGS
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Pengaturan Kuota"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LimitSettingPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}