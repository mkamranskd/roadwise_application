import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';

import '../global/style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _gender = '';
  String _selectedLanguage = 'English';
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor:  primaryBlueColor, // LinkedIn Blue
      ),
      body: SingleChildScrollView(
        child: FadeInUp(
          duration: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/default_avatar.jpg') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showImageSource(context);
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              color: Color(0xFF0077B5), // LinkedIn Blue
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0077B5), // LinkedIn Blue
                  ),
                ),
                const SizedBox(height: 10),
                buildTextField("Username"),
                buildTextField("Email"),
                buildTextField("Phone Number"),
                buildTextField("Address"),
                buildTextField("Date of Birth"),
                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0077B5), // LinkedIn Blue
                  ),
                ),
                const SizedBox(height: 10),
                buildRadioField("Gender", ['Male', 'Female','PreferNotToSay']),
                buildDropdownField("Preferred Language", [
                  'English',
                  'Spanish',
                  'French',
                  'German',
                  'Chinese',
                  'Japanese',
                  'Korean',
                  'Urdu',
                  // Add more languages as needed
                ]),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement functionality to update profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B5), // LinkedIn Blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          // Remove hint text
          hintText: null,

          // Add a prefix icon
          prefixIcon: Icon(Icons.search), // Replace with your desired icon

          // Style the border with rounded corners
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Adjust radius for rounded corners
          ),

          // Style the focused border with rounded corners
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Adjust radius for rounded corners
            borderSide: BorderSide(color:  primaryBlueColor, width: 2), // Optional: change color and width for focus
          ),

          // Style the enabled border with rounded corners
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Adjust radius for rounded corners
            borderSide: BorderSide(color: Colors.grey, width: 1), // Optional: change color and width for enabled state
          ),

          // Add content padding
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget buildRadioField(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            return Row(
              children: [
                Radio(
                  value: option,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildDropdownField(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          value: _selectedLanguage,
          onChanged: (newValue) {
            setState(() {
              _selectedLanguage = newValue.toString();
            });
          },
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _showImageSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
