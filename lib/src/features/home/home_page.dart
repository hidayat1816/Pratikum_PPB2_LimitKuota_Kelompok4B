import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:praktikum_ppb2_limitkuota_kelompok4b/src/core/data/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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

  // 🔵 WIFI DATA
  List<FlSpot> getWifiData() {
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      int wifi = data[i]['wifi'] ?? 0;
      double mb = wifi / (1024 * 1024);
      spots.add(FlSpot(i.toDouble(), mb));
    }

    return spots;
  }

  // 🟢 MOBILE DATA
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
      appBar: AppBar(title: const Text("History & Grafik")),
      body: data.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Grafik Pemakaian Data",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 GRAFIK 2 GARIS
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

                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];

                        double totalMB =
                            ((item['wifi'] ?? 0) +
                                (item['mobile'] ?? 0)) /
                            (1024 * 1024);

                        return Card(
                          child: ListTile(
                            title: Text(item['date']),
                            subtitle: Text(
                              "${totalMB.toStringAsFixed(2)} MB",
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}