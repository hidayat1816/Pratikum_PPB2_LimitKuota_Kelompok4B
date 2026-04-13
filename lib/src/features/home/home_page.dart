import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../pages/limit_setting_page.dart';
import '../monitoring/network_page.dart';
import '../monitoring/history_page.dart';
import 'sidebar.dart';

// 🔥 TAMBAHAN DATABASE
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/data/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await DatabaseHelper.instance.getAllData();
    setState(() {
      data = result;
    });
  }

  // 🔵 WIFI
  List<FlSpot> getWifiData() {
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      int wifi = data[i]['wifi'] ?? 0;
      double mb = wifi / (1024 * 1024);
      spots.add(FlSpot(i.toDouble(), mb));
    }

    return spots;
  }

  // 🟢 MOBILE
  List<FlSpot> getMobileData() {
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      int mobile = data[i]['mobile'] ?? 0;
      double mb = mobile / (1024 * 1024);
      spots.add(FlSpot(i.toDouble(), mb));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),

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
                  builder: (_) => LimitSettingPage(),
                ),
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: data.isEmpty
            ? const Center(child: Text("Belum ada data"))
            : Column(
                children: [
                  // 🔥 GRAFIK PINDAH KE HOME
                  SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),

                        lineBarsData: [
                          // 🔵 WIFI
                          LineChartBarData(
                            spots: getWifiData(),
                            isCurved: true,
                            barWidth: 3,
                            color: Colors.blue,
                            dotData: FlDotData(show: true),
                          ),

                          // 🟢 MOBILE
                          LineChartBarData(
                            spots: getMobileData(),
                            isCurved: true,
                            barWidth: 3,
                            color: Colors.green,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

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

                  // CARD KUOTA
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.data_usage, size: 40),
                      title: const Text("Total Pemakaian"),
                      subtitle: Text(
                        "${_getTotalMB().toStringAsFixed(2)} MB",
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    elevation: 4,
                    child: const ListTile(
                      leading: Icon(Icons.network_check, size: 40),
                      title: Text("Status Internet"),
                      subtitle: Text("Aktif"),
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Network()),
                      );
                    },
                    child: const Text("Monitoring Network"),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryPage()),
                      );
                    },
                    child: const Text("History Pemakaian"),
                  ),
                ],
              ),
      ),
    );
  }

  double _getTotalMB() {
    double total = 0;

    for (var item in data) {
      total += ((item['wifi'] ?? 0) + (item['mobile'] ?? 0)) /
          (1024 * 1024);
    }

    return total;
  }
}