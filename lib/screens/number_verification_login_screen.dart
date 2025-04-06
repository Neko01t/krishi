import 'package:flutter/material.dart';
import 'package:krishi/screens/log_in_screen.dart';
import 'package:krishi/screens/otp_verification_screen.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NumberVerificationLoginScreen extends StatefulWidget {
  const NumberVerificationLoginScreen({super.key});

  @override
  _NumberVerificationLoginScreenState createState() =>
      _NumberVerificationLoginScreenState();
}

class _NumberVerificationLoginScreenState
    extends State<NumberVerificationLoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void _sendOtp() async {
    String mobileNumber = _mobileController.text.trim();

    if (mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit number")),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$mobileNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verId, int? resendToken) {
          setState(() => isLoading = false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                mobileNumber: mobileNumber,
                verificationId: verId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6AE), // Light green background
      body: Column(
        children: [
          const TopBarGetStarted(), // Black top bar

          const SizedBox(height: 100),

          // Mobile number input section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mobile Number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.white,
                      ),
                      child: const Text("+91",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter Your Mobile No.",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Confirm Button
          SizedBox(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
              ),
              onPressed: _sendOtp, // ✅ Corrected function reference
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("SEND OTP",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),

          const SizedBox(height: 40),

          // OR Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Already Linked an account on Krishi?",
                    style: TextStyle(fontSize: 15)),
              ),
              Expanded(child: Divider(color: Colors.grey, thickness: 1)),
            ],
          ),

          const SizedBox(height: 40),

          // Social Login Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                // Google login button
                GestureDetector(
                  onTap: () {
                    debugPrint("Google Log-In Clicked");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/google_icon.png", height: 24),
                        const SizedBox(width: 10),
                        const Text("Log In with Google",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                // Facebook login button
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    debugPrint("Facebook Log-In Clicked");
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1877F2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/facebook_icon.webp", height: 24),
                        const SizedBox(width: 10),
                        const Text("Log In with Facebook",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text(
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
    );
  }
}
