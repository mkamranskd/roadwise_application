import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../domain/entities/current_user_profile_data.dart';

final _auth = FirebaseAuth.instance;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final sinceController = TextEditingController();
  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();
  final classController = TextEditingController();
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];
  bool isLoading = true;

  Map<String, dynamic>? currentUser;
  final UserService _userService = UserService();
  Future<void> _fetchUserDetails() async {
    print("loading asdfasdfsadfasd");
    final userDetails = await _userService.getCurrentUserDetails();
    setState(() {
      currentUser = userDetails;
    });
  }



  @override
  void initState() {
    super.initState();
    isLoading = true;
    loadCountries();
    _checkUserFields();
    _fetchUserDetails();
  }

  Future<void> loadCountries() async {
    print("loading countries");
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('countries').get();
      setState(() {
        countries = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print("Error loading countries: $e");
    }
  }

  Future<void> loadStates(String country) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(country)
          .collection('states')
          .get();

      setState(() {
        states = snapshot.docs.map((doc) => doc.id).toList();
      });

      if (selectedState != null && !states.contains(selectedState)) {
        selectedState = null;
      }

      cities = [];
    } catch (e) {
      print("Error loading states: $e");
    }
  }

  Future<void> loadCities(String country, String state) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(country)
          .collection('states')
          .doc(state)
          .collection('cities')
          .get();

      setState(() {
        cities = snapshot.docs.map((doc) => doc.id).toList();
      });

      if (selectedCity != null && !cities.contains(selectedCity)) {
        selectedCity = null;
      }
    } catch (e) {
      print("Error loading cities: $e");
    }
  }



  Future<void> _checkUserFields() async {
    print("loading user");
    final userData = await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser?.uid)
        .get();
    print("loading 000");
    if (userData.exists) {
      print("loading 1");
      setState(() {
        fullNameController.text = userData.data()!['fullName'].toString();
        ageController.text = userData.data()!['age'].toString();
        bioController.text = userData.data()!['bio'].toString();
        phoneController.text = userData.data()!['phoneNumber'].toString();
        addressController.text = userData.data()!['Address'].toString();
        selectedCountry = userData.data()!['country'];
        selectedState = userData.data()!['states'];
        selectedCity = userData.data()!['city'];
        sinceController.text = userData.data()!['since'];

      });
      if (selectedCountry != null) {
        await loadStates(selectedCountry!);
      }
      print("loading 2");
      if (selectedState != null) {
        await loadCities(selectedCountry!, selectedState!);
      }
      setState(() {
        isLoading = false;
      });
      print("loading 3");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
          ),
        ),
        body: Scaffold(
          body: isLoading
              ? Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: primaryBlueColor,
                    size: 25,
                  ),
              )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if(currentUser!['businessAccount'] == "true")...[
                          _businessProfileEdit()
                        ]else...[
                          _userProfileEdit()
                        ]

                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget _businessProfileEdit() {
    return Column(
      children: [
        H2(
          title: "Business Information",
          clr: primaryBlueColor,
        ),
        TEXTBOX(
          title: "Business Name",
          controller: fullNameController,
        ),
        TEXTBOX(
          title: "Since",
          controller: sinceController,
        ),
        TEXTBOX(
          title: "Bio",
          controller: bioController,
        ),
        TEXTBOX(
          title: "Phone",
          controller: phoneController,
        ),
        TEXTBOX(
          title: "Address",
          controller: addressController,
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Select Country",
          ),
          value: selectedCountry,
          items: countries.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
              selectedState = null;
              selectedCity = null;
              states = [];
              cities = [];
            });
            if (value != null) {
              loadStates(value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Select State",
            border: OutlineInputBorder(),
          ),
          value: selectedState,
          items: states.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedState = value;
              selectedCity = null;
              cities = [];
            });
            if (value != null && selectedCountry != null) {
              loadCities(selectedCountry!, value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Select City",
            border: OutlineInputBorder(),
          ),
          value: selectedCity,
          items: cities.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ZoomTapAnimation(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(_auth.currentUser?.uid)
                        .set({
                      "userId": _auth.currentUser?.uid,
                      "updatedAt": DateTime.now(),
                      "phoneNumber": phoneController.text.toString(),
                      "Address": addressController.text.toString(),
                      "fullName": fullNameController.text.toString(),
                      "since": sinceController.text.toString(),
                      "bio": bioController.text.toString(),
                      "country": selectedCountry,
                      "states": selectedState,
                      "city": selectedCity
                    }, SetOptions(merge: true));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _userProfileEdit() {
    return Column(
      children: [
        H2(
          title: "Personal Information",
          clr: primaryBlueColor,
        ),
        TEXTBOX(
          title: "Full Name",
          controller: fullNameController,
        ),
        TEXTBOX(
          title: "Bio",
          controller: bioController,
        ),
        TEXTBOX(
          title: "Age",
          controller: ageController,
        ),
        TEXTBOX(
          title: "Phone",
          controller: phoneController,
        ),
        TEXTBOX(
          title: "Address",
          controller: addressController,
        ),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Select Country",
          ),
          value: selectedCountry,
          items: countries.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
              selectedState = null;
              selectedCity = null;
              states = [];
              cities = [];
            });
            if (value != null) {
              loadStates(value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Select State",
            border: OutlineInputBorder(),
          ),
          value: selectedState,
          items: states.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedState = value;
              selectedCity = null;
              cities = [];
            });
            if (value != null && selectedCountry != null) {
              loadCities(selectedCountry!, value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "Select City",
            border: OutlineInputBorder(),
          ),
          value: selectedCity,
          items: cities.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ZoomTapAnimation(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(_auth.currentUser?.uid)
                        .set({
                      "userId": _auth.currentUser?.uid,
                      "updatedAt": DateTime.now(),
                      "phoneNumber": phoneController.text.toString(),
                      "Address": addressController.text.toString(),
                      "fullName": fullNameController.text.toString(),
                      "age": ageController.text.toString(),
                      "bio": bioController.text.toString(),
                      "country": selectedCountry,
                      "state": selectedState,
                      "city": selectedCity
                    }, SetOptions(merge: true));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
