import 'package:flutter/material.dart';
import '../services/limit_service.dart';

class LimitSettingPage extends StatefulWidget {
  @override
  _LimitSettingPageState createState() => _LimitSettingPageState();
}

class _LimitSettingPageState extends State<LimitSettingPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLimit();
  }

  void loadLimit() async {
    int limit = await LimitService.getLimit();
    setState(() {
      controller.text = (limit / (1024 * 1024 * 1024)).toStringAsFixed(0);
    });
  }

  void saveLimit() async {
    int gb = int.tryParse(controller.text) ?? 0;
    int bytes = gb * 1024 * 1024 * 1024;

    await LimitService.saveLimit(bytes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Limit berhasil disimpan")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Atur Limit Kuota")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Masukkan batas kuota (GB):"),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Contoh: 10"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveLimit,
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}