import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  double balance = 0.0;
  double income = 0.0;
  double expenses = 0.0;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController(); // Controller for notes

  String selectedCurrency = "₹";
  List<FlSpot> balanceHistory = [FlSpot(0, 0)];
  int transactionCount = 1;

  List<Map<String, dynamic>> transactions = [];

  void addIncome() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    String note = noteController.text.trim();
    if (amount > 0) {
      setState(() {
        income += amount;
        balance += amount;
        balanceHistory.add(FlSpot(transactionCount.toDouble(), balance));
        transactionCount++;
        transactions.add({
          'type': 'Income',
          'amount': amount,
          'date': DateTime.now().toString(),
          'note': note.isEmpty ? "No note" : note,
        });
      });
    }
    amountController.clear();
    noteController.clear();
  }

  void addExpense() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    String note = noteController.text.trim();
    if (amount > 0) {
      setState(() {
        expenses += amount;
        balance -= amount;
        balanceHistory.add(FlSpot(transactionCount.toDouble(), balance));
        transactionCount++;
        transactions.add({
          'type': 'Expense',
          'amount': amount,
          'date': DateTime.now().toString(),
          'note': note.isEmpty ? "No note" : note,
        });
      });
    }
    amountController.clear();
    noteController.clear();
  }

  void resetValues() {
    setState(() {
      balance = 0.0;
      income = 0.0;
      expenses = 0.0;
      balanceHistory = [FlSpot(0, 0)];
      transactionCount = 1;
      transactions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense & Income Tracker"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      balance == 0
                          ? "Balance: $selectedCurrency${balance.toStringAsFixed(2)}"
                          : balance > 0
                          ? "Profit: $selectedCurrency${balance.toStringAsFixed(2)}"
                          : "Loss: $selectedCurrency${balance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: balance == 0
                            ? Colors.black
                            : balance > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "Income: $selectedCurrency${income.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.green, fontSize: 18)),
                    Text(
                        "Expenses: $selectedCurrency${expenses.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.red, fontSize: 18)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount:",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "Enter Notes (optional):",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: addIncome,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Add Income"),
                ),
                ElevatedButton(
                  onPressed: addExpense,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Add Expense"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetValues,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text("Reset"),
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Text(
                        "${transaction['type']}: $selectedCurrency${transaction['amount']}",
                        style: TextStyle(
                          color: transaction['type'] == 'Income'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction['date']),
                          Text("Note: ${transaction['note']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}