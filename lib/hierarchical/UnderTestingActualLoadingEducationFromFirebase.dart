import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roadwise_application/global/style.dart';

final _auth = FirebaseAuth.instance;
class EducationDropdownScreen extends StatefulWidget {


  const EducationDropdownScreen({required});

  @override
  _EducationDropdownScreenState createState() => _EducationDropdownScreenState();
}

class _EducationDropdownScreenState extends State<EducationDropdownScreen> {
  String? selectedCountry;
  String? selectedEducationSystem;
  String? selectedLevel;

  List<String> countries = [];
  List<String> educationSystems = [];
  List<String> levels = [];

  TextEditingController instituteController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  // Load all countries
  Future<void> loadCountries() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('countries').get();
      setState(() {
        countries = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print("Error loading countries: $e");
    }
  }

  // Load education systems based on selected country
  Future<void> loadEducationSystems(String country) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(country)
          .collection('educationSystem')
          .get();

      setState(() {
        educationSystems = snapshot.docs.map((doc) => doc.id).toList();
        selectedEducationSystem = null;
        levels = [];
      });
    } catch (e) {
      print("Error loading education systems: $e");
    }
  }

  // Load levels based on selected education system
  Future<void> loadLevels(String country, String educationSystem) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(country)
          .collection('educationSystem')
          .doc(educationSystem)
          .collection('Levels')
          .get();

      setState(() {
        levels = snapshot.docs.map((doc) => doc.id).toList();
        selectedLevel = null;
      });
    } catch (e) {
      print("Error loading levels: $e");
    }
  }

  // Save education details to Firestore
  Future<void> saveEducationDetails() async {
    if (selectedCountry != null && selectedEducationSystem != null && selectedLevel != null &&
        instituteController.text.isNotEmpty && yearController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Educations')
            .add({
          'country': selectedCountry,
          'educationSystem': selectedEducationSystem,
          'level': selectedLevel,
          'institute': instituteController.text,
          'year': yearController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Education details saved!')));
      } catch (e) {
        print("Error saving education details: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save details.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Education System')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Country Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Country",
                  border: OutlineInputBorder(),
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
                    selectedEducationSystem = null;
                    selectedLevel = null;
                    educationSystems = [];
                    levels = [];
                  });
                  loadEducationSystems(value!);
                },
              ),
              const SizedBox(height: 16),

              // Education System Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Education System",
                  border: OutlineInputBorder(),
                ),
                value: selectedEducationSystem,
                items: educationSystems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedEducationSystem = value;
                      selectedLevel = null;
                      levels = [];
                    });
                    loadLevels(selectedCountry!, value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Levels Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Level",
                  border: OutlineInputBorder(),
                ),
                value: selectedLevel,
                items: levels.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLevel = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Institute Name TextField
              TextFormField(
                controller: instituteController,
                decoration: const InputDecoration(
                  labelText: "Institute Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Year TextField
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Save Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          CustomPageRoute(child:  HierarchyDiagramScreen()),
                        );
                      },
                      //onPressed: saveEducationDetails,
                      child: const Text('Save Education Details'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}








class CountryStateCityDropdown extends StatefulWidget {
  @override
  _CountryStateCityDropdownState createState() =>
      _CountryStateCityDropdownState();
}

class _CountryStateCityDropdownState extends State<CountryStateCityDropdown> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  // Load countries from Firestore
  Future<void> loadCountries() async {
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

  // Load states based on selected country
  Future<void> loadStates(String country) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('countries')
          .doc(country)
          .collection('states')
          .get();

      setState(() {
        states = snapshot.docs.map((doc) => doc.id).toList();
        selectedState = null;
        cities = [];
      });
    } catch (e) {
      print("Error loading states: $e");
    }
  }

  // Load cities based on selected state
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
        selectedCity = null;
      });
    } catch (e) {
      print("Error loading cities: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Country",
                border: OutlineInputBorder(),
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
                loadStates(value!);
              },
            ),
            const SizedBox(height: 16),

            // State Dropdown
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
                if (value != null) {
                  setState(() {
                    selectedState = value;
                    selectedCity = null;
                    cities = [];
                  });
                  loadCities(selectedCountry!, value);
                }
              },
            ),
            const SizedBox(height: 16),

            // City Dropdown
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
                if (value != null) {
                  setState(() {
                    selectedCity = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



class HierarchyDiagramScreen extends StatelessWidget {
  final List<Node> nodes = [
    Node(title: 'Top Level', children: [
      Node(title: "title"),
      Node(title: "title"),
      Node(title: "title"),
      Node(title: "title"),
      Node(title: 'Second Level 1', children: [
        Node(title: 'Third Level 1'),
        Node(title: 'Third Level 2'),
      ]),
      Node(title: 'Second Level 2', children: [
        Node(title: 'Third Level 3'),
        Node(title: 'Third Level 4'),
      ]),
    ])
  ];

  HierarchyDiagramScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hierarchy Diagram")),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(50),
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 2.0,
          child: SingleChildScrollView(
            child: CustomPaint(
              size: const Size(2000, 1000),
              painter: HierarchyPainter(nodes),
            ),
          ),
        ),
      ),
    );
  }
}

class Node {
  final String title;
  final List<Node> children;

  Node({required this.title, this.children = const []});
}

class HierarchyPainter extends CustomPainter {
  final List<Node> nodes;
  final double boxWidth = 100;
  final double boxHeight = 40;
  final double verticalSpacing = 60;
  final double horizontalSpacing = 30;

  HierarchyPainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    _drawNode(canvas, nodes[0], size.width / 2 - boxWidth / 2, 20, linePaint);
  }

  void _drawNode(Canvas canvas, Node node, double x, double y, Paint linePaint) {
    final textPainter = TextPainter(
      text: TextSpan(text: node.title, style: const TextStyle(color: Colors.black)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: boxWidth);

    // Draw box
    final rect = Rect.fromLTWH(x, y, boxWidth, boxHeight);
    final Paint boxPaint = Paint()..color = Colors.lightBlueAccent;
    canvas.drawRect(rect, boxPaint);

    // Draw text
    final offset = Offset(x + (boxWidth - textPainter.width) / 2, y + (boxHeight - textPainter.height) / 2);
    textPainter.paint(canvas, offset);

    if (node.children.isNotEmpty) {
      final childY = y + boxHeight + verticalSpacing;
      final childXStart = x - (node.children.length - 1) * (boxWidth + horizontalSpacing) / 2;

      for (int i = 0; i < node.children.length; i++) {
        final childX = childXStart + i * (boxWidth + horizontalSpacing);

        // Draw line connecting parent and child
        canvas.drawLine(Offset(x + boxWidth / 2, y + boxHeight), Offset(childX + boxWidth / 2, childY), linePaint);

        _drawNode(canvas, node.children[i], childX, childY, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
