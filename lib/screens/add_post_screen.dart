import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _descriptionController = TextEditingController();
  String _selectedCrop = 'Grape';
  XFile? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
        print(_selectedImage?.path);
      });
    }
  }

  void _submitPost() {
    if (_descriptionController.text.isEmpty) return;

    final newPost = {
      'username': 'New User',
      'time': 'Just now',
      'crop': _selectedCrop,
      'image': _selectedImage?.path ?? 'assets/no_image.png', // Default Image
      'description': _descriptionController.text,
      'likes': 0,
      'comments': 0,
      'isliked': false,
    };

    Navigator.pop(context, newPost); // Return data to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Post')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              items: ['Grape', 'Mango', 'Wheat']
                  .map((crop) =>
                  DropdownMenuItem(value: crop, child: Text(crop)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.file(
                File(_selectedImage!.path),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/no_image.png', // Default Image
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitPost,
              icon: Icon(Icons.upload),
              label: Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}