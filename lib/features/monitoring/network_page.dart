import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/core/services/limit_service.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/features/monitoring/history_page.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/core/data/database_helper.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/core/services/intent_helper.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/core/services/notification_service.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();

  static const platform = MethodChannel('limit_kuota/channel');

  static Future<Map<String, int>> getUsage() async {
    final Map<dynamic, dynamic> result =
        await platform.invokeMethod('getTodayUsage');

    int wifiBytes = result['wifi'] ?? 0;
    int mobileBytes = result['mobile'] ?? 0;

    return {
      "wifi": wifiBytes,
      "mobile": mobileBytes,
    };
  }
}

class _NetworkState extends State<Network> {
  String wifiUsage = "0.00 MB";
  String mobileUsage = "0.00 MB";

  Future<void> fetchUsage() async {
    try {
      final usage = await Network.getUsage();

      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      int wifiBytes = usage['wifi']!;
      int mobileBytes = usage['mobile']!;

      await DatabaseHelper.instance.insertOrUpdate(
        todayDate,
        wifiBytes,
        mobileBytes,
      );

      setState(() {
        wifiUsage = _formatBytes(wifiBytes);
        mobileUsage = _formatBytes(mobileBytes);
      });

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

  Future<void> checkLimitAndWarn(int currentUsage) async {
    int limitInBytes = await LimitService.getLimit();

    double percent = currentUsage / limitInBytes;

    if (percent >= 0.8 && percent < 1.0) {
      await NotificationService.showNotification(
        "Peringatan Kuota",
        "Pemakaian sudah mencapai ${(percent * 100).toStringAsFixed(0)}%",
      );
    }

    if (currentUsage >= limitInBytes) {
      await NotificationService.showNotification(
        "Kuota Habis!",
        "Penggunaan data sudah mencapai batas!",
      );

      showDialog(
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

      // 🔥 APPBAR FIX
      appBar: AppBar(
        title: const Text(
          "Limit Kuota",
          style: TextStyle(color: Colors.white), // 🔥 teks putih
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // 🔥 tetap ungu
        iconTheme: const IconThemeData(color: Colors.white), // 🔥 icon jadi putih juga
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Colors.blue,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.network_check,
                      color: Colors.white, size: 60),
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

            _usageCard(
              "WiFi Today",
              wifiUsage,
              Icons.wifi,
              Colors.deepPurple,
            ),

            const SizedBox(height: 15),

            _usageCard(
              "Mobile Today",
              mobileUsage,
              Icons.signal_cellular_alt,
              Colors.blue,
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                elevation: 4,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: fetchUsage,
              icon: const Icon(Icons.refresh),
              label: const Text(
                "Refresh Data",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
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
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Izin Diperlukan"),
        content: Text("Aktifkan akses penggunaan."),
      ),
    );
  }
}