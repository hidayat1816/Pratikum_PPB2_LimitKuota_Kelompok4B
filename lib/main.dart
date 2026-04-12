import 'package:flutter/material.dart';
import 'src/core/services/notification_service.dart';
import 'src/features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init(); // 🔥 WAJIB

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Limit Kuota',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
