import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/data/database_helper.dart';
import '../../../core/services/notification_service.dart';
import '../widgets/usage_card.dart';
import '../widgets/info_card.dart';
import 'sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double wifiMB = 0;
  double mobileMB = 0;

  bool isDarkMode = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();

    if (!mounted) return;

    if (data.isNotEmpty) {
      final today = data.last;

      double wifi = (today['wifi'] ?? 0) / (1024 * 1024);
      double mobile = (today['mobile'] ?? 0) / (1024 * 1024);

      double total = wifi + mobile;
      double limitMB = 3000;

      NotificationService.checkUsage(
        usedMB: total,
        limitMB: limitMB,
        context: context,
      );

      setState(() {
        wifiMB = wifi;
        mobileMB = mobile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = wifiMB + mobileMB;
    final limitMB = 10240;

    final percent = total / limitMB;
    final usageColor = _getUsageColor(percent);

    double sisa = limitMB - total;
    if (sisa < 0) sisa = 0;

    final sisaGB = (sisa / 1024).toStringAsFixed(2);

    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],

      appBar: AppBar(
        title: const Text("Limit Kuota"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 USAGE CARD (SUDAH DIPISAH)
            UsageCard(
              wifiMB: wifiMB,
              mobileMB: mobileMB,
              total: total,
              percent: percent,
              usageColor: usageColor,
            ),

            // 🔥 LEGEND
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.circle, color: Colors.blue, size: 10),
                const SizedBox(width: 5),
                Text(
                  "WiFi",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.circle, color: Colors.green, size: 10),
                const SizedBox(width: 5),
                Text(
                  "Mobile",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔥 INFO CARD (SUDAH DIPISAH)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  InfoCard(
                    icon: Icons.data_usage,
                    title: "Total Pemakaian",
                    value: "${total.toStringAsFixed(2)} MB",
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),

                  InfoCard(
                    icon: Icons.network_check,
                    title: "Status Internet",
                    value: "Aktif",
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),

                  InfoCard(
                    icon: Icons.warning,
                    title: "Limit Kuota",
                    value: "10 GB",
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 10),

                  InfoCard(
                    icon: Icons.signal_cellular_alt,
                    title: "Sisa Kuota",
                    value: "$sisaGB GB",
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getUsageColor(double percent) {
    if (percent >= 1.0) return Colors.red;
    if (percent >= 0.8) return Colors.orange;
    return Colors.green;
  }
}
