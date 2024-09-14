import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:roadwise_application/screens/businessinfopage.dart';

class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late List<DocumentSnapshot> usersList = [];
  late List<DocumentSnapshot> filteredUsersList = [];
  bool isLoading = true;
  bool showEducationPaths = true;
  String searchQuery = "";
  final FocusNode _searchFocusNode = FocusNode();
  bool showBusinessAccountsOnly = false;
  int filteredCount = 0;
  String? selectedCity; // Add variable for selected city
  List<String> cities = []; // List of cities for the dropdown

  @override
  void initState() {
    super.initState();
    fetchUsers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("Users").get();
      setState(() {
        usersList = snapshot.docs;
        filteredUsersList = [];
        filteredCount = 0;
        isLoading = false;
      });

      // Extracting the city field from each user document
      List<String> dynamicCities = usersList
          .map((user) =>
              (user.data() as Map<String, dynamic>)['city']?.toString() ??
              'Unknown')
          .toList();

      // Remove duplicates and sort the list of cities
      List<String> distinctCities = dynamicCities.toSet().toList()..sort();

      setState(() {
        cities = distinctCities;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterUsers(String query) {
    List<DocumentSnapshot> filteredUsers;

    if (query == '*') {
      filteredUsers = usersList;
    } else if (query.isEmpty) {
      filteredUsers = [];
    } else {
      filteredUsers = usersList.where((user) {
        String fullName = (user.data() as Map<String, dynamic>)['fullName']
            .toString()
            .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    }

    if (showBusinessAccountsOnly) {
      filteredUsers = filteredUsers.where((user) {
        var userData = user.data() as Map<String, dynamic>;
        return userData.containsKey('businessAccount') &&
            userData['businessAccount'] == "true";
      }).toList();
    }

    if (selectedCity != null && selectedCity!.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return (user.data() as Map<String, dynamic>)['city'] == selectedCity;
      }).toList();
    }

    setState(() {
      filteredUsersList = filteredUsers;
      filteredCount = filteredUsers.length;
      searchQuery = query;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filter Options',
                      ),
                      const Expanded(
                          child: SizedBox(
                        width: 1,
                      )),
                      Icon(Clarity.filter_line, color: primaryBlueColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    tileColor: Colors.transparent,
                    title: Text(
                      showBusinessAccountsOnly
                          ? "Showing All Accounts"
                          : "Show Business Accounts",
                    ),
                    value: showBusinessAccountsOnly,
                    onChanged: (bool value) {
                      setState(() {
                        showBusinessAccountsOnly = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    hint: const Text('Select City'),
                    items: cities.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            filterUsers(searchQuery);
                            Navigator.pop(context);
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showBusinessAccountsOnly = false;
                              selectedCity = null;
                            });
                            filterUsers(searchQuery);
                            Navigator.pop(context);
                          },
                          child: const Text('Clear Filters'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserCard(DocumentSnapshot user) {
    var userData = user.data() as Map<String, dynamic>? ?? {};
    String fullName = userData['fullName'] ?? 'Unknown Name';
    String country = userData['country'] ?? 'Unknown Country';
    String profilePicture = userData['profilePicture'] ?? '';

    /*if (userData['fullName'] == "Neha Urooj") {
      fullName = "Unknown Unknown";
      profilePicture =
      "https://firebasestorage.googleapis.com/v0/b/roadwise-application-54684.appspot.com/o/profilePictures%2F8Qlio7yvEUhbdrwArb7mZxkOGXw1?alt=media&token=2495a17f-bb4c-41a9-a6e3-c802e2fa72dc";
    }*/

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: profilePicture.isNotEmpty? NetworkImage(profilePicture): const AssetImage("assets/icons/user1.png",) as ImageProvider<Object>,
      ),
      title: Text(
        '$fullName ',
      ),
      trailing: IconButton(
        onPressed: () {
          Utils.toastMessage(context, "Not Integrated Yet", Icons.warning);
        },
        icon: const Icon(
          FontAwesomeIcons.plus,
          size: 15,
        ),
      ),
      subtitle: Column(
        children: [
          const Row(
            children: [
              const SizedBox(height: 8),
            ],
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                child: Icon(
                  userData['businessAccount'] == "true"
                      ? Icons.business
                      : Icons.person,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'From $country',
                //'From $city, $country',
                style: const TextStyle(
                  fontFamily: 'Dubai',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        debugPrint('Tapped on: $fullName');
        Navigator.push(
          context,
          MaterialPageRoute(
            //builder: (context) => BusinessPageScreen(businessData: user,),
            builder: (context) => BusinessPageScreen(
              businessData: user,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("Search")),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
              color: Colors.blue,
              size: 25,
            ))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      filterUsers(value);
                    },
                    onSubmitted: (value) {
                      filterUsers(value); // Trigger search on submit
                      _searchFocusNode.unfocus(); // Optionally clear focus
                    },
                    decoration: InputDecoration(
                        //icon: const Icon(Clarity.search_line),
                        labelText: null,
                        helper: Text(
                          showBusinessAccountsOnly
                              ? "Showing $filteredCount Business Accounts"
                              : "Showing $filteredCount Accounts",
                          style: const TextStyle(color: Colors.blue),
                        ),
                        suffix: GestureDetector(
                            onTap: () {
                              fetchUsers();
                              _showFilterDialog();
                            },
                            child: const Icon(
                              Clarity.filter_line,
                            ))),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await fetchUsers(); // Refresh the users list
                      filterUsers(
                          searchQuery); // Apply existing filters after refresh
                    },
                    child: ListView(
                      children: [
                        if (searchQuery.isNotEmpty)
                          ...filteredUsersList
                              .map((user) => _buildUserCard(user)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
