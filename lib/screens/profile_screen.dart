import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // For date formatting

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  String name = "Loading...";
  String mobile = "Loading...";
  String email = "Loading...";
  DateTime? dob;
  String imagePath = "assets/Happy_farmer.png"; // Default profile image

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// Load user data from JSON file

  /// Load user data & profile image
  Future<void> loadUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userinfo.json');

      if (await file.exists()) {
        final jsonData = jsonDecode(await file.readAsString());

        setState(() {
          name = jsonData['name'] ?? "Unknown User";
          mobile = jsonData['mobile'] ?? "No Mobile";
          email = jsonData['email'] ?? "No Email";
          dob = jsonData['dob'] != null
              ? DateTime.tryParse(jsonData['dob'])
              : null;

          // 🔹 Check if image file exists
          String profileImagePath = jsonData['profile_image'] ?? "";
          if (profileImagePath.isNotEmpty &&
              File(profileImagePath).existsSync()) {
            imagePath = profileImagePath;
          } else {
            imagePath = "assets/Happy_farmer.png"; // Reset to default
          }
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  /// Opens the date picker dialog
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      imageCache.clear();
      imageCache.clearLiveImages();

      setState(() {
        dob = pickedDate;
      });
    }
  }

  /// Pick an image from gallery & save it persistently
  Future<void> _pickImage() async {
    if (!isEditing) return; // Allow only in edit mode

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final savedImagePath =
          '${directory.path}/profile_picture_${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        // Save the new image to the app's local storage
        await File(pickedFile.path).copy(savedImagePath);

        setState(() {
          imagePath = savedImagePath;
          imageCache.clear(); // 🔹 Clear cache to force update
          imageCache.clearLiveImages();
        });

        // Save updated data to JSON
        await _saveUserData();
      } catch (e) {
        print("Error saving image: $e");
      }
    }
  }

// Save updated user data
  Future<void> _saveUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userinfo.json');

      final userData = {
        'name': nameController.text,
        'mobile': mobileController.text,
        'email': emailController.text,
        'dob': dob?.toIso8601String(),
        'profile_image': imagePath, // 🔹 Always save latest image path
      };

      await file.writeAsString(jsonEncode(userData));
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
              if (!isEditing) {
                _saveUserData(); // Save changes when exiting edit mode
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1)); // Simulate loading time
          await loadUserData(); // Reload user data
          setState(() {}); // Trigger a UI refresh
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(), // Allows pull-to-refresh
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                _profilePicture(),
                SizedBox(height: 10),
                Text("Hello!, $name",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _profileCard("Personal Information", [
                  _infoRow(
                      "Name",
                      isEditing
                          ? nameController
                          : TextEditingController(text: name)),
                  _infoRow(
                      "Mobile No",
                      isEditing
                          ? mobileController
                          : TextEditingController(text: mobile),
                      editable: false),
                  _infoRow(
                    "Email",
                    isEditing
                        ? emailController
                        : TextEditingController(text: email),
                  ),
                ]),
                _dobCard(),
                _profileCard("Settings", [
                  _settingsItem("Change Password"),
                  _settingsItem("Language"),
                  _settingsItem("Delete Account", isDestructive: true),
                ]),
                _profileCard("Contact Us", [
                  _infoRow(
                      "Email",
                      TextEditingController(
                          text: "greenhorizonsgdsc@gmail.com"),
                      editable: false),
                  _infoRow(
                      "Phone", TextEditingController(text: "+91 88569 31190"),
                      editable: false),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile Picture with Custom Frame & Editable Camera Icon
  Widget _profilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // Square shape
          child: imagePath.startsWith("assets/")
              ? Image.asset(
                  imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(imagePath),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
        ),
        if (isEditing)
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 15),
              ),
            ),
          ),
      ],
    );
  }

  Widget _dobCard() {
    return _profileCard("Date of Birth", [
      GestureDetector(
        onTap: isEditing ? () => _pickDate(context) : null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dob != null
                    ? DateFormat("dd/MM/yyyy").format(dob!)
                    : "Select Date",
                style: TextStyle(fontSize: 16),
              ),
              if (isEditing) Icon(Icons.calendar_today, size: 18),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _profileCard(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(String title, TextEditingController controller,
      {bool editable = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          isEditing && editable
              ? Expanded(
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                )
              : Text(controller.text),
        ],
      ),
    );
  }

  Widget _settingsItem(String title, {bool isDestructive = false}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: isDestructive ? Colors.red : Colors.black),
      onTap: () {
        // Add navigation or actions here
      },
    );
  }
}
