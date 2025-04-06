import 'package:flutter/material.dart';
import 'package:krishi/screens/expense_calculator_screen.dart' ;
import 'package:krishi/screens/nuteriant_calculator_screen.dart';
class MiscWidget extends StatelessWidget {
  const MiscWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(context, "NPK Calculator", Icons.calculate,
              NutrientCalculatorScreen()),
          _buildButton(context, "Expense Calculator", Icons.attach_money,
               ExpenseScreen()),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, IconData icon, Widget screen) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NPKCalculatorScreen extends StatelessWidget {
  const NPKCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NPK Calculator")),
      body: const Center(
        child: Text("This is the NPK Calculator Screen"),
      ),
    );
  }
}

// class ExpenseCalculatorScreen extends StatelessWidget {
//   const ExpenseCalculatorScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Expense Calculator")),
//       body: const Center(
//         child: Text("This is the Expense Calculator Screen"),
//       ),
//     );
//   }
// }
