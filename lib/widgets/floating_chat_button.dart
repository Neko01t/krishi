import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/chat_screen.dart'; // Import ChatScreen from screens folder

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      backgroundColor: Colors.blue,
      child: SvgPicture.asset(
        "assets/icons/finalchatbot.svg",
        width: 35,
        height: 35,
      ),
    );
  }
}
