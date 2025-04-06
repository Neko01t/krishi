import 'package:flutter/material.dart';
import 'package:krishi/screens/empty_field_screen.dart';
import 'package:krishi/screens/farm_detail_screen.dart';

class ManageFieldsWidget extends StatefulWidget {
  const ManageFieldsWidget({super.key});

  @override
  State<ManageFieldsWidget> createState() => _ManageFieldsWidgetState();
}

class _ManageFieldsWidgetState extends State<ManageFieldsWidget> {
  List<Map<String, String>> fields = [];

  static const double minHeight = 170;
  static const double maxHeight = 310;
  static const double blockHeight = 120; // Approximate height of a block

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int totalItems = fields.length + 1; // +1 for the Add button
        int rows = (totalItems / 2).ceil();
        double calculatedHeight = (rows * blockHeight).toDouble();

        // If more than 2 rows, make it scrollable
        bool shouldScroll = rows >= 2;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
          height: shouldScroll
              ? maxHeight
              : calculatedHeight.clamp(minHeight, maxHeight),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            physics: shouldScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    if (index < fields.length) {
                      return _fieldBlock(
                        context,
                        fields[index]['name']!,
                        fields[index]['asset']!,
                        fields[index]['acres']!,
                        index,
                      );
                    } else {
                      return _addFieldBlock(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fieldBlock(BuildContext context, String name, String assetPath,
      String acres, int index) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          fields.removeAt(index); // Remove block when long-pressed
        });
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FarmDetailScreen(
                fieldName: name, assetPath: assetPath),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 45,
              height: 45,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(acres,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _addFieldBlock(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newField = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmptyFieldScreen()),
        );

        if (newField != null && newField is Map<String, String>) {
          setState(() {
            fields.add(newField);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: const Center(
          child: Icon(Icons.add, size: 45, color: Colors.blue),
        ),
      ),
    );
  }
}
