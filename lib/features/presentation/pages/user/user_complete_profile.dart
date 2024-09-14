import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/features/domain/entities/current_user_profile_data.dart';
import 'package:roadwise_application/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/screens/dashboard_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

final _auth = FirebaseAuth.instance;

class UserCompleteProfile extends StatefulWidget {
  @override
  _UserCompleteProfileState createState() => _UserCompleteProfileState();
}

class _UserCompleteProfileState extends State<UserCompleteProfile> {
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
  bool isb = false;
  Map<String, dynamic>? currentUser;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    loadCountries();
  }

  Future<void> _fetchUserDetails() async {

    try {
      final userDetails = await _userService.getCurrentUserDetails();
      setState(() {
        currentUser = userDetails;
        isb = currentUser!['businessAccount'] ?? false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadCountries() async {
    print("loading countries");
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('countries').get();
      setState(() {
        countries = snapshot.docs.map((doc) => doc.id).toList();
        isLoading = false;
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
        cities = [];
      });

      if (selectedState != null && !states.contains(selectedState)) {
        selectedState = null;
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          FadeInDown(
            duration: const Duration(milliseconds: 300),
            delay: const Duration(milliseconds: 1400),
            child: ZoomTapAnimation(
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  iconColor: WidgetStateProperty.all(Colors.white),
                  iconSize: WidgetStateProperty.all(25),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                            'Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _auth.signOut().then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SignInScreen()),
                                );
                              }).onError((error, stackTrace) {
                                Utils.toastMessage(
                                    context,
                                    error.toString(),
                                    Icons.warning_amber_rounded);
                              });
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Clarity.logout_line,
                ),
              ),
            ),
          ),

        ],
      ),
      body: isLoading
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 25))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 100),
                      child: H1(
                          title: "Complete Your Profile",
                          clr: primaryBlueColor),
                    ),
                    _userProfileEdit(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _userProfileEdit() {


    return Column(
      children: [
        FadeInUp(
            duration: const Duration(milliseconds: 200),
            child: _buildTextBox("Account Name", fullNameController)),
        FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: _buildTextBox("Phone", phoneController)),
        FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: _buildTextBox("Address", addressController)),
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: _buildDropdown("Select Country", countries, selectedCountry,
              (value) {
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
          }),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: _buildDropdown("Select State", states, selectedState, (value) {
            setState(() {
              selectedState = value;
              selectedCity = null;
              cities = [];
            });
            if (value != null && selectedCountry != null) {
              loadCities(selectedCountry!, value);
            }
          }),
        ),
        FadeInUp(
          duration: const Duration(milliseconds: 1200),
          child: _buildDropdown("Select City", cities, selectedCity, (value) {
            setState(() {
              selectedCity = value;
            });
          }),
        ),
        const SizedBox(height: 16),
        FadeInUp(
          duration: const Duration(milliseconds: 1400),
          child: Row(
            children: [
              Expanded(
                child: ZoomTapAnimation(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_auth.currentUser == null) {
                        return; // handle user not logged in
                      }
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(_auth.currentUser?.uid)
                          .set({
                        "userId": _auth.currentUser?.uid,
                        "updatedAt": DateTime.now(),
                        "phoneNumber": phoneController.text.toString(),
                        "Address": addressController.text.toString(),
                        "fullName": fullNameController.text.toString(),
                        "country": selectedCountry,
                        "states": selectedState,
                        "city": selectedCity
                      }, SetOptions(merge: true));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FirstPage()),
                      );
                    },
                    child: const Text('Complete'),
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildTextBox(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> items, String? selectedValue,
      Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
        ),
        value: selectedValue,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
