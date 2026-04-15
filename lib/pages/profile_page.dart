import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      backgroundColor: Colors.grey[100],

      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 FOTO PROFIL
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/profile.jpg.jpeg"), 
                // kalau belum ada gambar, bisa pakai:
                // child: Icon(Icons.person, size: 50),
              ),

              const SizedBox(height: 15),

              // DATA PROFIL
              _buildField("Nama Lengkap", "Julita"),
              _buildField("Email", "julitajulita715@gmail.com"),
              _buildField("Password", "12345678"),
              _buildField("Status", "Aktif"),

              const SizedBox(height: 15),

              // 🔥 BUTTON EDIT
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // nanti bisa diarahkan ke edit profile
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profil"),
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔧 WIDGET FIELD
  Widget _buildField(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}