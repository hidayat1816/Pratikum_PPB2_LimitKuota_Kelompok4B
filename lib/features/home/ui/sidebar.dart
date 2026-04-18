import 'package:flutter/material.dart';
import '../../limit/limit_setting_page.dart';
import '../../monitoring/history_page.dart';
import '../../monitoring/network_page.dart';
import '../../profile/profile_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _navigate(BuildContext context, Widget page) {
    Navigator.pop(context); // 🔥 tutup drawer dulu
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text("user@email.com", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 MENU PROFIL
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            onTap: () => _navigate(context, const ProfilePage()),
          ),

          // 🔥 MONITORING
          ListTile(
            leading: const Icon(Icons.network_check),
            title: const Text("Monitoring"),
            onTap: () => _navigate(context, const Network()),
          ),

          // 🔥 HISTORY
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("History"),
            onTap: () => _navigate(context, const HistoryPage()),
          ),

          const Divider(),

          // 🔥 SETTINGS
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Pengaturan Kuota"),
            onTap: () => _navigate(context, const LimitSettingPage()),
          ),
        ],
      ),
    );
  }
}
