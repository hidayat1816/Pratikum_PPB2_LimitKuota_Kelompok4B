import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sidebar.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/data/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double wifiMB = 0;
  double mobileMB = 0;

  @override
  void initState() {
    super.initState();
    loadTodayData();
  }

  Future<void> loadTodayData() async {
    final data = await DatabaseHelper.instance.getAllData();

    if (data.isNotEmpty) {
      final today = data.last;

      setState(() {
        wifiMB = (today['wifi'] ?? 0) / (1024 * 1024);
        mobileMB = (today['mobile'] ?? 0) / (1024 * 1024);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = wifiMB + mobileMB;

    // LIMIT KUOTA (sementara 10GB)
    double limitMB = 10240;

    // HITUNG SISA
    double sisa = limitMB - total;
    if (sisa < 0) sisa = 0;

    // KONVERSI KE GB
    String sisaGB = (sisa / 1024).toStringAsFixed(2);

    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Limit Kuota"),
        centerTitle: true,
        elevation: 0,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 LEGEND
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.circle, color: Colors.blue, size: 10),
                SizedBox(width: 5),
                Text("WiFi"),
                SizedBox(width: 20),
                Icon(Icons.circle, color: Colors.green, size: 10),
                SizedBox(width: 5),
                Text("Mobile"),
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

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
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
              Text(title),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}