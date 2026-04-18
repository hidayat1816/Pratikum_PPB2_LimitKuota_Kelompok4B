import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UsageCard extends StatelessWidget {
  final double wifiMB;
  final double mobileMB;
  final double total;
  final double percent;
  final Color usageColor;
  final bool isDarkMode; // 🔥 TAMBAHAN

  const UsageCard({
    super.key,
    required this.wifiMB,
    required this.mobileMB,
    required this.total,
    required this.percent,
    required this.usageColor,
    required this.isDarkMode, // 🔥 TAMBAHAN
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),

      // 🔥 GRADIENT + SHADOW (UPGRADE)
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF2F80ED)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          const Text(
            "Pemakaian Hari Ini",
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 15),

          // 🔥 PIE CHART
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    value: wifiMB,
                    color: Colors.blue,
                    radius: 45,
                    title: wifiMB.toStringAsFixed(0),
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  PieChartSectionData(
                    value: mobileMB,
                    color: Colors.green,
                    radius: 45,
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

          const SizedBox(height: 12),

          // 🔥 ANGKA BESAR (DITINGKATKAN)
          Text(
            "${total.toStringAsFixed(1)} MB",
            style: TextStyle(
              color: usageColor,
              fontSize: 26, // 🔥 LEBIH BESAR
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // 🔥 PROGRESS BAR LEBIH HALUS
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(usageColor),
            ),
          ),

          const SizedBox(height: 8),

          // 🔥 PERSENTASE + STATUS
          Text(
            "${(percent * 100).toStringAsFixed(1)}% digunakan",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 6),

          Text(
            percent >= 1
                ? "Kuota Habis"
                : percent >= 0.8
                    ? "Hampir Habis"
                    : "Aman",
            style: TextStyle(
              color: usageColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}