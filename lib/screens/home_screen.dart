import 'package:flutter/material.dart';
import 'package:krishi/screens/data_screen.dart';
import 'package:krishi/screens/select_circle_screen.dart';
import 'package:krishi/models/circle_data.dart';
import 'package:krishi/widgets/gov_schemes_widgets.dart';
import 'package:krishi/widgets/mange_fields.dart';
import 'package:krishi/widgets/misc_widget.dart';
import 'package:krishi/widgets/pests_and_disease_widget.dart';
import 'package:krishi/widgets/weather_widget.dart';
import 'package:krishi/data/user_selected_circle.dart';
import 'package:krishi/data/list.dart';
import 'package:krishi/widgets/todo_list_widget.dart';
import 'package:krishi/widgets/floating_chat_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CircleData> circles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: plantCircleHome(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft, // Force left alignment
                child: Text(
                  "Weather",
                  style: const TextStyle(
                    fontSize: 18, // Subtitle size
                    fontWeight: FontWeight.bold, // Bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            WeatherWidget(),
            const SizedBox(height: 10),
            ManageFieldsWidget(),
            const SizedBox(height: 10),
            ToDoButtonWidget(),
            const SizedBox(height: 10),
            PestsAndDiseasesWidget(),
            const SizedBox(height: 10),
            GovSchemesWidget(),
            const SizedBox(height: 15),
            Divider(),
            MiscWidget(),
          ],
        ),
      ),
      floatingActionButton: const FloatingChatButton(), // Added Floating Button
    );
  }

  List<Widget> plantCircleHome() {
    List<Widget> circleWidgets = List.generate(
      circles.length,
      (index) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataScreen(circle: circles[index]),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 99, 157, 98),
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Hero(
                tag: 'hero-${circles[index].name}', // Unique tag for animation
                child: ClipOval(
                  child: Image.asset(
                    circles[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    CircleData removedCircle = circles[index];
                    circles.removeAt(index);
                    userSelectedCircles.removeWhere(
                      (c) => c.name == removedCircle.name,
                    );
                    if (!availableCircles.any(
                      (c) => c.name == removedCircle.name,
                    )) {
                      availableCircles.add(removedCircle);
                    }
                  });
                }
              },
              child: Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(96, 253, 90, 78),
                ),
                child: const Icon(Icons.close, size: 10, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    circleWidgets.add(
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectCircleScreen()),
          ).then((newCircle) {
            if (mounted &&
                newCircle != null &&
                newCircle is CircleData &&
                !circles.any((circle) => circle.name == newCircle.name)) {
              setState(() {
                circles.add(newCircle);
                userSelectedCircles.add(newCircle); // Add to global list
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added new crop: ${newCircle.name}"),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green.shade700,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade700,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(child: Icon(Icons.add, color: Colors.white)),
        ),
      ),
    );

    return circleWidgets;
  }
}
