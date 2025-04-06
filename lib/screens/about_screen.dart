import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About KRISHI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Center(
              child: Image.asset(
                "assets/krishi_logo.png",
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),

            // Credits Section
            const Text(
              "Developed By",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            _buildCreditItem("Frontend", "Om Sonawane", isBold: true),
            _buildCreditItem("Backend & Database", "Sarvesh Ghodke", isBold: true),
            _buildCreditItem("Design & Management", "Naushad Siddiqui", isBold: true),
            _buildCreditItem("APIs & Research", "Aniket Mundhe" , isBold: true),
          ],
        ),
      ),
    );
  }

  /// Helper Widget for Credit Items
  Widget _buildCreditItem(String role, String name, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            role,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: isBold ? 22 : 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
