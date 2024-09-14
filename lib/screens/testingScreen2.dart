import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/features/domain/entities/current_user_profile_data.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/global/svg_illustrations.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SelectingCountryStateCity extends StatefulWidget {
  @override
  _SelectingCountryStateCityState createState() =>
      _SelectingCountryStateCityState();
}

class _SelectingCountryStateCityState extends State<SelectingCountryStateCity> {
  final UserService _userService = UserService();
  bool _isLoading = true; // Track the loading state
  Map<String, dynamic>? currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final userDetails = await _userService.getCurrentUserDetails();

    setState(() {
      currentUser = userDetails;
      _isLoading = false; // Loading finished
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select Location',
          ),

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: primaryBlueColor,
            ),
          ),
          //title:   ProgressBar(count: _currentQuestionIndex + 1, total: 5),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: primaryBlueColor,
                size: 25,
              ))
              : currentUser != null
              ? Column(
            children: [
              Container(
                height: textBoxHeight,
                child: ZoomTapAnimation(
                  child: TextField(
                    controller: TextEditingController(
                      text: (currentUser != null &&
                          currentUser!['country'] != null)
                          ? currentUser!['country'] as String
                          : 'Select Country',
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Country",
                      suffix: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchLocation(
                                  search: 'country',
                                  // Indicate that the user is searching for countries
                                  snapshot: FirebaseFirestore.instance
                                      .collection('countries')
                                      .get(), // Pass the snapshot
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Clarity.edit_line,
                            size: 20,
                            color: Colors.blue,
                          )),
                      hintText: null,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (currentUser!['country'] != null) ...[
                Container(
                  height:
                  textBoxHeight, // Set the height of the container
                  child: ZoomTapAnimation(
                    child: TextField(
                      controller: TextEditingController(
                        text: (currentUser != null &&
                            currentUser!['states'] != null)
                            ? currentUser!['states'] as String
                            : 'Select State',
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "State",
                        suffix: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchLocation(
                                        search: 'states',
                                        // Indicate that the user is searching for countries
                                        snapshot: FirebaseFirestore
                                            .instance
                                            .collection('countries')
                                            .doc(currentUser!['country'])
                                            .collection('states')
                                            .get(), // Pass the snapshot
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Clarity.edit_line,
                              size: 20,
                              color: Colors.blue,
                            )),
                        hintText: null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              if (currentUser!['states'] != null) ...[
                Container(
                  height:
                  textBoxHeight, // Set the height of the container
                  child: ZoomTapAnimation(
                    child: TextField(
                      controller: TextEditingController(
                        text: (currentUser != null &&
                            currentUser!['city'] != null)
                            ? currentUser!['city'] as String
                            : 'Select City',
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "City",
                        suffix: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchLocation(
                                        search: 'city',
                                        // Indicate that the user is searching for countries
                                        snapshot: FirebaseFirestore
                                            .instance
                                            .collection('countries')
                                            .doc(currentUser!['country'])
                                            .collection('states')
                                            .doc(currentUser!['states'])
                                            .collection('cities')
                                            .get(), // Pass the snapshot
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Clarity.edit_line,
                              size: 20,
                              color: Colors.blue,
                            )),
                        hintText: null,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          )
              : const Text('No user data available'),
        ));
  }
}

class SearchLocation extends StatefulWidget {
  final String search;
  final Future<QuerySnapshot<Map<String, dynamic>>> snapshot;

  const SearchLocation({
    super.key,
    required this.search,
    required this.snapshot,
  });

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List<String> countries = [];
  List<String> filteredCountries = [];
  bool isLoading = true;
  String? selectedCountry; // Store the saved country here
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCountries();
    loadSelectedCountry();
  }

  // Function to fetch countries from Firestore using the passed snapshot
  Future<void> fetchCountries() async {
    try {
      final snapshot =
      await widget.snapshot; // Wait for the snapshot to resolve
      final countryList = snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        countries = countryList;
        filteredCountries = countryList; // Initialize with all countries
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching countries: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to load the saved country from Firestore
  Future<void> loadSelectedCountry() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          setState(() {
            selectedCountry =
            userDoc.data()![widget.search]; // Load the saved country
          });
        }
      }
    } catch (e) {
      print('Error loading selected country: $e');
    }
  }

  // Function to filter the country list based on search query
  void filterCountries(String query) {
    final filtered = countries.where((country) {
      return country.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCountries = filtered;
    });
  }

  // Function to save the selected city to Firestore
  Future<void> saveSelectedCity(String city) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        if (widget.search == "country") {
          await FirebaseFirestore.instance.collection("Users").doc(userId).set(
              {widget.search: city, "states": null, "city": null},
              SetOptions(merge: true));
        } else if (widget.search == "states") {
          await FirebaseFirestore.instance.collection("Users").doc(userId).set(
              {widget.search: city, "city": null}, SetOptions(merge: true));
        } else if (widget.search == "city") {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(userId)
              .set({widget.search: city}, SetOptions(merge: true));
        }

        setState(() {
          selectedCountry = city; // Update the selected country
        });

        print('City saved: $city');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.search} $city saved successfully')),
        );
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error saving city: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Container(
          height: 45,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText:
              'SEARCH ${widget.search}'.toUpperCase(),
              suffix: const Icon(
                Clarity.search_line,
              ),
            ),
            onChanged: (query) => filterCountries(query),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
          Icon(Icons.arrow_back_ios_new, color: primaryBlueColor, size: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeInUp(
          duration: const Duration(milliseconds: 1),
          child: isLoading
              ? Center(
            child: LoadingAnimationWidget.inkDrop(
              color: primaryBlueColor,
              size: 25,
            ),
          )
              : filteredCountries.isNotEmpty
              ? Column(
            children: [

              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    final isSelected = country ==
                        selectedCountry; // Check if the country is selected
                    return ZoomTapAnimation(
                      child: Card(
                        color:
                        isSelected ? Colors.blue : Colors.green,
                        child: ListTile(
                          leading: isSelected
                              ? const Icon(
                            Clarity.dot_circle_line,
                            color: Colors.blue,
                          ) // Show check icon for selected country
                              : const Icon(
                            Clarity.circle_line,
                            color: Colors.black45,
                          ),
                          title: Text(
                            country,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            saveSelectedCity(country);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SelectingCountryStateCity(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
              : Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SvgPicture.string(
                      underMaintenanceIllustration,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Text(
                  'We are not available in this ${widget.search} for Now.\nWe are Working on it'
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
