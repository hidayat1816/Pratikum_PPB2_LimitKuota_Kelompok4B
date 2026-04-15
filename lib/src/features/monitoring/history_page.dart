import 'package:flutter/material.dart';
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
      data = result.reversed.toList(); // 🔥 terbaru di atas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(title: const Text("History Pemakaian"), centerTitle: true),

      body: data.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Riwayat Pemakaian Data",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      double wifi = (item['wifi'] ?? 0) / (1024 * 1024);
                      double mobile = (item['mobile'] ?? 0) / (1024 * 1024);

                      double total = wifi + mobile;

                      // 🔥 WARNA DINAMIS
                      Color color;
                      if (total > 1000) {
                        color = Colors.red;
                      } else if (total > 500) {
                        color = Colors.orange;
                      } else {
                        color = Colors.green;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(16),
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
                            // 🔥 ICON
                            CircleAvatar(
                              backgroundColor: color.withOpacity(0.2),
                              child: Icon(Icons.bar_chart, color: color),
                            ),

                            const SizedBox(width: 15),

                            // 🔥 INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['date'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text("WiFi: ${wifi.toStringAsFixed(1)} MB"),
                                  Text(
                                    "Mobile: ${mobile.toStringAsFixed(1)} MB",
                                  ),
                                ],
                              ),
                            ),

                            // 🔥 TOTAL
                            Text(
                              "${total.toStringAsFixed(1)} MB",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
