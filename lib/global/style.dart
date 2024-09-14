import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/features/presentation/pages/jobs_page/job_details.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
final _auth = FirebaseAuth.instance;

const kPrimaryColor = Color(0xff0a66c2);
const kPrimaryLightColor = Color(0xFFFFECDF);
Color primaryBlueColor = const Color(0xff0094fd);
double textBoxHeight = 50.0;
Color primaryGrayShade = const Color(0xffeeeeee); //Colors.grey.shade200;
BorderRadius primaryBorderRadius = BorderRadius.circular(10);
var boxOutlineBorder = OutlineInputBorder(
  borderRadius: primaryBorderRadius,
  borderSide: BorderSide(color: primaryBlueColor, width: 1),
);

class TEXTBOX extends StatelessWidget {
  final String title;
  final TextEditingController? controller;

  TEXTBOX({Key? key, required this.title, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: textBoxHeight,
          child: TextField(
            obscureText: false,
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              hintText: 'Enter $title',
            ),
          ),
        ),
        const SizedBox(height: 10), // Adjusted SizedBox height
      ],
    );
  }
}

class Field extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String heading;

  const Field(
      {super.key, required this.title, required this.heading, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: null,
            controller: TextEditingController(text: title),
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.blue,
              ),
              labelText: heading,
              hintText: null,
            ),
          ),
        ),
      ],
    );
  }
}

class H1 extends StatelessWidget {
  final String title;
  final Color clr;

  const H1({super.key, required this.title, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: clr,
            fontSize: 30,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class H2 extends StatelessWidget {
  final String title;
  final Color clr;

  const H2({super.key, required this.title, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: clr,
            fontSize: 24,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

class H3 extends StatelessWidget {
  final String title;

  final Color clr;

  const H3({super.key, required this.title, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          title,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class H4 extends StatelessWidget {
  final String title;
  final Color clr;

  const H4({super.key, required this.title, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: clr,
            fontSize: 15,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class H5 extends StatelessWidget {
  final String title;
  final Color clr;

  const H5({super.key, required this.title, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: clr,
            fontSize: 11,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class H6 extends StatelessWidget {
  final String title;

  final Color clr;

  const H6({super.key, required this.title, required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: clr,
            fontSize: 5,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 0,
        ),
      ],
    );
  }
}

class CAPTION extends StatelessWidget {
  final String title;

  const CAPTION({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "   " + title,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontFamily: 'Dubai',
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 3,
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title; // Make navigateTo parameter optional
  final Color clr1;
  final Color clr2; // Added onPressed parameter
  final VoidCallback? onTap;
  final bool loading;

  CustomButton({
    required this.title,
    required this.clr1,
    required this.clr2,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  clr1,
                  clr2,
                ],
              ),
            ),
            child: Center(
              child: loading
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 35,
                    )
                  : Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Dubai',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextWithIconState extends StatefulWidget {
  final String text;

  const TextWithIconState({Key? key, required this.text}) : super(key: key);

  @override
  _TextWithIconState createState() => _TextWithIconState();
}

class _TextWithIconState extends State<TextWithIconState> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.red,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: 'Dubai',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      )
                    : const Icon(Icons.cancel, color: Colors.red),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class TextWithIcon extends StatefulWidget {
  final List<String> options;

  const TextWithIcon({Key? key, required this.options}) : super(key: key);

  @override
  _TextWithRadioState createState() => _TextWithRadioState();
}

class _TextWithRadioState extends State<TextWithIcon> {
  int selectedIndex = 0; // Initially no option is selected

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.options.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: selectedIndex == index ? primaryBlueColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedIndex == index ? primaryBlueColor : Colors.white,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.options[index],
                  style: TextStyle(
                    fontFamily: 'Dubai',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: selectedIndex == index ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                selectedIndex == index
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      )
                    : const Icon(Icons.radio_button_unchecked,
                        color: Colors.red),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;

  const CustomSearchBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.black,
        fontFamily: 'Dubai',
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Search",
        prefixIcon: Icon(
          Clarity.search_line,
          size: 20,
          color: primaryBlueColor,
        ),
        suffixIcon: Icon(
          Clarity.filter_line,
          size: 20,
          color: primaryBlueColor, // Assuming primaryBlueColor is defined
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Dubai',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class BadgeWidget extends StatefulWidget {
  final String text;

  const BadgeWidget({Key? key, required this.text}) : super(key: key);

  @override
  _BadgeWidgetState createState() => _BadgeWidgetState();
}

class _BadgeWidgetState extends State<BadgeWidget> {
  bool _isSelected = false;

  void _toggleSelected() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isSelected ? primaryBlueColor : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

bool isBusinessAccount = false;

ifBusinessAccount() async {
  final userData = await FirebaseFirestore.instance
      .collection("Users")
      .doc(_auth.currentUser?.uid)
      .get();
  if (userData["businessAccount"] == "true") {
    isBusinessAccount = false;
  } else {
    isBusinessAccount = true;
  }
}

class CustomComboBox extends StatefulWidget {
  final String title;
  final String firebaseFieldName;
  final TextEditingController? controller;
  final String defaultValue;

  CustomComboBox({
    required this.title,
    required this.firebaseFieldName,
    this.controller,
    this.defaultValue = '',
  });

  @override
  _CustomComboBoxState createState() => _CustomComboBoxState();
}

class _CustomComboBoxState extends State<CustomComboBox> {
  String _selectedValue =
      "Select City"; // Initialize with the default placeholder
  List<String> _items = [
    "Select City"
  ]; // Add the default placeholder as the first item
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch cities from Firestore by retrieving the document IDs
        final snapshot =
            await FirebaseFirestore.instance.collection("cities").get();

        final cities =
            snapshot.docs.map((doc) => doc.id).toList(); // Use document IDs

        setState(() {
          _items.addAll(
              cities); // Add fetched cities to the list after "Select City"
          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching cities: $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: LoadingAnimationWidget.inkDrop(
        color: Colors.blue,
        size: 25,
      )); // Show loader while loading cities
    }

    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: widget.title,
            hintStyle: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Dubai',
              fontWeight: FontWeight.w500,
            ),
          ),
          value: _selectedValue,
          items: _items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != "Select City") {
              setState(() {
                _selectedValue = newValue;
                _updateFirebaseField(newValue);
              });
            }
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  void _updateFirebaseField(String? newValue) async {
    final user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
        widget.firebaseFieldName: newValue,
      }, SetOptions(merge: true));
    }
  }
}

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}

class BusinessProfileCustomSmallHeading extends StatelessWidget {
  final String title;
  final String value;

  const BusinessProfileCustomSmallHeading(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: primaryBlueColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final bool hasNavigation;
  final String title;
  final VoidCallback ontap;

  const ProfileListItem({
    Key? key,
    required this.icon,
    this.hasNavigation = true,
    required this.title,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: ZoomTapAnimation(
        child: ListTile(
          title: title == 'Delete your Account Data Permanently'
              ? Text(
                  title,
                  style: const TextStyle(color: Colors.red),
                )
              : Text(title),
          leading: Icon(
            icon,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
        ),
      ),
    );
  }
}

class CascadingDropdowns extends StatefulWidget {
  @override
  _CascadingDropdownsState createState() => _CascadingDropdownsState();
}

class _CascadingDropdownsState extends State<CascadingDropdowns> {
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  List<String> _countries = [];
  List<String> _states = [];
  List<String> _cities = [];

  bool _isLoadingCountry = true;
  bool _isLoadingState = false;
  bool _isLoadingCity = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userId =
          _auth.currentUser?.uid; // Replace with your authentication method
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();
        final userData = userDoc.data();

        if (userData != null) {
          _selectedCountry = userData['country'].toString().trim();
          _selectedState = userData['state'].toString().trim();
          _selectedCity = userData['city'].toString().trim();
        }

        await _fetchCountries();
      } else {
        await _fetchCountries();
      }
    } catch (e) {
      print("Error fetching user data: $e");
      await _fetchCountries();
    }
  }

  Future<void> _fetchCountries() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('countries').get();
      final countries = snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        _countries = ["Select Country"] + countries;
        _isLoadingCountry = false;

        // Debugging: Print the fetched countries
        print("Fetched countries: $_countries");

        if (_selectedCountry != null && _countries.contains(_selectedCountry)) {
          _fetchStates(_selectedCountry!);
        }
      });
    } catch (e) {
      print("Error fetching countries: $e");
      setState(() {
        _isLoadingCountry = false;
      });
    }
  }

  Future<void> _fetchStates(String countryId) async {
    setState(() {
      _isLoadingState = true;
      _states = ["Select State"];
      _selectedState = null;
      _cities = ["Select City"];
      _selectedCity = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(countryId)
          .collection('states')
          .get();
      final states = snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        _states = ["Select State"] + states;
        _isLoadingState = false;

        // Debugging: Print the fetched states
        print("Fetched states for country $countryId: $_states");

        if (_selectedState != null && _states.contains(_selectedState)) {
          _fetchCities(countryId, _selectedState!);
        }
      });
    } catch (e) {
      print("Error fetching states: $e");
      setState(() {
        _isLoadingState = false;
      });
    }
  }

  Future<void> _fetchCities(String countryId, String stateId) async {
    setState(() {
      _isLoadingCity = true;
      _cities = ["Select City"];
      _selectedCity = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(countryId)
          .collection('states')
          .doc(stateId)
          .collection('cities')
          .get();
      final cities = snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        _cities = ["Select City"] + cities;
        _isLoadingCity = false;

        // Debugging: Print the fetched cities
        print("Fetched cities for state $stateId: $_cities");

        // Set the previously selected city
        if (_selectedCity != null && _cities.contains(_selectedCity)) {
          _selectedCity = _selectedCity;
        }
      });
    } catch (e) {
      print("Error fetching cities: $e");
      setState(() {
        _isLoadingCity = false;
      });
    }
  }

  Future<void> _updateSelection(
      String? country, String? state, String? city) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection("Users").doc(userId).set({
          "updatedAt": DateTime.now(),
          "country": country,
          "state": state,
          "city": city
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("Error updating selection: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Country Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: "Select Country",
          ),
          value: _selectedCountry,
          items: _countries.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != "Select Country") {
              setState(() {
                _selectedCountry = newValue;
                _fetchStates(newValue);
                _updateSelection(newValue, _selectedState, _selectedCity);
              });
            } else {
              setState(() {
                _selectedCountry = null;
                _states = ["Select State"];
                _selectedState = null;
                _cities = ["Select City"];
                _selectedCity = null;
                _updateSelection(null, null, null);
              });
            }
          },
        ),
        const SizedBox(height: 10),

        // State Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: "Select State",
          ),
          value: _selectedState,
          items: _states.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != "Select State") {
              setState(() {
                _selectedState = newValue;
                _fetchCities(_selectedCountry!, newValue);
                _updateSelection(_selectedCountry, newValue, _selectedCity);
              });
            } else {
              setState(() {
                _selectedState = null;
                _cities = ["Select City"];
                _selectedCity = null;
                _updateSelection(_selectedCountry, null, null);
              });
            }
          },
        ),
        const SizedBox(height: 10),

        // City Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: "Select City",
          ),
          value: _selectedCity,
          items: _cities.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != "Select City") {
              setState(() {
                _selectedCity = newValue;
                _updateSelection(_selectedCountry, _selectedState, newValue);
              });
            } else {
              setState(() {
                _selectedCity = null;
                _updateSelection(_selectedCountry, _selectedState, null);
              });
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({Key? key, required this.child}) : super(key: key);

  static void restartApp(BuildContext context) {
    final _RestartWidgetState? state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key =
          UniqueKey(); // Assign a new key to trigger a rebuild of the entire app
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class Utils {
  static void toastMessage(BuildContext context, String title, IconData icon) {
    CherryToast(
      icon: icon,
      animationDuration: const Duration(milliseconds: 600),
      description: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      animationType: AnimationType.fromTop,
      enableIconAnimation: true,
      //action: const Text('Backup data'),
      actionHandler: () {},
      themeColor: primaryBlueColor,
    ).show(context);
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Slide in from the right
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String instituteName;
  final String location;
  final String salary;
  final String description;
  final Icon ico;

  const JobCard({
    Key? key,
    required this.jobTitle,
    required this.instituteName,
    required this.location,
    required this.salary,
    required this.description,
    required this.ico,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailsScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(0),
          child: Card(
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.work,
                    ),
                  ),
                  title: Text(
                    jobTitle,
                  ),
                  subtitle: Text(
                    instituteName,
                  ),
                  trailing: ico,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          _buildBadge("Full-Time"),
                          const SizedBox(width: 8),
                          _buildBadge("Remote"),
                          const SizedBox(width: 8),
                          _buildBadge("Internship"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Clarity.map_marker_solid,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                location,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                salary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildBadge(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      text,
    ),
  );
}

class CommonHeader extends StatelessWidget {
  final String title;

  const CommonHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 30,
            width: 80,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/light-1.png'),
                ),
              ),
            ),
          ),
          Positioned(
            left: 140,
            width: 80,
            height: 150,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/light-2.png'),
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 40,
            width: 80,
            height: 150,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/clock.png'),
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: const EdgeInsets.only(top: 140),
              child: const Column(
                children: [
                  Center(
                    child: Text(
                      "RightWay",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Dubai',
                          fontWeight: FontWeight.w700,
                          fontSize: 60.0),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

































class InformationScreen extends StatelessWidget {
  final String svgString;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const InformationScreen({
    Key? key,
    required this.svgString,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: SvgPicture.string(
                    svgString,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              ErrorInfo(
                title: title,
                description: subtitle,
                buttonText: buttonText,
                onPressed: onButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const ErrorInfo({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16 * 2.5),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  ),
              child: Text(buttonText.toUpperCase()),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}








