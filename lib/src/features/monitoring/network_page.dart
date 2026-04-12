import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/data/database_helper.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/services/intent_helper.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/features/monitoring/history_page.dart';
import '../../../services/limit_service.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/services/notification_service.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  static const platform = MethodChannel('limit_kuota/channel');

  String wifiUsage = "0.00 MB";
  String mobileUsage = "0.00 MB";

  Future<void> fetchUsage() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod(
        'getTodayUsage',
      );

      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      int wifiBytes = result['wifi'] ?? 0;
      int mobileBytes = result['mobile'] ?? 0;

      await DatabaseHelper.instance.insertOrUpdate(
        todayDate,
        wifiBytes,
        mobileBytes,
      );

      setState(() {
        wifiUsage = _formatBytes(wifiBytes);
        mobileUsage = _formatBytes(mobileBytes);
      });

      // 🔥 SUDAH PAKAI AWAIT
      await checkLimitAndWarn(wifiBytes + mobileBytes);

    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        _showPermissionDialog();
      }
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0.00 MB";
    double mb = bytes / (1024 * 1024);
    if (mb > 1024) {
      return "${(mb / 1024).toStringAsFixed(2)} GB";
    }
    return "${mb.toStringAsFixed(2)} MB";
  }

  // 🔥 UPDATED: ADA NOTIFIKASI
  Future<void> checkLimitAndWarn(int currentUsage) async {
    int limitInBytes = await LimitService.getLimit();

    double percent = currentUsage / limitInBytes;

    // 🔔 80% WARNING
    if (percent >= 0.8 && percent < 1.0) {
      await NotificationService.showNotification(
        "Peringatan Kuota",
        "Pemakaian sudah mencapai ${(percent * 100).toStringAsFixed(0)}%",
      );
    }

    // 🚨 100% HABIS
    if (currentUsage >= limitInBytes) {
      await NotificationService.showNotification(
        "Kuota Habis!",
        "Penggunaan data sudah mencapai batas!",
      );

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Batas Kuota Tercapai!"),
          content: const Text(
            "Penggunaan data Anda sudah mencapai limit.\n"
            "Silakan aktifkan Set Data Limit di pengaturan.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Nanti"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                IntentHelper.openDataLimitSettings();
              },
              child: const Text("Buka Pengaturan"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Limit Kuota"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.network_check, color: Colors.white, size: 60),
                const SizedBox(height: 10),
                const Text(
                  "Monitoring Penggunaan Data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _usageCard("WiFi Today", wifiUsage, Icons.wifi, Colors.blue),

          const SizedBox(height: 15),

          _usageCard(
            "Mobile Today",
            mobileUsage,
            Icons.signal_cellular_alt,
            Colors.green,
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: fetchUsage,
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh Data"),
          ),
        ],
      ),
    );
  }

  Widget _usageCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            // ignore: deprecated_member_use
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Izin Diperlukan"),
        content: const Text("Aktifkan akses penggunaan."),
      ),
    );
  }
}