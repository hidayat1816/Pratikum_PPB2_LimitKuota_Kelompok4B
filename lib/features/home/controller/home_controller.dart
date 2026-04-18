import '../../../core/data/database_helper.dart';
import '../../../core/services/notification_service.dart';

class HomeController {
  Future<Map<String, double>> loadTodayData(context) async {
    final data = await DatabaseHelper.instance.getAllData();

    if (data.isEmpty) {
      return {"wifi": 0, "mobile": 0};
    }

    final today = data.last;

    double wifi = (today['wifi'] ?? 0) / (1024 * 1024);
    double mobile = (today['mobile'] ?? 0) / (1024 * 1024);

    double total = wifi + mobile;
    double limitMB = 3000;

    NotificationService.checkUsage(
      usedMB: total,
      limitMB: limitMB,
      context: context,
    );

    return {
      "wifi": wifi,
      "mobile": mobile,
    };
  }

  double getPercent(double total, double limit) {
    return total / limit;
  }

  double getRemaining(double total, double limit) {
    double sisa = limit - total;
    return sisa < 0 ? 0 : sisa;
  }

  String formatGB(double mb) {
    return (mb / 1024).toStringAsFixed(2);
  }
}