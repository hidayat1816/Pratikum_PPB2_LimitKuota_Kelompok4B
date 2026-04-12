import 'package:shared_preferences/shared_preferences.dart';

class LimitService {
  static const String keyLimit = 'data_limit';

  // Simpan limit (dalam bytes)
  static Future<void> saveLimit(int bytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyLimit, bytes);
  }

  // Ambil limit
  static Future<int> getLimit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyLimit) ?? (10 * 1024 * 1024 * 1024); // default 10GB
  }
}