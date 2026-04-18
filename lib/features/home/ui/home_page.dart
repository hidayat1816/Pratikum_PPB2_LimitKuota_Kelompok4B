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

      final wifi = (today['wifi'] ?? 0) / (1024 * 1024);
      final mobile = (today['mobile'] ?? 0) / (1024 * 1024);

      final total = wifi + mobile;
      const double limitMB = 3000;

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
    const limitMB = 10240;

    final percent = total / limitMB;
    final usageColor = _getUsageColor(percent);

    double sisa = limitMB - total;
    if (sisa < 0) sisa = 0;

    final sisaGB = (sisa / 1024).toStringAsFixed(2);

    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: isDarkMode
          ? const Color(0xFF0F1115)
          : const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Limit Kuota"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color(0xFF0F1115)
            : const Color(0xFFF5F7FB),
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔥 HEADER (NEW)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo 👋",
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pantau Kuotamu Hari Ini",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(percent: percent),
                ],
              ),
            ),

            // 🔥 USAGE CARD (UPGRADED)
            UsageCard(
              wifiMB: wifiMB,
              mobileMB: mobileMB,
              total: total,
              percent: percent,
              usageColor: usageColor,
              isDarkMode: isDarkMode,
            ),

            // 🔥 LEGEND
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(
                    color: Colors.blue,
                    label: "WiFi",
                    isDark: isDarkMode,
                  ),
                  const SizedBox(width: 16),
                  _LegendDot(
                    color: Colors.green,
                    label: "Mobile",
                    isDark: isDarkMode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 INFO CARDS
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

// 🔥 STATUS CHIP
class _StatusChip extends StatelessWidget {
  final double percent;
  const _StatusChip({required this.percent});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (percent >= 1) {
      text = "Habis";
      color = Colors.red;
    } else if (percent >= 0.8) {
      text = "Hampir Habis";
      color = Colors.orange;
    } else {
      text = "Aman";
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// 🔥 LEGEND
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
