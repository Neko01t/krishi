import 'package:flutter/material.dart';

class NutrientCalculatorScreen extends StatefulWidget {
  const NutrientCalculatorScreen({super.key});
  @override
  _NutrientCalculatorScreenState createState() =>
      _NutrientCalculatorScreenState();
}

class _NutrientCalculatorScreenState extends State<NutrientCalculatorScreen> {
  int treeCount = 0;
  String selectedCrop = "Grapes";
  bool isCalculated = false;
  double nitrogen = 0, phosphorus = 0, potassium = 0;

  final List<String> treeCrops = ["Mango", "Grapes"];
  final List<String> bushCrops = [
    "Tomato",
  ];
  final List<String> plantCrops = [
    "Cabbage",
    "Cauliflower",
    "Eggplant",
    "Potato",
    "Rice",
    "Wheat"
  ];

  final Map<String, Map<String, double>> nutrientValues = {
    "Cabbage": {"Nitrogen": 90, "Phosphorus": 45, "Potassium": 85},
    "Cauliflower": {"Nitrogen": 80, "Phosphorus": 40, "Potassium": 75},
    "Eggplant": {"Nitrogen": 70, "Phosphorus": 35, "Potassium": 65},
    "Grapes": {"Nitrogen": 50, "Phosphorus": 30, "Potassium": 40},
    "Mango": {"Nitrogen": 70, "Phosphorus": 40, "Potassium": 50},
    "Potato": {"Nitrogen": 100, "Phosphorus": 50, "Potassium": 90},
    "Rice": {"Nitrogen": 120, "Phosphorus": 60, "Potassium": 100},
    "Tomato": {"Nitrogen": 40, "Phosphorus": 20, "Potassium": 30},
    "Wheat": {"Nitrogen": 110, "Phosphorus": 55, "Potassium": 95},
    "Orange": {"Nitrogen": 65, "Phosphorus": 38, "Potassium": 48},
  };

  final Map<String, String> cropImages = {
    "Cabbage": "assets/images/cabbag.png",
    "Cauliflower": "assets/images/Cauliflower.png",
    "Eggplant": "assets/images/eggplant.png",
    "Grapes": "assets/images/grapes.png",
    "Mango": "assets/images/mango.png",
    "Potato": "assets/images/potato.png",
    "Rice": "assets/images/rice.png",
    "Tomato": "assets/images/tomato.png",
    "Wheat": "assets/images/wheat.png",
  };

  void calculateNutrients() {
    setState(() {
      Map<String, double> nutrients = nutrientValues[selectedCrop] ?? {};
      nitrogen = (nutrients["Nitrogen"] ?? 0) * treeCount;
      phosphorus = (nutrients["Phosphorus"] ?? 0) * treeCount;
      potassium = (nutrients["Potassium"] ?? 0) * treeCount;
      isCalculated = true;
    });
  }

  void incrementTrees() {
    setState(() {
      treeCount++;
    });
  }

  void decrementTrees() {
    if (treeCount >= 1) {
      setState(() {
        treeCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTree = treeCrops.contains(selectedCrop);
    bool isplant = plantCrops.contains(selectedCrop);
    String cropType = isTree
        ? "Tree"
        : isplant
        ? "Plant"
        : "Bush";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrient Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white, // Optional background color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonFormField<String>(
                      value: selectedCrop,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        Colors.white, // Background color of dropdown field
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                          borderSide: BorderSide.none, // Remove default border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10), // Adjust padding
                      ),
                      menuMaxHeight: 350, // Maximum height of the dropdown
                      borderRadius: BorderRadius.circular(
                          12), // Rounded corners for dropdown items
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCrop = newValue!;
                          isCalculated = false;
                        });
                      },
                      items: [...treeCrops, ...bushCrops, ...plantCrops]
                          .map<DropdownMenuItem<String>>((String crop) {
                        return DropdownMenuItem<String>(
                          value: crop,
                          child: Row(
                            children: [
                              Image.asset(
                                cropImages[crop] ?? "assets/pokeball.png",
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 8),
                              Text(
                                crop,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Center(),
                _buildNutrientCard("Nitrogen", nitrogen),
                SizedBox(height: 20),
                _buildNutrientCard("Phosphorus", phosphorus),
                SizedBox(height: 20),
                _buildNutrientCard("Potassium", potassium),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.purple),
                  onPressed: decrementTrees,
                ),
                Text(
                  " $cropType(s): $treeCount ",
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.purple),
                  onPressed: incrementTrees,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: calculateNutrients,
                child: const Text("Calculate"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(String nutrient, double value) {
    return Tooltip(
      message: nutrient,
      child: Card(
        shadowColor: Color(0xFF63b361),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 60,
          width: 190,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "$nutrient : $value",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}