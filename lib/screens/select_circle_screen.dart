import 'package:flutter/material.dart';
import 'package:krishi/data/list.dart';
import 'package:krishi/data/user_selected_circle.dart';
import 'package:krishi/models/circle_data.dart';

class SelectCircleScreen extends StatelessWidget {
  const SelectCircleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<CircleData> filteredCircles = availableCircles
        .where((circle) => !userSelectedCircles
            .any((selectedCircle) => selectedCircle.name == circle.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Crop"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: filteredCircles.isEmpty
          ? const Center(
              child: Text(
                "No more crops to select!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredCircles.length,
              itemBuilder: (context, index) => Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      filteredCircles[index].imageUrl,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  title: Text(
                    filteredCircles[index].name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context, filteredCircles[index]);
                  },
                ),
              ),
            ),
    );
  }
}