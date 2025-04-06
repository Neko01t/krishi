import 'package:flutter/material.dart';
import 'package:krishi/models/circle_data.dart';
import 'package:krishi/data/list.dart';
import 'package:krishi/screens/maps_screen.dart';
import 'package:krishi/data/farm_size.dart';

class EmptyFieldScreen extends StatefulWidget {
  const EmptyFieldScreen({super.key});

  @override
  State<EmptyFieldScreen> createState() => _EmptyFieldScreenState();
}

class _EmptyFieldScreenState extends State<EmptyFieldScreen> {
  final TextEditingController acresController = TextEditingController();

  CircleData? selectedCrop;

  void _saveField() {
    if (selectedCrop != null) {
      Navigator.pop(context, {
        "name": selectedCrop!.name,
        "asset": selectedCrop!.imageUrl,
        "acres":
            "${acresController.text.isEmpty ? sharedarea : acresController.text} acres"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Field")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a Crop",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Crop Selection Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: availableCircles.length,
              itemBuilder: (context, index) {
                CircleData crop = availableCircles[index];
                bool isSelected = crop == selectedCrop;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCrop = crop;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          crop.imageUrl,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported,
                                  color: Colors.grey, size: 30),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          crop.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.grey, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Area: ${sharedarea.toStringAsFixed(2)} acres",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("or"),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            TextField(
              controller: acresController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Field Size (Acres)",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Save Field", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              "Open map to select the field on the map",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3)
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 16),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapsScreen()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft, // Force left alignment
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "open Map",
                            style: const TextStyle(
                              fontSize: 18, // Subtitle size
                              fontWeight: FontWeight.bold, // Bold
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}