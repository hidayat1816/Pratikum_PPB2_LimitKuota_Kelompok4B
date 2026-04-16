import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sidebar.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/data/database_helper.dart';

// 🔥 TAMBAHAN
import '../../core/services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double wifiMB = 0;
  double mobileMB = 0;

  // 🔥 DARK MODE STATE
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTodayData();

    // 🔥 AUTO REFRESH
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));
      await loadTodayData();
      return true;
    });
  }

  Future<void> loadTodayData() async {
    final data = await DatabaseHelper.instance.getAllData();

    if (data.isNotEmpty) {
      final today = data.last;

      double wifi = (today['wifi'] ?? 0) / (1024 * 1024);
      double mobile = (today['mobile'] ?? 0) / (1024 * 1024);

      double total = wifi + mobile;

      double limitMB = 3000;

      // 🔥 NOTIF
      NotificationService.checkUsage(
        usedMB: total,
        limitMB: limitMB,
        // ignore: use_build_context_synchronously
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
    double total = wifiMB + mobileMB;

    double limitMB = 10240;

    double percent = total / limitMB;
    Color usageColor = getUsageColor(percent);

    double sisa = limitMB - total;
    if (sisa < 0) sisa = 0;

    String sisaGB = (sisa / 1024).toStringAsFixed(2);

    return Scaffold(
      drawer: const Sidebar(),

      // 🔥 BACKGROUND DARK MODE
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],

      appBar: AppBar(
        title: const Text("Limit Kuota"),
        centerTitle: true,
        elevation: 0,

        // 🔥 ICON DARK MODE
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 HEADER + CHART
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.blue],
                ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                children: [
                  const Text(
                    "Pemakaian Hari Ini",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: wifiMB,
                            color: Colors.blue,
                            radius: 40,
                            title: wifiMB.toStringAsFixed(0),
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          PieChartSectionData(
                            value: mobileMB,
                            color: Colors.green,
                            radius: 40,
                            title: mobileMB.toStringAsFixed(0),
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "${total.toStringAsFixed(1)} MB",
                    style: TextStyle(
                      color: usageColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: percent.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(usageColor),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "${(percent * 100).toStringAsFixed(1)}% digunakan",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
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

            // 🔥 CARD INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _infoCard(
                    icon: Icons.data_usage,
                    title: "Total Pemakaian",
                    value: "${total.toStringAsFixed(2)} MB",
                  ),
                  const SizedBox(height: 10),
                  _infoCard(
                    icon: Icons.network_check,
                    title: "Status Internet",
                    value: "Aktif",
                  ),
                  const SizedBox(height: 10),
                  _infoCard(
                    icon: Icons.warning,
                    title: "Limit Kuota",
                    value: "10 GB",
                  ),
                  const SizedBox(height: 10),
                  _infoCard(
                    icon: Icons.signal_cellular_alt,
                    title: "Sisa Kuota",
                    value: "$sisaGB GB",
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

  // 🔥 FUNCTION WARNA
  Color getUsageColor(double percent) {
    if (percent >= 1.0) return Colors.red;
    if (percent >= 0.8) return Colors.orange;
    return Colors.green;
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[900]
            : Colors.white, // 🔥 DARK MODE CARD
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.deepPurple),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
