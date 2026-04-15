import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_intent_plus/android_intent.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 🔧 INIT NOTIFICATION + HANDLE CLICK
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == "open_settings") {
          openDataSettings();
        }
      },
    );
  }

  /// 🔔 SHOW NOTIFICATION
  static Future<void> showNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'limit_channel',
      'Limit Kuota',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// 📊 CEK PENGGUNAAN (INTI LOGIC)
  static void checkUsage({
    required double usedMB,
    required double limitMB,
    required BuildContext context,
  }) {
    double percent = usedMB / limitMB;

    if (percent >= 1.0) {
      // 🔴 KUOTA HABIS
      showNotification(
        "Kuota Habis!",
        "Penggunaan data kamu sudah melebihi batas.",
        payload: "open_settings",
      );

      showLimitDialog(context, percent);
    } else if (percent >= 0.8) {
      // 🟠 WARNING
      showNotification(
        "Kuota Hampir Habis",
        "Kamu sudah menggunakan 80% kuota.",
      );
    }
  }

  /// ⚠️ POPUP WARNING (SOFT CONTROL)
  static void showLimitDialog(BuildContext context, double percent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Peringatan Kuota"),
        content: Text(getRecommendation(percent)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Nanti"),
          ),
          ElevatedButton(
            onPressed: () {
              openDataSettings();
            },
            child: const Text("Buka Pengaturan"),
          ),
        ],
      ),
    );
  }

  /// 💡 REKOMENDASI PINTAR
  static String getRecommendation(double percent) {
    if (percent >= 1.0) {
      return "Kuota sudah habis.\n\n"
          "Segera matikan data seluler untuk menghindari biaya tambahan.\n"
          "Atau aktifkan mode hemat data di pengaturan.";
    } else if (percent >= 0.8) {
      return "Kuota hampir habis.\n\n"
          "Disarankan:\n"
          "- Aktifkan Data Saver\n"
          "- Batasi penggunaan aplikasi background\n"
          "- Gunakan WiFi jika tersedia";
    } else {
      return "Penggunaan masih aman.";
    }
  }

  /// ⚙️ BUKA PENGATURAN DATA ANDROID
  static void openDataSettings() {
    final intent = AndroidIntent(
      action: 'android.settings.DATA_USAGE_SETTINGS',
    );
    intent.launch();
  }
}