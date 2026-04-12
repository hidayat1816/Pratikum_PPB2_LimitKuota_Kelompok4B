import 'package:flutter/material.dart';
import '../../../pages/limit_setting_page.dart';
import '../monitoring/network_page.dart';
import '../monitoring/history_page.dart';
import 'sidebar.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),

      // 🔥 APPBAR DENGAN TOMBOL SETTINGS
      appBar: AppBar(
        title: const Text("Limit Kuota"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LimitSettingPage(),
                ),
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD KUOTA
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.data_usage, size: 40),
                title: const Text("Kuota Tersisa"),
                subtitle: const Text("8 GB"),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.network_check, size: 40),
                title: const Text("Status Internet"),
                subtitle: const Text("Aktif"),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Network()),
                );
              },
              child: const Text("Monitoring Network"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              child: const Text("History Pemakaian"),
            ),
          ],
        ),
      ),
    );
  }
}