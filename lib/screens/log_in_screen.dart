import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // ✅ Import Firebase UserCredential
import 'package:krishi/services/auth_service.dart'; // ✅ Import AuthService
import 'package:krishi/main.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up_screen.dart'; // Import your SignUpScreen
import 'package:krishi/generated/app_localizations.dart';




// ✅ Move this below imports
final AuthService _authService = AuthService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Map<String, dynamic>?> _loadUserInfo() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/userinfo.json');

    if (await file.exists()) {
      String content = await file.readAsString();
      debugPrint("📂 UserInfo.json Content: $content"); // Debug log
      return jsonDecode(content);
    }
    debugPrint("⚠️ UserInfo.json not found!");
    return null;
  }

  void _validateAndLogin(BuildContext context) async {
    final userInfo = await _loadUserInfo();
    if (userInfo != null &&
        _emailController.text == userInfo['email'] &&
        _passwordController.text == userInfo['password']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBE9B0),
      body: Column(
        children: [
          TopBarGetStarted(), // 🔹 Added Top Bar Widget
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, "Enter Your Email"),
                    _buildTextField(_passwordController, "Password",
                        isPassword: true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 20),
                      ),
                      onPressed: () => _validateAndLogin(context),
                      child: Text(
                        AppLocalizations.of(context)!.get_back_into_krishi,
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),

                    const SizedBox(height: 15),

                    // Horizontal Line with OR
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Google Sign-in Button
                    GestureDetector(
                      onTap: () async {
                        debugPrint("Google Log-In Clicked");

                        UserCredential? userCredential = await _authService.signInWithGoogle(context);
                        if (userCredential != null) {
                          debugPrint("✅ Signed in as: ${userCredential.user?.displayName}");
                          //Navigate to the home_screen.dart after successfull sign-in
                          Navigator.pushReplacement(
                            context,
                                MaterialPageRoute(builder:(context) => MainScreen()),
                              );
                        } else {
                          debugPrint("❌ Google Sign-In failed");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/google_icon.png", height: 24),
                            SizedBox(width: 10),
                            Text("Log In with Google",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Facebook Sign-in Button
                    GestureDetector(
                      onTap: () async {
                        debugPrint("Facebook Log-In Clicked");
                      
                        UserCredential? userCredential = await AuthService().signInWithFacebook(context);
                        if (userCredential != null){
                          debugPrint("✅ Signed in as: ${userCredential.user?.displayName}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder:(context) => MainScreen()),
                          );
                        } else {
                          debugPrint("❌ Facebook Sign-In failed");
                        }                    
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Color(0xFF1877F2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/facebook_icon.webp",
                                height: 24),
                            SizedBox(width: 10),
                            Text("Log In with Facebook",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sign-up Text with Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}