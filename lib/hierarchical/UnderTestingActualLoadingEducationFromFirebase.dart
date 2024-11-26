import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roadwise_application/global/style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/chatbot.dart';
import '../screens/showingUniversititesToUser.dart';

final _auth = FirebaseAuth.instance;

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url); // Convert the String to Uri
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

class EducationDropdownScreen extends StatefulWidget {
  const EducationDropdownScreen({Key? key}) : super(key: key);

  @override
  _EducationDropdownScreenState createState() =>
      _EducationDropdownScreenState();
}

class _EducationDropdownScreenState extends State<EducationDropdownScreen> {
  String? selectedCountry;
  String? selectedEducationSystem;
  String? selectedLevel;

  List<String> countries = [];
  List<String> educationSystems = [];
  List<String> levels = [];
  bool loading = false;
  TextEditingController instituteController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

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

  Future<void> saveEducationDetails() async {
    setState(() {
      loading = true;
    });
    if (selectedCountry != null &&
        selectedEducationSystem != null &&
        selectedLevel != null) {
      String nextEducationLevel = getNextEducationLevel(
          int.parse(selectedEducationSystem.toString().split('.').first));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => getNextScreen(
              int.parse(nextEducationLevel.toString().split('.').first)),
        ),
      );
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Educations')
            .doc(_auth.currentUser!.uid)
            .set({
          'country': selectedCountry,
          'educationSystem': selectedEducationSystem,
          'level': selectedLevel,
          'institute': instituteController.text,
          'year': yearController.text,
        });
        setState(() {
          loading = false;
        });
      } catch (e) {
        print("Error saving education details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save details.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
    }
  }

  String getNextEducationLevel(int currentLevel) {
    if (currentLevel >= 1 && currentLevel <= 7) {
      int nextLevel = currentLevel + 1;
      return "$nextLevel. ${educationLevels[nextLevel]}";
    } else {
      return "No further education levels available";
    }
  }

  Map<int, String> educationLevels = {
    1: "Pre-Primary Education",
    2: "Primary Education",
    3: "Middle Education",
    4: "Secondary Education (Matriculation)",
    5: "Higher Secondary Education (Intermediate)",
    6: "Tertiary Education (Undergraduate)",
    7: "Postgraduate Education",
    8: "Technical and Vocational Education"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Recent Degree')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Education Level",
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Class Or Degree",
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        saveEducationDetails();
                      },
                      child: loading
                          ? LoadingAnimationWidget.discreteCircle(
                              color: Colors.white,
                              size: 25,
                            )
                          : const Text('Select'),
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

  Widget getNextScreen(int level) {
    switch (level) {
      case 1:
        return SecondaryScreen();
      case 2:
        return HigherSecondaryScreen();
      case 3:
        return UndergraduateScreen();
      default:
        return Container();
    }
  }
}

class SecondaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SSC")),
      body: const Center(
        child: Text("This Screen will be updated soon."),
      ),
    );
  }
}

class HigherSecondaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HSC")),
      body: const Center(
        child: Text("This Screen will be updated soon."),
      ),
    );
  }
}

class UndergraduateScreen extends StatefulWidget {
  @override
  _UndergraduateScreenState createState() => _UndergraduateScreenState();
}

class _UndergraduateScreenState extends State<UndergraduateScreen> {
  Color backgroundColor = Colors.transparent;
  Timer? blinkTimer;
  bool isBlinking = false;

  bool buttonToTop = false;
  bool isSubfieldHighlighted = true;
  bool isFieldHighlighted = true;
  String? selectedField;
  String? fieldVideoLink;
  String? subfieldVideoLink;

  String? selectedSubfield;
  String? fieldDescription;
  String? fieldImagePath;
  String? subfieldSuggestion;
  String? subfieldImagePath;
  String? subfieldDefinition;
  String? subfieldImportance;
  String? subfieldWhatYouLearn;
  String? subfieldCareerOpportunities;
  String? subfieldSkillsNeeded;
  String? subfieldHowToGetStarted;
  String? subfieldSalaries;

  List<String> currentSubfields = [];
  final List<String> interests = [
    "Computer Science",
    "Business Administration",
    "Engineering",
    "Veterinary Medicine",
    "Fisheries and Aquaculture",
    "Poultry Science",
    "Wildlife Management",
    "Forestry",
    "Bio-Chemistry",
    "Bio-Technology",
    "Food Science and Technology",
    "Law"
  ];

  final Map<String, List<String>> subfields = {
    "Computer Science": [
      "Information Technology",
      "Cyber Security",
      "Data Science",
      "Software Engineering",
      "Computer Systems Engineering",
      "Artificial Intelligence"
    ],
    "Business Administration": ["Business Administration"],
    "Engineering": [
      "Chemical Engineering",
      "Civil Engineering",
      "Electrical Engineering",
      "Electronic Engineering",
      "Environmental Engineering",
      "Industrial and Manufacturing Engineering",
      "Mechanical Engineering",
      "Energy Systems Engineering",
      "Telecommunication Engineering",
      "Building and Architectural Engineering",
      "Biomedical Engineering",
      "Food Engineering Technology",
      "Automation and Control Engineering"
    ],
    "Veterinary Medicine": ["Doctor of Veterinary Medicine (DVM)"],
    "Fisheries and Aquaculture": ["Fisheries & Aquaculture"],
    "Poultry Science": ["Poultry Science"],
    "Wildlife Management": ["Wildlife Management"],
    "Forestry": ["Forestry"],
    "Bio-Chemistry": ["Bio-Chemistry"],
    "Bio-Technology": ["Bio-Technology"],
    "Food Science and Technology": ["Food Science & Technology"],
    "Law": ["Law"]
  };

  void updateDetails(String interest) {
    switch (interest) {
      case "Computer Science":
        fieldDescription =
            "Think about getting a Postgraduate degree in Artificial Intelligence or Machine Learning. These fields are growing fast and offer exciting job opportunities. You could also focus on Software Development to build apps and systems.";
        fieldImagePath = "https://i.ytimg.com/vi/CxGSnA-RTsA/maxresdefault.jpg";
        fieldVideoLink =
            "https://www.youtube.com/watch?v=BILFn9eQOr0&pp=ygUZd2hhdCBpcyBjb21wdXRlciBzY2llbmNlIA%3D%3D";
        break;
      case "Business Administration":
        fieldDescription =
            "You might want to pursue an MBA, which will help you specialize in areas like Marketing, Finance, or Human Resources. This can open doors to leadership positions in many companies.";
        fieldImagePath =
            "https://img.freepik.com/premium-vector/illustration-creative-business-management-background_7505-297.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Engineering":
        fieldDescription =
            "Explore fields such as Civil, Mechanical, or Electrical Engineering. Specializing in these areas allows you to work on innovative technologies and infrastructure.";
        fieldImagePath =
            "https://img.freepik.com/free-photo/two-colleagues-factory_1303-14331.jpg?t=st=1732018022~exp=1732021622~hmac=1103c3443e6547b25a8e5418d040714b7fd641d0ed26239ef4e003ba0de3efb9&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Veterinary Medicine":
        fieldDescription =
            "Consider specializing in animal health, treatment, and care. This field allows you to work with pets, livestock, or wildlife, ensuring their well-being.";
        fieldImagePath =
            "https://img.freepik.com/free-photo/cute-cat-medical-examination-veterinary-clinic-measuring-blood-pressure_613910-21569.jpg?t=st=1732018054~exp=1732021654~hmac=7bea719ef4c8f209a0b091b76d563849e234840963f888fe52d9e972df76d4e4&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Fisheries and Aquaculture":
        fieldDescription =
            "Focus on sustainable fishing practices and aquaculture technology. This field supports food security and the environment.";
        fieldImagePath =
            "https://img.freepik.com/free-vector/fishing-with-net-concept-illustration_114360-15410.jpg?t=st=1732018083~exp=1732021683~hmac=12b4b6b48c1518ada18d8c50c58c420a927939a77933f22467df998f1ce33507&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Poultry Science":
        fieldDescription =
            "Explore specialized studies in poultry farming, nutrition, and genetics. This field is essential for advancing food production and animal health.";
        fieldImagePath =
            "https://img.freepik.com/free-vector/chicken-farm-concept-illustration_114360-10259.jpg?t=st=1732018121~exp=1732021721~hmac=f428766935b735ec139addf6853ebe2276a9efeb0db556a2f8d1d9dc98408082&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Wildlife Management":
        fieldDescription =
            "Look into conservation, habitat management, and research. This field is crucial for protecting wildlife and biodiversity.";
        fieldImagePath =
            "https://img.freepik.com/free-photo/reforestation-done-by-voluntary-group_23-2149500828.jpg?t=st=1732018199~exp=1732021799~hmac=20ece03a6ff9cca15c39d5c3426830683f3f7248e68aa8f883dbe2b709cfc8ce&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Forestry":
        fieldDescription =
            "Specialize in forest conservation, management, and sustainable practices. This helps maintain ecological balance and supports industries reliant on forest resources.";
        fieldImagePath =
            "https://img.freepik.com/premium-photo/beautiful-waterfall-green-forest-oregon-usa_328046-758.jpg?w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Bio-Chemistry":
        fieldDescription =
            "Delve into molecular biology, chemical processes in living organisms, and research that contributes to medical and environmental advances.";
        fieldImagePath =
            "https://img.freepik.com/free-vector/chemistry-science-concept_1284-11674.jpg?t=st=1732018237~exp=1732021837~hmac=a6a319bdd76e928d5e1483a38e05b404914e96de33a124c8e15c7ccd5cf8fefb&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Bio-Technology":
        fieldDescription =
            "Focus on genetic engineering, pharmaceuticals, and innovative technologies that impact health and agriculture.";
        fieldImagePath =
            "https://img.freepik.com/free-vector/technological-ecology-concept-wallpaper_23-2148432195.jpg?t=st=1732018259~exp=1732021859~hmac=5d0d66e1136f6ccce7fb975e1aca3b5ce2be18036d1eda7d49c8b10af1f81ecc&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Food Science and Technology":
        fieldDescription =
            "Study food processing, quality control, and product development to improve nutrition and safety.";
        fieldImagePath =
            "https://uhe.edu.pk/wp-content/uploads/2022/10/mc-foodstv3-banner.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Law":
        fieldDescription =
            "Think about specializing in areas like Corporate Law or Criminal Law. This will help you understand how businesses operate and how to protect people's rights.";
        fieldImagePath =
            "https://img.freepik.com/free-photo/still-life-with-scales-justice_23-2149776027.jpg?t=st=1732018336~exp=1732021936~hmac=0b3fbba30bc5fb7cc596aa6f35f88a6e7cd94422be64bfb54bae73bdbdfd28d1&w=740";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      default:
        fieldDescription = null;
        fieldImagePath = null;
    }
  }

  void updateSubfieldDetails(String subfield) {
    switch (subfield) {
      // Computer Science Subfields
      case "Information Technology":
        subfieldDefinition =
            "Information Technology (IT) is the use of computers and software to manage information.";
        subfieldImportance =
            "IT is essential for businesses to function efficiently and securely in the digital age.";
        subfieldWhatYouLearn =
            "Learn about networks, database management, and IT infrastructure.";
        subfieldCareerOpportunities =
            "Careers include IT manager, network administrator, and systems analyst.";
        subfieldSkillsNeeded =
            "Skills include problem-solving, technical support, and cybersecurity basics.";
        subfieldHowToGetStarted =
            "Start by obtaining a degree in IT or certifications in network management.";
        subfieldSalaries =
            "IT professionals earn between \$70,000 and \$120,000 per year.";
        subfieldImagePath =
            "https://www.mtu.edu/cs/what/images/what-is-computer-science-banner1600.jpg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=OxFgTLsv9gA";
        break;

      case "Cyber Security":
        subfieldDefinition =
            "Cyber Security involves protecting computer systems from digital attacks.";
        subfieldImportance =
            "It's crucial for safeguarding sensitive data and ensuring the integrity of digital systems.";
        subfieldWhatYouLearn =
            "Courses cover network security, ethical hacking, and risk management.";
        subfieldCareerOpportunities =
            "Career options include cybersecurity analyst, penetration tester, and security architect.";
        subfieldSkillsNeeded =
            "Skills include strong analytical thinking, programming, and cryptography.";
        subfieldHowToGetStarted =
            "Begin with cybersecurity courses and certifications like CompTIA Security+.";
        subfieldSalaries =
            "Cybersecurity experts can earn between \$90,000 and \$150,000 annually.";
        subfieldImagePath =
            "https://www.pexels.com/photo/close-up-view-of-system-hacking-5380642/";
        break;

      case "Data Science":
        subfieldDefinition =
            "Data Science is the study of data to extract meaningful insights using various techniques.";
        subfieldImportance =
            "Data science helps drive informed business decisions and predict future trends.";
        subfieldWhatYouLearn =
            "Learn data analysis, machine learning, and big data technologies.";
        subfieldCareerOpportunities =
            "Become a data scientist, data analyst, or business intelligence specialist.";
        subfieldSkillsNeeded =
            "Skills include statistical analysis, programming (Python/R), and data visualization.";
        subfieldHowToGetStarted =
            "Start with a background in statistics and programming, then specialize in data science.";
        subfieldSalaries =
            "Data scientists typically earn \$100,000 to \$140,000 per year.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.linkedin.com%2Fpulse%2Fwho-can-become-data-scientist-akash-jha-n3ahf&psig=AOvVaw03bK4DoVKaFHVETQrWE9tC&ust=1732082559815000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwii3u6-3OeJAxWuf6QEHTWJAqoQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=ua-CiDNNj30";
        break;

      case "Software Engineering":
        subfieldDefinition =
            "Software Engineering is the practice of designing, developing, and maintaining software.";
        subfieldImportance =
            "It is crucial for creating reliable and scalable software systems.";
        subfieldWhatYouLearn =
            "Learn about software design patterns, project management, and coding practices.";
        subfieldCareerOpportunities =
            "Potential jobs include software engineer, developer, or technical lead.";
        subfieldSkillsNeeded =
            "Skills include proficiency in programming languages and problem-solving.";
        subfieldHowToGetStarted =
            "Pursue a degree in computer science or a software engineering bootcamp.";
        subfieldSalaries =
            "Software engineers can earn between \$80,000 and \$130,000 annually.";
        subfieldImagePath =
            "https://images.pexels.com/photos/4050291/pexels-photo-4050291.jpeg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=ZcQyJ-gxke0";
        break;

      case "Computer Systems Engineering":
        subfieldDefinition =
            "Computer Systems Engineering focuses on designing and managing complex computer systems.";
        subfieldImportance =
            "This field integrates hardware and software to optimize system performance.";
        subfieldWhatYouLearn =
            "Learn about hardware architecture, embedded systems, and real-time computing.";
        subfieldCareerOpportunities =
            "Work as a systems engineer, embedded systems developer, or network engineer.";
        subfieldSkillsNeeded =
            "Skills include hardware knowledge, coding, and systems troubleshooting.";
        subfieldHowToGetStarted =
            "Start with an engineering degree focusing on computer systems.";
        subfieldSalaries =
            "Average salaries range from \$90,000 to \$120,000 per year.";
        subfieldImagePath =
            "https://images.pexels.com/photos/4339335/pexels-photo-4339335.jpeg?auto=compress&cs=tinysrgb&w=600";
        subfieldVideoLink = "https://www.youtube.com/watch?v=FZrZ96IAlT4";
        break;

      case "Artificial Intelligence":
        subfieldDefinition =
            "AI is the simulation of human intelligence by machines to perform tasks autonomously.";
        subfieldImportance =
            "AI is reshaping industries by improving efficiency and enabling advanced analytics.";
        subfieldWhatYouLearn =
            "Study neural networks, natural language processing, and deep learning.";
        subfieldCareerOpportunities =
            "Work as an AI researcher, developer, or data scientist.";
        subfieldSkillsNeeded =
            "Skills include programming (Python), data analysis, and knowledge of algorithms.";
        subfieldHowToGetStarted =
            "Start with a degree in computer science and specialize with AI courses.";
        subfieldSalaries =
            "AI professionals can make between \$110,000 and \$150,000 per year.";
        subfieldImagePath =
            "https://images.pexels.com/photos/6153354/pexels-photo-6153354.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
        subfieldVideoLink = "https://www.youtube.com/watch?v=2ePf9rue1Ao";
        break;

      // Law Subfields
      case "Law":
        subfieldDefinition =
            "This program trains students in various areas of law and legal practice.";
        subfieldImportance =
            "Law is critical for maintaining justice and upholding societal regulations.";
        subfieldWhatYouLearn =
            "Study criminal law, civil law, and legal ethics.";
        subfieldCareerOpportunities =
            "Careers include lawyer, legal advisor, and judge.";
        subfieldSkillsNeeded =
            "Skills include critical thinking, strong communication, and argumentation.";
        subfieldHowToGetStarted =
            "Pursue a degree in law followed by passing the bar examination.";
        subfieldSalaries =
            "Lawyers can earn between \$60,000 and \$150,000 or more annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.gaffneyzoppi.com%2Fblog%2Fdifferences-between-corporate-law-and-commercial-law-commercial-law-vs-corporate-law&psig=AOvVaw2egR5lhlyhmLDGYLVhQTw-&ust=1732084879248000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjB1-2Q5eeJAxVVmicCHXIRLa0QjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=anFApfp_KJA";
        break;

      case "Business Administration":
        subfieldDefinition =
            "Business Administration covers the management and operation of business practices.";
        subfieldImportance =
            "This subfield is vital for managing organizations efficiently and promoting business growth.";
        subfieldWhatYouLearn =
            "Learn about marketing, finance, strategic planning, and human resources management.";
        subfieldCareerOpportunities =
            "Careers include business manager, financial analyst, and operations manager.";
        subfieldSkillsNeeded =
            "Skills include leadership, strategic thinking, and financial literacy.";
        subfieldHowToGetStarted =
            "Start by pursuing a bachelor's or MBA in Business Administration.";
        subfieldSalaries =
            "Business administrators can earn between \$60,000 and \$120,000 per year.";
        subfieldImagePath =
            "https://images.pexels.com/photos/7654126/pexels-photo-7654126.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
        subfieldVideoLink = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
        break;

      // Engineering Subfields
      case "Chemical Engineering":
        subfieldDefinition =
            "Chemical Engineering focuses on transforming raw materials into valuable products through chemical processes.";
        subfieldImportance =
            "It is critical for industries like pharmaceuticals, energy, and food production.";
        subfieldWhatYouLearn =
            "Learn about thermodynamics, reaction engineering, and process design.";
        subfieldCareerOpportunities =
            "Careers include chemical engineer, process engineer, and plant operations manager.";
        subfieldSkillsNeeded =
            "Skills include chemical process modeling, thermodynamics, and problem-solving.";
        subfieldHowToGetStarted =
            "Start with a degree in chemical engineering.";
        subfieldSalaries =
            "Chemical engineers typically earn \$70,000 to \$120,000 per year.";
        subfieldImagePath =
            "https://images.pexels.com/photos/8533061/pexels-photo-8533061.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
        subfieldVideoLink = "https://www.youtube.com/watch?v=0w5OBk5w8wI";
        break;

      case "Civil Engineering":
        subfieldDefinition =
            "Civil Engineering involves designing and constructing infrastructure such as roads, bridges, and buildings.";
        subfieldImportance =
            "It plays a crucial role in the development of society and the built environment.";
        subfieldWhatYouLearn =
            "Learn about structural analysis, construction materials, and geotechnical engineering.";
        subfieldCareerOpportunities =
            "Careers include civil engineer, structural engineer, and project manager.";
        subfieldSkillsNeeded =
            "Skills include project management, design software, and material science.";
        subfieldHowToGetStarted = "Start with a degree in civil engineering.";
        subfieldSalaries =
            "Civil engineers typically earn \$60,000 to \$100,000 annually.";
        subfieldImagePath =
            "https://images.pexels.com/photos/585418/pexels-photo-585418.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
        subfieldVideoLink = "https://www.youtube.com/watch?v=J1TxaQ6mDtM";
        break;

      case "Electrical Engineering":
        subfieldDefinition =
            "Electrical Engineering focuses on the study of electrical systems, including power generation and electronics.";
        subfieldImportance =
            "Essential for developing electrical technologies used in everything from power plants to household gadgets.";
        subfieldWhatYouLearn =
            "Learn about circuits, electromagnetism, and power systems.";
        subfieldCareerOpportunities =
            "Careers include electrical engineer, power systems engineer, and circuit designer.";
        subfieldSkillsNeeded =
            "Skills include circuit design, programming, and problem-solving.";
        subfieldHowToGetStarted =
            "Start with a degree in electrical engineering.";
        subfieldSalaries =
            "Electrical engineers earn \$65,000 to \$110,000 annually.";
        subfieldImagePath =
            "https://images.pexels.com/photos/19895867/pexels-photo-19895867/free-photo-of-engineer-standing-among-solar-panels.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2";
        subfieldVideoLink = "https://www.youtube.com/watch?v=1eHdm72Fs9E";
        break;

      case "Electronic Engineering":
        subfieldDefinition =
            "Electronic Engineering focuses on designing and developing electronic systems and devices, such as circuits and microprocessors.";
        subfieldImportance =
            "Crucial for developing technologies like smartphones, computers, and telecommunications systems.";
        subfieldWhatYouLearn =
            "Learn about circuit theory, microelectronics, and signal processing.";
        subfieldCareerOpportunities =
            "Careers include electronics engineer, telecom engineer, and circuit designer.";
        subfieldSkillsNeeded =
            "Skills in circuit design, microelectronics, and digital systems.";
        subfieldHowToGetStarted =
            "Start with a degree in electronic engineering.";
        subfieldSalaries =
            "Electronic engineers earn \$70,000 to \$110,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.uagrantham.edu%2Fblog%2Fwhat-are-the-differences-between-electric-and-electronics-engineering%2F&psig=AOvVaw1NHp_kx4z3U4Eish5EyGgj&ust=1732083556797000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwiL2qGa4OeJAxW7pCcCHWM2JQYQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=zGTVggcl8HI";
        break;

      case "Environmental Engineering":
        subfieldDefinition =
            "Environmental Engineering develops technologies to improve and maintain the health of the environment.";
        subfieldImportance =
            "Vital for reducing pollution, managing waste, and improving water and air quality.";
        subfieldWhatYouLearn =
            "Study waste management, water treatment, and environmental laws.";
        subfieldCareerOpportunities =
            "Careers include environmental consultant, water treatment engineer, and sustainability expert.";
        subfieldSkillsNeeded =
            "Skills include environmental science, problem-solving, and project management.";
        subfieldHowToGetStarted =
            "Start with a degree in environmental engineering.";
        subfieldSalaries =
            "Environmental engineers earn \$60,000 to \$100,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fbeccinc.com%2F2024%2F04%2F24%2Fthe-future-of-environmental-engineering%2F&psig=AOvVaw0vqzNk0W1IIVnpUA83Y5Rx&ust=1732083622957000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCOjtsb_g54kDFQAAAAAdAAAAABAD";
        subfieldVideoLink = "https://www.youtube.com/watch?v=RJv9e4Xf1mA";
        break;

      case "Industrial and Manufacturing Engineering":
        subfieldDefinition =
            "This field focuses on optimizing complex processes, systems, and organizations in manufacturing industries.";
        subfieldImportance =
            "Critical for improving production efficiency, reducing waste, and ensuring quality control.";
        subfieldWhatYouLearn =
            "Learn about supply chain management, process optimization, and industrial automation.";
        subfieldCareerOpportunities =
            "Careers include industrial engineer, manufacturing manager, and supply chain consultant.";
        subfieldSkillsNeeded =
            "Skills include process optimization, logistics, and systems analysis.";
        subfieldHowToGetStarted =
            "Start with a degree in industrial engineering.";
        subfieldSalaries =
            "Industrial engineers earn \$60,000 to \$90,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.workbc.ca%2Fcareer-profiles%2Findustrial-and-manufacturing-engineers&psig=AOvVaw38GezLBqj3pnkUnEVVGPBL&ust=1732083679936000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjUwf3U4OeJAxWGnCcCHZjzNvQQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=0uXlVg3e70A";
        break;

      case "Mechanical Engineering":
        subfieldDefinition =
            "Mechanical Engineering is the design and manufacturing of mechanical systems, from engines to machines.";
        subfieldImportance =
            "Key to a wide range of industries, from automotive to robotics.";
        subfieldWhatYouLearn =
            "Study thermodynamics, machine design, and materials science.";
        subfieldCareerOpportunities =
            "Careers include mechanical engineer, product designer, and manufacturing manager.";
        subfieldSkillsNeeded =
            "Skills in CAD, materials science, and thermodynamics.";
        subfieldHowToGetStarted =
            "Start with a degree in mechanical engineering.";
        subfieldSalaries =
            "Mechanical engineers earn \$65,000 to \$95,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.expatrio.com%2Fabout-germany%2Fstudy-mechanical-engineering-in-germany&psig=AOvVaw0kYi8ydbrj99OclQBIaV4u&ust=1732083726779000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwijyajr4OeJAxVqnycCHdzXJ9UQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=G2u3eZfNkYQ";
        break;

      case "Energy Systems Engineering":
        subfieldDefinition =
            "Energy Systems Engineering focuses on the efficient production, distribution, and use of energy resources.";
        subfieldImportance =
            "Critical for sustainability and addressing energy challenges worldwide.";
        subfieldWhatYouLearn =
            "Learn about energy production, renewable energy systems, and energy efficiency techniques.";
        subfieldCareerOpportunities =
            "Careers include energy systems engineer, renewable energy consultant, and energy analyst.";
        subfieldSkillsNeeded =
            "Skills include thermodynamics, energy modeling, and knowledge of renewable technologies.";
        subfieldHowToGetStarted =
            "Start with a degree in energy systems engineering or mechanical engineering with a focus on energy.";
        subfieldSalaries =
            "Energy engineers earn \$70,000 to \$100,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fbmcchemeng.biomedcentral.com%2Farticles%2F10.1186%2Fs42480-019-0009-5&psig=AOvVaw2GskeXBTXdGKNbp3m08ce6&ust=1732083789656000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwj-pKaJ4eeJAxVrsScCHbuPB10QjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=7hbzzwpNjJ8";
        break;

      case "Telecommunication Engineering":
        subfieldDefinition =
            "Telecommunication Engineering deals with the transmission of information across channels like fiber optics and wireless networks.";
        subfieldImportance =
            "Important for communication technologies like mobile networks and satellite systems.";
        subfieldWhatYouLearn =
            "Study network design, wireless communication, and signal processing.";
        subfieldCareerOpportunities =
            "Careers include telecom engineer, network designer, and communications systems manager.";
        subfieldSkillsNeeded =
            "Skills include networking, digital communications, and signal analysis.";
        subfieldHowToGetStarted =
            "Start with a degree in telecommunications engineering.";
        subfieldSalaries =
            "Telecommunication engineers earn \$60,000 to \$100,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.fieldengineer.com%2Fskills%2Fwhat-is-a-telecom-engineer&psig=AOvVaw13mLLFMr8ioYDMm6E8N_yX&ust=1732083825712000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwij_L6a4eeJAxWkBPsDHbg4Ge8QjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=0clMih4XnH4";
        break;

      case "Building and Architectural Engineering":
        subfieldDefinition =
            "This subfield involves designing and constructing buildings and structures with an emphasis on architectural functionality.";
        subfieldImportance =
            "Essential for creating safe, functional, and sustainable buildings.";
        subfieldWhatYouLearn =
            "Learn about structural design, construction materials, and environmental impact.";
        subfieldCareerOpportunities =
            "Careers include building engineer, architect, and construction manager.";
        subfieldSkillsNeeded =
            "Skills include architecture, engineering design, and project management.";
        subfieldHowToGetStarted =
            "Start with a degree in architectural or civil engineering.";
        subfieldSalaries =
            "Building engineers earn \$50,000 to \$85,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstudyline.net%2Fen%2Fprojects%2Fspecialists%2Farchitectural-engineering%2F&psig=AOvVaw0Q17IvIult1vGLa-AJ-kY1&ust=1732083864639000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwiG7Yat4eeJAxWMnycCHTmnCi8QjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=OQh02sblQd8";
        break;

      case "Biomedical Engineering":
        subfieldDefinition =
            "Biomedical Engineering combines principles of engineering with biological sciences to develop technologies for healthcare.";
        subfieldImportance =
            "Critical for advancing medical devices, diagnostic tools, and healthcare technologies.";
        subfieldWhatYouLearn =
            "Study medical devices, biomaterials, and biomechanics.";
        subfieldCareerOpportunities =
            "Careers include biomedical engineer, medical device designer, and clinical engineer.";
        subfieldSkillsNeeded =
            "Skills include biomechanics, medical technologies, and systems design.";
        subfieldHowToGetStarted =
            "Start with a degree in biomedical engineering.";
        subfieldSalaries =
            "Biomedical engineers earn \$65,000 to \$100,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Feambes.org%2Fbiomedical-engineering%2F&psig=AOvVaw1U_rmXwifLATVClqyCo8Q0&ust=1732083914675000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwj66fTE4eeJAxWLgCcCHdFJIXYQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=lL-x5rNKY2g";
        break;

      case "Food Engineering Technology":
        subfieldDefinition =
            "Food Engineering Technology applies engineering principles to food production, preservation, and packaging.";
        subfieldImportance =
            "Crucial for enhancing food safety, efficiency, and quality in food industries.";
        subfieldWhatYouLearn =
            "Learn about food process engineering, packaging, and quality control.";
        subfieldCareerOpportunities =
            "Careers include food engineer, quality control specialist, and packaging engineer.";
        subfieldSkillsNeeded =
            "Skills in food safety, materials science, and process design.";
        subfieldHowToGetStarted =
            "Start with a degree in food engineering or food science.";
        subfieldSalaries = "Food engineers earn \$55,000 to \$85,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fkahedu.edu.in%2Ffood-science-and-nutrition-vs-food-technology%2F&psig=AOvVaw3o-sTVp8hl2B_Kcn3u9roZ&ust=1732083985135000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwj8scHm4eeJAxVapicCHfXfDMIQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=fdoZVrL8-Ow";
        break;

      case "Automation and Control Engineering":
        subfieldDefinition =
            "Automation and Control Engineering focuses on the design and operation of systems that control industrial processes.";
        subfieldImportance =
            "Crucial for increasing productivity, efficiency, and safety in manufacturing and industry.";
        subfieldWhatYouLearn =
            "Study control systems, robotics, and process automation.";
        subfieldCareerOpportunities =
            "Careers include automation engineer, control systems engineer, and robotics expert.";
        subfieldSkillsNeeded =
            "Skills in control systems, programming, and mechanical design.";
        subfieldHowToGetStarted =
            "Start with a degree in automation or electrical engineering.";
        subfieldSalaries =
            "Automation engineers earn \$70,000 to \$110,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.linkedin.com%2Fpulse%2Fwhat-control-automation-engineering-timerni&psig=AOvVaw3IS_ZMN8CJEFeyhPpvVrVB&ust=1732084024370000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwiFi5z54eeJAxV8fqQEHQqjD38QjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=Yhs3rJfUoOk";
        break;

      // Add more cases for other engineering subfields following the same structure.

      // Veterinary Medicine Subfields
      case "Doctor of Veterinary Medicine (DVM)":
        subfieldDefinition =
            "This program trains professionals to diagnose and treat animal health issues.";
        subfieldImportance =
            "Veterinary medicine is crucial for animal welfare and zoonotic disease control.";
        subfieldWhatYouLearn =
            "Learn about animal anatomy, pathology, and clinical practices.";
        subfieldCareerOpportunities =
            "Careers include veterinarian, animal researcher, and veterinary technician.";
        subfieldSkillsNeeded =
            "Skills include animal care, medical knowledge, and strong communication.";
        subfieldHowToGetStarted =
            "Pursue a Doctor of Veterinary Medicine (DVM) degree.";
        subfieldSalaries =
            "Veterinarians typically earn \$80,000 to \$120,000 per year.";
        subfieldImagePath =
            "https://www.millenniumpost.in/h-upload/2023/09/06/728639-veterinarymarketingstrategies823.webp";
        subfieldVideoLink = "https://www.youtube.com/watch?v=x8iVE-4XQIw";
        break;

      // Fisheries and Aquaculture Subfields
      case "Fisheries & Aquaculture":
        subfieldDefinition =
            "This subfield focuses on fish farming, breeding, and sustainable practices.";
        subfieldImportance =
            "It's essential for maintaining global food security and sustainable fishery management.";
        subfieldWhatYouLearn =
            "Study aquaculture techniques, marine biology, and environmental management.";
        subfieldCareerOpportunities =
            "Careers include aquaculture manager, marine biologist, and fisheries officer.";
        subfieldSkillsNeeded =
            "Skills include biology, environmental science, and management.";
        subfieldHowToGetStarted =
            "Start with a degree in fisheries science or aquaculture.";
        subfieldSalaries =
            "Professionals in this field can earn between \$50,000 and \$90,000 per year.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.fao.org%2Fclimate-change%2Fprojects-and-programmes%2Fproject-detail%2Ffisheries-and-aquaculture-and-climate-change%2Fen&psig=AOvVaw3VfPQTmGLJKxZyVim_21nh&ust=1732084225452000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjNko3Z4ueJAxXCpicCHWDQD6oQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=L0QACbYnZT4";
        break;

      // Poultry Science Subfields
      case "Poultry Science":
        subfieldDefinition =
            "Poultry Science involves studying the production and health of poultry.";
        subfieldImportance =
            "It supports efficient poultry farming, crucial for meeting protein demands.";
        subfieldWhatYouLearn =
            "Courses cover nutrition, genetics, and disease prevention in poultry.";
        subfieldCareerOpportunities =
            "Work as a poultry scientist, farm manager, or animal health consultant.";
        subfieldSkillsNeeded =
            "Skills include animal husbandry, biology, and data analysis.";
        subfieldHowToGetStarted =
            "Begin with a degree in animal or poultry science.";
        subfieldSalaries =
            "Salaries typically range from \$50,000 to \$80,000 annually.";
        subfieldImagePath =
            "https://research.uga.edu/news/wp-content/uploads/sites/19/2024/09/lilong-chai.jpg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=QaYTs8eEprQ";
        break;

      // Wildlife Management Subfields
      case "Wildlife Management":
        subfieldDefinition =
            "Wildlife Management focuses on the conservation and management of wild species.";
        subfieldImportance =
            "This field is vital for biodiversity and ecosystem balance.";
        subfieldWhatYouLearn =
            "Learn habitat management, conservation strategies, and ecological studies.";
        subfieldCareerOpportunities =
            "Careers include wildlife biologist, conservation officer, and park ranger.";
        subfieldSkillsNeeded =
            "Skills include ecological knowledge, fieldwork, and data analysis.";
        subfieldHowToGetStarted =
            "Pursue a degree in wildlife management or environmental science.";
        subfieldSalaries =
            "Professionals typically earn between \$45,000 and \$85,000 per year.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fresponsivemanagement.com%2Fresearch-topics%2Fwildlife-management-habitat-and-conservation%2F&psig=AOvVaw1TLvGUOGSFfbgavcnnF281&ust=1732084391742000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjr1rKo4-eJAxXSgycCHWV-OoQQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=JlcxH64ijmw";
        break;

      // Forestry Subfields
      case "Forestry":
        subfieldDefinition =
            "Forestry involves managing and conserving forests and forest ecosystems.";
        subfieldImportance =
            "It's crucial for sustainable resource management and combating deforestation.";
        subfieldWhatYouLearn =
            "Study tree biology, forest ecology, and resource management techniques.";
        subfieldCareerOpportunities =
            "Careers include forest manager, conservation scientist, and forester.";
        subfieldSkillsNeeded =
            "Skills include biology, environmental awareness, and management.";
        subfieldHowToGetStarted =
            "Start with a degree in forestry or environmental science.";
        subfieldSalaries =
            "Forestry professionals can earn \$50,000 to \$90,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FForestry&psig=AOvVaw2NELAbm9g7ZIwX-ydVyj_k&ust=1732084437337000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwj0zJG-4-eJAxUhgScCHRGoPQYQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=JZZjlQAKbU4";
        break;

      // Bio-Chemistry Subfields
      case "Bio-Chemistry":
        subfieldDefinition =
            "Bio-Chemistry explores the chemical processes within and related to living organisms.";
        subfieldImportance =
            "It's essential for advances in medical research, agriculture, and environmental science.";
        subfieldWhatYouLearn =
            "Study molecular biology, chemical reactions, and enzyme functions.";
        subfieldCareerOpportunities =
            "Careers include biochemist, research scientist, and pharmaceutical specialist.";
        subfieldSkillsNeeded =
            "Skills include laboratory techniques, critical thinking, and data analysis.";
        subfieldHowToGetStarted =
            "Pursue a degree in biochemistry or related biological sciences.";
        subfieldSalaries =
            "Biochemists typically earn between \$60,000 and \$110,000 annually.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ox.ac.uk%2Fadmissions%2Fundergraduate%2Fcourses%2Fcourse-listing%2Fbiochemistry-molecular-and-cellular&psig=AOvVaw3IxWOYs_4TzZtDs3z-nde8&ust=1732084720372000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwjM1ozF5OeJAxVapicCHfXfDMIQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=8e0z3-iZ_TY";
        break;

      // Bio-Technology Subfields
      case "Bio-Technology":
        subfieldDefinition =
            "Bio-Technology applies biological systems and organisms to develop new technologies and products.";
        subfieldImportance =
            "It plays a critical role in health, agriculture, and industrial processes.";
        subfieldWhatYouLearn =
            "Learn about genetic engineering, bioprocessing, and bioinformatics.";
        subfieldCareerOpportunities =
            "Careers include biotechnologist, research scientist, and bio-manufacturing specialist.";
        subfieldSkillsNeeded =
            "Skills include biology, technology integration, and research skills.";
        subfieldHowToGetStarted =
            "Start with a degree in biotechnology or a related field.";
        subfieldSalaries =
            "Biotechnologists typically earn between \$60,000 and \$120,000 per year.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fgenflowbio.com%2Fwhat-is-biotechnology%2F&psig=AOvVaw2Ykgso3DJD6l_eru8F47ab&ust=1732084776670000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwi17Pjf5OeJAxV8fqQEHQqjD38QjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=L_ZftNXFl-M";
        break;

      // Food Science and Technology Subfields
      case "Food Science & Technology":
        subfieldDefinition =
            "This field studies the physical, biological, and chemical makeup of food.";
        subfieldImportance =
            "Essential for ensuring food safety, quality, and innovation in food production.";
        subfieldWhatYouLearn =
            "Courses include food chemistry, microbiology, and food processing techniques.";
        subfieldCareerOpportunities =
            "Work as a food scientist, quality assurance specialist, or product developer.";
        subfieldSkillsNeeded =
            "Skills include lab work, chemistry, and problem-solving.";
        subfieldHowToGetStarted =
            "Begin with a degree in food science or related disciplines.";
        subfieldSalaries =
            "Food scientists typically earn between \$50,000 and \$100,000 per year.";
        subfieldImagePath =
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.linkedin.com%2Fpulse%2Fhow-career-food-science-technology-can-change-your-life-&psig=AOvVaw0toINYJ1ungfcdT1Ym8R8u&ust=1732084837186000&source=images&cd=vfe&opi=89978449&ved=2ahUKEwits-b85OeJAxXBmycCHRMrBUIQjRx6BAgAEBk";
        subfieldVideoLink = "https://www.youtube.com/watch?v=7kZuElnUAGY";
        break;

      default:
        subfieldDefinition = null;
        subfieldImportance = null;
        subfieldWhatYouLearn = null;
        subfieldCareerOpportunities = null;
        subfieldSkillsNeeded = null;
        subfieldHowToGetStarted = null;
        subfieldSalaries = null;
        subfieldImagePath = null;
        subfieldVideoLink = null;
        fieldVideoLink = null;
    }
  }

  void updateSubfields(String interest) {
    setState(() {
      currentSubfields = subfields[interest] ?? [];
      selectedSubfield = null;
      subfieldDefinition = null;
      subfieldImagePath = null;
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scrollToTop(ScrollController controller) {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      buttonToTop = false;
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      600,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
    setState(() {
      buttonToTop = true;
    });
  }

  void highlightField() {
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        isFieldHighlighted = false;
      });
    });
    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        isFieldHighlighted = true;
      });
    });
    Timer(const Duration(milliseconds: 1200), () {
      setState(() {
        isFieldHighlighted = false;
      });
    });
    Timer(const Duration(milliseconds: 14000), () {
      setState(() {
        isFieldHighlighted = false;
      });
    });
    Timer(const Duration(milliseconds: 1600), () {
      setState(() {
        isFieldHighlighted = true;
      });
    });
    Timer(const Duration(milliseconds: 1800), () {
      setState(() {
        isFieldHighlighted = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    highlightField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Undergraduate Education")),
      floatingActionButton: buttonToTop
          ? FloatingActionButton(
              onPressed: () {
                scrollToTop(_scrollController);
              },
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(child: Chatbot()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Find your Interest with our ChatBot"),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/8943/8943377.png',
                          height: 30,
                          width: 30,
                        ),
                      ],
                    )),
              ),
              const Center(child: Text("OR")),
              const SizedBox(height: 20),
              ListTile(
                tileColor:
                    isFieldHighlighted ? Colors.blue : Colors.transparent,
                title: const Text("Choose a Field",
                    style: TextStyle(fontSize: 20)),
                trailing: DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  value: selectedField,
                  hint: const Text("Select your interest"),
                  onTap: () {
                    setState(() {
                      selectedField = null;
                      selectedSubfield = null;
                    });
                  },
                  items: interests.map((String interest) {
                    return DropdownMenuItem<String>(
                      value: interest,
                      child: Text(interest),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedField = newValue;
                      updateDetails(newValue!);
                      updateSubfields(newValue);
                      buttonToTop = false;
                      Timer(const Duration(milliseconds: 1100), () {
                        setState(() {
                          isSubfieldHighlighted = false;
                        });
                      });
                      Timer(const Duration(milliseconds: 1200), () {
                        setState(() {
                          isSubfieldHighlighted = true;
                        });
                      });
                      Timer(const Duration(milliseconds: 1400), () {
                        setState(() {
                          isSubfieldHighlighted = false;
                        });
                      });
                      Timer(const Duration(milliseconds: 1800), () {
                        setState(() {
                          isSubfieldHighlighted = false;
                        });
                      });
                      Timer(const Duration(milliseconds: 2000), () {
                        setState(() {
                          isSubfieldHighlighted = true;
                        });
                      });
                      Timer(const Duration(milliseconds: 2200), () {
                        setState(() {
                          isSubfieldHighlighted = false;
                        });
                      });
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (selectedField != null)
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8)),
                                    child: Image.network(
                                      fieldImagePath ?? "",
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  Positioned(
                                      top: 8,
                                      right: 8,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red.withOpacity(0.7)),
                                        ),
                                        onPressed: () async {
                                          _launchURL(fieldVideoLink!);
                                        },
                                        child: const Icon(Icons.play_circle),
                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "What is $selectedField?",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      fieldDescription ?? "Still Not Updated",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child: ListTile(
                          tileColor: isSubfieldHighlighted
                              ? Colors.blue
                              : Colors.transparent,
                          title: const Text(
                            "Choose a SubField",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: DropdownButton<String>(
                            underline: const SizedBox.shrink(),
                            value: selectedSubfield,
                            hint: const Text("Subfields"),
                            items: currentSubfields.map((String subfield) {
                              return DropdownMenuItem<String>(
                                value: subfield,
                                child: Text(subfield),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedSubfield = newValue;
                                updateSubfieldDetails(newValue!);
                              });
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                scrollToBottom();
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              if (selectedSubfield != null) ...[
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                child: Image.network(
                                  subfieldImagePath ?? "",
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.red.withOpacity(0.7)),
                                  ),
                                  onPressed: () async {
                                    _launchURL(subfieldVideoLink!);
                                  },
                                  child: const Icon(Icons.play_circle),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What is $selectedSubfield?",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldDefinition ?? "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Importance of $selectedSubfield",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldImportance ?? "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "What You Learn",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldWhatYouLearn ?? "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Career Opportunities",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldCareerOpportunities ??
                                      "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Skills Needed",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldSkillsNeeded ?? "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Salaries",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldSalaries ?? "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "How to Get Started",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subfieldHowToGetStarted ??
                                      "Still Not Updated",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CustomPageRoute(
                                            child: UniversitiesScreen(
                                                heading: selectedSubfield
                                                    .toString())),
                                      );
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Find Institute"),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(Icons.arrow_right),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

/*
class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}


class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webViewController;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView"),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl:  widget.url,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageStarted: (WebViewController webViewController, String? url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (WebViewController webViewController, String? url) {
              setState(() {
                _isLoading = false;
              });

            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Black background with opacity
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
*/
