import 'package:flutter/material.dart';
import '../monitoring/network_page.dart';
import '../monitoring/history_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.data_usage, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Limit Kuota App",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),

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
        ],
      ),
    );
  }
}