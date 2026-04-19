import 'package:flutter/material.dart';
import 'core/services/notification_service.dart';
import 'features/home/ui/home_page.dart';
// ignore: unused_import
import 'features/home/ui/sidebar.dart';
import 'package:provider/provider.dart';
import 'core/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init(); // 🔥 WAJIB

  // 🔥 TAMBAHAN
  final profileProvider = ProfileProvider();
  await profileProvider.loadProfile(); // load data tersimpan

  runApp(
    ChangeNotifierProvider(
      create: (_) => profileProvider,
      child: const MyApp(),
    ),
  );
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