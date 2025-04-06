import 'package:flutter/material.dart';
import 'package:krishi/screens/todo_task_screen.dart';

class ToDoButtonWidget extends StatelessWidget {
  const ToDoButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TodoTaskScreen()),
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 16.0),
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "To-Do List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.list_alt,
                size: 60,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}