import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UsageCard extends StatelessWidget {
  final double wifiMB;
  final double mobileMB;
  final double total;
  final double percent;
  final Color usageColor;

  const UsageCard({
    super.key,
    required this.wifiMB,
    required this.mobileMB,
    required this.total,
    required this.percent,
    required this.usageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}