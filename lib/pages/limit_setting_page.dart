import 'package:flutter/material.dart';

class LimitSettingPage extends StatefulWidget {
  const LimitSettingPage({super.key});

  @override
  State<LimitSettingPage> createState() => _LimitSettingPageState();
}

class _LimitSettingPageState extends State<LimitSettingPage> {
  double limitGB = 10;

  void _editLimit() {
    TextEditingController controller =
        TextEditingController(text: limitGB.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Atur Limit Kuota"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Masukkan GB",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                limitGB = double.tryParse(controller.text) ?? limitGB;
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Kuota"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),

            // 🔥 PENGATURAN KUOTA SAJA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _settingCard(
                    icon: Icons.data_usage,
                    title: "Limit Kuota",
                    value: "$limitGB GB",
                    onTap: _editLimit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 CARD SETTING
  Widget _settingCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }
}