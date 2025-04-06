import 'package:krishi/main.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Import Firebase UserCredential
import 'package:krishi/services/auth_service.dart'; // ✅ Import AuthService
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/screens/number_verification_login_screen.dart';
import 'package:krishi/screens/log_in_screen.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService(); // ✅ AuthService instance
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imageFile = File('${directory.path}/profile_image.png');
      await File(pickedFile.path).copy(imageFile.path);
      setState(() {
        _image = imageFile;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', imageFile.path);
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/userinfo.json');

    final userData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "mobile": _mobileController.text,
      "password": _passwordController.text,
      "profile_image": _image?.path ?? ""
    };

    await file.writeAsString(jsonEncode(userData));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);

    debugPrint("✅ User info saved at: ${file.path}");
    debugPrint("🖼️ Profile image saved at: ${_image?.path ?? "No image"}");
    // String mobileNumber = userData['mobile'] ?? "";

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NumberVerificationLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFDBE9B0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarGetStarted(),
              SizedBox(height: 15),

              // 🔹 Profile Image Picker
              _buildProfileImagePicker(),

              SizedBox(height: 15),
              _buildTextField(_nameController, "Enter Full Name"),
              _buildTextField(_emailController, "Enter Your Email"),
              _buildTextField(_mobileController, "Enter Your Mobile Number"),
              _buildTextField(_passwordController, "Password",
                  isPassword: true),
              SizedBox(height: 15),

              // 🔹 Signup Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                ),
                onPressed: () => _registerUser(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                    SizedBox(width: 30),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE9B0), // Background color
                        shape: BoxShape.circle, // Circular background
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // 🔹 Google Sign-Up Button
              GestureDetector(
                onTap: () async {
                  debugPrint("Google Sign-Up Clicked");

                  UserCredential? userCredential = await _authService.signInWithGoogle(context);
                  if (userCredential != null) {
                    debugPrint("✅ Signed in as: ${userCredential.user?.displayName}");
                    // Navigate to the home_screen.dart after successful sign-in
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
                      Text("Sign up with Google",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5),

              // 🔹 Facebook Sign-Up Button
              GestureDetector(
                onTap: () async {
                  debugPrint("Facebook Sign-Up Clicked");

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
                      Image.asset("assets/facebook_icon.webp", height: 24),
                      SizedBox(width: 10),
                      Text("Sign up with Facebook",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector( //"already_have_an_account" = ""
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: _image != null
                ? Image.file(_image!,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Image.asset('assets/Happy_farmer.png',
                    width: 100, height: 100, fit: BoxFit.cover),
          ),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
