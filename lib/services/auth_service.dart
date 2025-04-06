import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishi/screens/home_screen.dart';  // Import your home screen
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? _verificationId; // Stores verification ID for OTP verification

  // ✅ Google Sign-In method (Unchanged)
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // ✅ Navigate to home screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

      return userCredential;
    } catch (e) {
      print("🔥 Google Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Facebook Sign-In method (Unchanged)
  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        UserCredential userCredential = await _auth.signInWithCredential(credential);

        // ✅ Navigate to home screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

        return userCredential;
      }
      return null;
    } catch (e) {
      print("🔥 Facebook Sign-In Error: $e");
      return null;
    }
  }

  // ✅ OTP Authentication: Send OTP
  Future<void> sendOtp(String phoneNumber, BuildContext context, Function onCodeSent) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber", // Assuming India (+91)
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign-in for devices that support auto-verification
          await _auth.signInWithCredential(credential);
          print("✅ Auto OTP Verification Successful!");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        verificationFailed: (FirebaseAuthException e) {
          print("❌ OTP Verification Failed: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed. Try again.")));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(); // Notify UI that OTP has been sent
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("⌛ OTP Auto-retrieval timeout");
        },
        timeout: const Duration(seconds: 60), // OTP valid for 60 seconds
      );
    } catch (e) {
      print("🔥 Error Sending OTP: $e");
    }
  }

  // ✅ OTP Authentication: Verify OTP
  Future<void> verifyOtp(String otp, BuildContext context) async {
    try {
      if (_verificationId == null) {
        print("❌ No verification ID found!");
        return;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      print("✅ OTP Verified Successfully!");

      // ✅ Navigate to home screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print("🔥 OTP Verification Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP. Please try again.")));
    }
  }

  // ✅ Improved Sign out method
  Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      await FacebookAuth.instance.logOut();
      await _auth.signOut();

      print("🚪 User signed out successfully");
    } catch (e) {
      print("❌ Logout Error: $e");
    }
  }
}
