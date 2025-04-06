import 'package:flutter/material.dart';
import 'package:krishi/data/sensor_data.dart';
import 'package:krishi/screens/about_screen.dart';

class FarmDetailScreen extends StatelessWidget {
  final String fieldName;
  final String assetPath;

  const FarmDetailScreen({
    super.key,
    required this.fieldName,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    SensorData? cropData = sensorDataList.firstWhere(
      (crop) => crop.name == fieldName,
      orElse: () => SensorData(
        name: fieldName,
        assetPath: assetPath,
        temperature: 0.0,
        ph: 0.0,
        salinity: 0.0,
        moisture: 0.0,
        nutrients: {},
        wateringAdvice: "No data available",
        fertilizerAdvice: "No data available",
        diseaseWarning: "No data available",
        diseaseCause: "No data available",
        preventiveMeasure: "No data available",
        lastUpdated: 0.0,
      ),
    );
    String formatTimeDifference(int seconds) {
      Duration difference = Duration(seconds: seconds);

      if (difference.inDays > 30) {
        int months =
            difference.inDays ~/ 30; // Integer division to get whole months
        return "Last Updated: $months months ago";
      } else if (difference.inDays > 0) {
        return "Last Updated: ${difference.inDays} days ago";
      } else if (difference.inHours > 0) {
        return "Last Updated: ${difference.inHours} hours ago";
      } else if (difference.inMinutes > 0) {
        return "Last Updated: ${difference.inMinutes} minutes ago";
      } else {
        return "Last Updated: ${difference.inSeconds} seconds ago";
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              "KRISHI",
              style: TextStyle(
                fontFamily: 'krishi-font',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Image.asset(
                "assets/krishi_logo.png",
                width: 30, // Adjust the size as needed
                height: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(assetPath),
                    onBackgroundImageError: (_, __) => const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cropData.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Last Updated: ${formatTimeDifference(cropData.lastUpdated.toInt())}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Temperature, pH, Salinity, and Moisture Card
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard("Temperature", "${cropData.temperature}°C",
                            "Optimal"),
                        _infoCard("pH", "${cropData.ph}",
                            "Neutral - Good for Growth"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard("Salinity", "${cropData.salinity}",
                            "Slightly Saline"),
                        _infoCard("Moisture", "${cropData.moisture}%",
                            "Slightly Dry, Needs Watering"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Nutrient Levels",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[400]!), // Add table border
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Nutrient',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Values',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                            TableCell(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)))),
                          ],
                        ),
                        ...cropData.nutrients.keys.map<TableRow>((key) {
                          var nutrient = cropData.nutrients[key];
                          return TableRow(
                            children: [
                              TableCell(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(key))),
                              TableCell(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          Text("${nutrient['value']} mg/kg"))),
                              TableCell(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: _statusIndicator(
                                              nutrient['status'])))),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Watering & Fertilizer Advice Card
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Watering Instructions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("💧 Watering Advice: ${cropData.wateringAdvice}"),
                    const SizedBox(height: 10),
                    const Text(
                      "Fertilizer Advice",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("🌱 Fertilizer Advice: ${cropData.fertilizerAdvice}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Preventive Disease Warnings Card
            ...[
              Card(
                elevation: cropData.diseaseWarning == "Blight Risk: HIGH"
                    ? 5
                    : cropData.diseaseWarning == "Blight Risk: MEDIUM"
                        ? 4
                        : 1,
                shadowColor: cropData.diseaseWarning == "Blight Risk: HIGH"
                    ? Colors.red
                    : cropData.diseaseWarning == "Blight Risk: MEDIUM"
                        ? Colors.orange
                        : Colors.green,
                shape: RoundedRectangleBorder(
                    side: cropData.diseaseWarning == "Blight Risk: HIGH"
                        ? const BorderSide(color: Colors.red, width: 1.5)
                        : cropData.diseaseWarning == "Blight Risk: MEDIUM"
                            ? const BorderSide(color: Colors.orange, width: 1.5)
                            : const BorderSide(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Preventive Disease Warnings",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${cropData.diseaseWarning == "Blight Risk: HIGH" ? "🚨" : cropData.diseaseWarning == "Blight Risk: MEDIUM" ? "⚠️" : "👍"} ⚠️ ${cropData.diseaseWarning}",
                        style: cropData.diseaseWarning == "Blight Risk: HIGH"
                            ? const TextStyle(color: Colors.red)
                            : cropData.diseaseWarning == "Blight Risk: MEDIUM"
                                ? const TextStyle(color: Colors.orange)
                                : const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 5),
                      Text("🌡️ Cause: ${cropData.diseaseCause}"),
                      Text(
                          "🛡️ Preventive Measure: ${cropData.preventiveMeasure}"),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, String subtitle) {
    return Expanded(
      child: SizedBox(
        height: 120,
        child: Card(
          color: Colors.blue.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "low":
        color = Colors.orange;
        break;
      case "optimal":
        color = Colors.green;
        break;
      case "very low":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 12),
        const SizedBox(width: 4),
        Text(status),
      ],
    );
  }
}