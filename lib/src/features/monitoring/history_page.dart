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
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Pemakaian")),
      body: data.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Riwayat Pemakaian Data",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            title: Text(item['date'] ?? '-'),
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