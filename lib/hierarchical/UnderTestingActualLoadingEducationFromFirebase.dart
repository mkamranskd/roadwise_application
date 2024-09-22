import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

final _auth = FirebaseAuth.instance;

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
        selectedLevel != null &&
        instituteController.text.isNotEmpty &&
        yearController.text.isNotEmpty) {
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
              TextFormField(
                controller: instituteController,
                decoration: const InputDecoration(
                  labelText: "From Institute Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(
                  labelText: "In Year",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        saveEducationDetails();
                      },
                      child: loading
                          ? LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 25,
                      )
                          :const Text('Select'),
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
        return PrePrimaryScreen();
      case 2:
        return PrimaryScreen();
      case 3:
        return MiddleScreen();
      case 4:
        return SecondaryScreen();
      case 5:
        return HigherSecondaryScreen();
      case 6:
        return UndergraduateScreen();
      case 7:
        return PostgraduateScreen();
      case 8:
        return TechnicalVocationalScreen();
      default:
        return Container();
    }
  }
}

class PrePrimaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PrePrimaryScreen Education")),
      body: const Center(
        child: Text("Details for PrePrimaryScreen Education."),
      ),
    );
  }
}

class PrimaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PrimaryScreen Education")),
      body: const Center(
        child: Text("Details for PrimaryScreen Education."),
      ),
    );
  }
}

class MiddleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MiddleScreen Education")),
      body: const Center(
        child: Text("Details for MiddleScreen Education."),
      ),
    );
  }
}

class SecondaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SecondaryScreen Education")),
      body: const Center(
        child: Text("Details for SecondaryScreen Education."),
      ),
    );
  }
}

class HigherSecondaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HigherSecondaryScreen Education")),
      body: const Center(
        child: Text("Details for HigherSecondaryScreen Education."),
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
    "Mechanical Engineering",
    "Medical Science",
    "Law",
    "Arts and Humanities"
  ];

  final Map<String, List<String>> subfields = {
    "Computer Science": [
      "Artificial Intelligence",
      "Machine Learning",
      "Cyber Security",
      "Data Science"
    ],
    "Business Administration": [
      "Marketing",
      "Finance",
      "Human Resources",
      "Operations Management"
    ],
    "Mechanical Engineering": [
      "Robotics",
      "Automobile",
      "Aerospace",
      "Energy Systems"
    ],
    "Medical Science": ["Physical Therapy", "Nursing", "Pharmacy"],
    "Law": [
      "Criminal Law",
      "Corporate Law",
      "Constitutional Law",
      "Family Law"
    ],
    "Arts and Humanities": ["Literature", "History", "Philosophy"]
  };

  void updateDetails(String interest) {
    switch (interest) {
      case "Computer Science":
        fieldDescription =
            "Think about getting a Postgraduate degree in Artificial Intelligence or Machine Learning. These fields are growing fast and offer exciting job opportunities. You could also focus on Software Development to build apps and systems.";
        fieldImagePath = "assets/profiles/cs.jpg";
        fieldVideoLink =
            "https://www.youtube.com/watch?v=BILFn9eQOr0&pp=ygUZd2hhdCBpcyBjb21wdXRlciBzY2llbmNlIA%3D%3D";
        break;
      case "Business Administration":
        fieldDescription =
            "You might want to pursue an MBA, which will help you specialize in areas like Marketing, Finance, or Human Resources. This can open doors to leadership positions in many companies.";
        fieldImagePath = "assets/profiles/ba.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Mechanical Engineering":
        fieldDescription =
            "Consider exploring advanced fields like Robotics or Energy Systems. These areas are important for developing new technologies and improving how we use energy in our world.";
        fieldImagePath = "assets/profiles/me.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Medical Science":
        fieldDescription =
            "Look into specializations like Public Health, Nursing, or advanced Pharmacy degrees. These fields are crucial for helping people and improving healthcare systems.";
        fieldImagePath = "assets/profiles/ms.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Law":
        fieldDescription =
            "Think about specializing in areas like Corporate Law or Criminal Law. This will help you understand how businesses operate and how to protect people's rights.";
        fieldImagePath = "assets/profiles/l.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        break;
      case "Arts and Humanities":
        fieldDescription =
            "Consider pursuing a master's degree in subjects like Literature, Graphic Design, or History. These areas allow you to express your creativity and understand cultures better.";
        fieldImagePath = "assets/profiles/aah.jpg";
        fieldVideoLink = "https://www.youtube.com/";
        subfieldVideoLink = "https://www.youtube.com/";
        break;
      default:
        fieldDescription = null;
        fieldImagePath = null;
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

  void updateSubfieldDetails(String subfield) {
    switch (subfield) {
      // Computer Science Subfields
      case "Artificial Intelligence":
        subfieldDefinition =
            "Artificial Intelligence (AI) is the simulation of human intelligence in machines that are programmed to think and learn.";
        subfieldImportance =
            "AI is crucial as it enhances productivity and efficiency across various industries, from healthcare to finance.";
        subfieldWhatYouLearn =
            "In AI, you learn about algorithms, data analysis, and machine learning techniques.";
        subfieldCareerOpportunities =
            "Graduates can work as AI engineers, data scientists, or machine learning specialists.";
        subfieldSkillsNeeded =
            "Essential skills include programming, mathematical reasoning, and problem-solving.";
        subfieldHowToGetStarted =
            "Begin with online courses or degrees in computer science and AI specialization.";
        subfieldSalaries =
            "AI specialists can earn an average salary of \$100,000 to \$150,000 per year.";
        subfieldImagePath = "assets/subfields/ai.jpg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=Yq0QkCxoTHM";
        break;

      case "Machine Learning":
        subfieldDefinition =
            "Machine Learning (ML) is a subset of AI that enables systems to learn and improve from experience without being explicitly programmed.";
        subfieldImportance =
            "ML is vital for automating decision-making processes and analyzing large datasets, leading to informed insights.";
        subfieldWhatYouLearn =
            "Students learn about statistical methods, algorithms, and data modeling.";
        subfieldCareerOpportunities =
            "Potential careers include machine learning engineer, data analyst, and research scientist.";
        subfieldSkillsNeeded =
            "Skills include programming, statistical analysis, and strong analytical abilities.";
        subfieldHowToGetStarted =
            "Start with introductory courses in statistics and programming languages like Python.";
        subfieldSalaries =
            "Machine learning engineers typically earn between \$110,000 and \$160,000 annually.";
        subfieldImagePath = "assets/subfields/ml.jpg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=bk12t0Xz5FM";
        break;

      case "Cyber Security":
        subfieldDefinition =
            "Cybersecurity is the practice of protecting computers and networks from threats and attacks.";
        subfieldImportance =
            "With the increasing reliance on technology, cybersecurity helps keep our personal information safe and secure from hackers.";
        subfieldWhatYouLearn =
            "In cybersecurity, you learn about protecting systems, recognizing threats, and responding to security breaches.";
        subfieldCareerOpportunities =
            "Graduates can become security analysts, ethical hackers, or IT security managers.";
        subfieldSkillsNeeded =
            "You need analytical thinking, attention to detail, and a strong understanding of computer systems.";
        subfieldHowToGetStarted =
            "You can start with online courses, certifications, or a degree in computer science or information technology.";
        subfieldSalaries =
            "Cybersecurity professionals can earn between \$80,000 and \$200,000 annually.";
        subfieldImagePath = "assets/subfields/cs.jpg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=ULGILG-ZhO0";
        break;

      case "Data Science":
        subfieldDefinition =
            "Data Science combines statistics, computer science, and domain expertise to extract meaningful insights from data.";
        subfieldImportance =
            "It helps organizations make data-driven decisions that improve operations and enhance customer experiences.";
        subfieldWhatYouLearn =
            "Students learn about data analysis, visualization techniques, and machine learning.";
        subfieldCareerOpportunities =
            "Possible careers include data analyst, data engineer, and data scientist.";
        subfieldSkillsNeeded =
            "Key skills include programming, statistical analysis, and data manipulation.";
        subfieldHowToGetStarted =
            "Begin with courses in statistics, programming, and data analysis tools.";
        subfieldSalaries =
            "Data scientists can earn an average salary of \$100,000 to \$140,000 per year.";
        subfieldImagePath = "assets/subfields/ds.jpg";
        subfieldVideoLink = "https://www.youtube.com/watch?v=FsSrzmRawUg";
        break;

      // Business Administration Subfields
      case "Marketing":
        subfieldDefinition =
            "Marketing is the process of promoting and selling products or services, including market research and advertising.";
        subfieldImportance =
            "It helps businesses understand consumer needs and create effective strategies to reach their target audience.";
        subfieldWhatYouLearn =
            "Students learn about consumer behavior, digital marketing, and brand management.";
        subfieldCareerOpportunities =
            "Careers include marketing manager, brand strategist, and digital marketer.";
        subfieldSkillsNeeded =
            "Skills required are creativity, communication, and analytical thinking.";
        subfieldHowToGetStarted =
            "Start with a degree in marketing or business, and consider internships for practical experience.";
        subfieldSalaries =
            "Marketing professionals typically earn between \$60,000 and \$100,000 annually.";
        subfieldImagePath = "assets/subfields/marketing.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Finance":
        subfieldDefinition =
            "Finance is the management of money, including investments, banking, and budgeting.";
        subfieldImportance =
            "It is essential for individuals and organizations to make informed financial decisions and manage resources effectively.";
        subfieldWhatYouLearn =
            "Students learn about financial analysis, investment strategies, and risk management.";
        subfieldCareerOpportunities =
            "Careers include financial analyst, investment banker, and financial planner.";
        subfieldSkillsNeeded =
            "Analytical skills, attention to detail, and proficiency in financial software are crucial.";
        subfieldHowToGetStarted =
            "Pursue a degree in finance or accounting, and gain experience through internships.";
        subfieldSalaries =
            "Finance professionals can earn between \$70,000 and \$120,000 annually.";
        subfieldImagePath = "assets/subfields/finance.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Human Resources":
        subfieldDefinition =
            "Human Resources (HR) involves managing an organization's workforce, including recruitment, training, and employee relations.";
        subfieldImportance =
            "HR is vital for creating a positive work environment and ensuring organizational efficiency.";
        subfieldWhatYouLearn =
            "Students learn about labor laws, organizational behavior, and performance management.";
        subfieldCareerOpportunities =
            "Careers include HR manager, talent acquisition specialist, and training coordinator.";
        subfieldSkillsNeeded =
            "Skills in communication, negotiation, and conflict resolution are essential.";
        subfieldHowToGetStarted =
            "Start with a degree in human resources or business administration, and seek internships.";
        subfieldSalaries =
            "HR professionals typically earn between \$60,000 and \$100,000 per year.";
        subfieldImagePath = "assets/subfields/human_resources.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Operations Management":
        subfieldDefinition =
            "Operations Management focuses on overseeing production and business operations to ensure efficiency.";
        subfieldImportance =
            "It is essential for organizations to streamline processes, reduce costs, and improve quality.";
        subfieldWhatYouLearn =
            "Students learn about supply chain management, process optimization, and project management.";
        subfieldCareerOpportunities =
            "Careers include operations manager, supply chain analyst, and quality assurance manager.";
        subfieldSkillsNeeded =
            "Analytical skills, leadership, and problem-solving abilities are key.";
        subfieldHowToGetStarted =
            "Pursue a degree in operations management or business administration, and gain relevant experience.";
        subfieldSalaries =
            "Operations managers typically earn between \$70,000 and \$120,000 annually.";
        subfieldImagePath = "assets/subfields/operations_management.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      // Mechanical Engineering Subfields
      case "Robotics":
        subfieldDefinition =
            "Robotics involves designing, building, and operating robots for various applications.";
        subfieldImportance =
            "It plays a crucial role in automation and improving efficiency in industries like manufacturing and healthcare.";
        subfieldWhatYouLearn =
            "Students learn about mechanics, electronics, and computer programming.";
        subfieldCareerOpportunities =
            "Careers include robotics engineer, automation specialist, and research scientist.";
        subfieldSkillsNeeded =
            "Creativity, problem-solving, and technical skills are essential.";
        subfieldHowToGetStarted =
            "Start with a degree in mechanical engineering or robotics, and gain hands-on experience.";
        subfieldSalaries =
            "Robotics engineers typically earn between \$80,000 and \$130,000 per year.";
        subfieldImagePath = "assets/subfields/robotics.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Automobile":
        subfieldDefinition =
            "Automobile engineering focuses on designing and manufacturing vehicles and their systems.";
        subfieldImportance =
            "It is critical for advancing transportation technologies and ensuring safety standards.";
        subfieldWhatYouLearn =
            "Students learn about vehicle dynamics, engine design, and automotive electronics.";
        subfieldCareerOpportunities =
            "Careers include automotive engineer, design engineer, and production manager.";
        subfieldSkillsNeeded =
            "Strong analytical skills, creativity, and an understanding of mechanics are key.";
        subfieldHowToGetStarted =
            "Pursue a degree in mechanical or automotive engineering.";
        subfieldSalaries =
            "Automobile engineers earn between \$70,000 and \$120,000 annually.";
        subfieldImagePath = "assets/subfields/automobile.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Aerospace":
        subfieldDefinition =
            "Aerospace engineering involves the design and development of aircraft and spacecraft.";
        subfieldImportance =
            "It is essential for advancing aviation technology and space exploration.";
        subfieldWhatYouLearn =
            "Students learn about aerodynamics, propulsion, and materials science.";
        subfieldCareerOpportunities =
            "Careers include aerospace engineer, systems engineer, and project manager.";
        subfieldSkillsNeeded =
            "Analytical thinking, technical skills, and teamwork are crucial.";
        subfieldHowToGetStarted =
            "Start with a degree in aerospace engineering or a related field.";
        subfieldSalaries =
            "Aerospace engineers typically earn between \$80,000 and \$130,000 annually.";
        subfieldImagePath = "assets/subfields/aerospace.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      // Medical Science Subfields
      case "Nursing":
        subfieldDefinition =
            "Nursing is a healthcare profession focused on the care of individuals, families, and communities.";
        subfieldImportance =
            "Nurses play a vital role in patient care and healthcare delivery.";
        subfieldWhatYouLearn =
            "Students learn about anatomy, pharmacology, and patient care techniques.";
        subfieldCareerOpportunities =
            "Careers include registered nurse, nurse practitioner, and clinical nurse specialist.";
        subfieldSkillsNeeded =
            "Empathy, communication, and critical thinking skills are essential.";
        subfieldHowToGetStarted =
            "Pursue a nursing degree or diploma, and gain clinical experience.";
        subfieldSalaries =
            "Registered nurses can earn between \$60,000 and \$90,000 annually.";
        subfieldImagePath = "assets/subfields/nursing.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Pharmacy":
        subfieldDefinition =
            "Pharmacy is the science and practice of preparing, dispensing, and reviewing drugs.";
        subfieldImportance =
            "Pharmacists play a crucial role in patient care and medication management.";
        subfieldWhatYouLearn =
            "Students learn about pharmacology, medicinal chemistry, and patient counseling.";
        subfieldCareerOpportunities =
            "Careers include community pharmacist, clinical pharmacist, and pharmaceutical scientist.";
        subfieldSkillsNeeded =
            "Strong attention to detail, communication, and analytical skills are key.";
        subfieldHowToGetStarted =
            "Pursue a pharmacy degree and complete required clinical training.";
        subfieldSalaries =
            "Pharmacists typically earn between \$80,000 and \$120,000 per year.";
        subfieldImagePath = "assets/subfields/pharmacy.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Physical Therapy":
        subfieldDefinition =
            "Physical Therapy focuses on the treatment of patients to improve mobility and quality of life.";
        subfieldImportance =
            "Physical therapists help patients recover from injuries and manage chronic conditions.";
        subfieldWhatYouLearn =
            "Students learn about human anatomy, rehabilitation techniques, and patient assessment.";
        subfieldCareerOpportunities =
            "Careers include physical therapist, rehabilitation specialist, and sports therapist.";
        subfieldSkillsNeeded =
            "Empathy, patience, and strong interpersonal skills are essential.";
        subfieldHowToGetStarted =
            "Complete a degree in physical therapy and gain hands-on experience.";
        subfieldSalaries =
            "Physical therapists typically earn between \$70,000 and \$100,000 annually.";
        subfieldImagePath = "assets/subfields/physical_therapy.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      // Law Subfields
      case "Criminal Law":
        subfieldDefinition =
            "Criminal Law deals with offenses against the state and the punishment of those offenses.";
        subfieldImportance =
            "It is essential for maintaining public order and protecting individual rights.";
        subfieldWhatYouLearn =
            "Students learn about criminal justice, legal procedures, and case law.";
        subfieldCareerOpportunities =
            "Careers include criminal defense attorney, prosecutor, and judge.";
        subfieldSkillsNeeded =
            "Analytical thinking, communication, and negotiation skills are key.";
        subfieldHowToGetStarted =
            "Complete a law degree and pass the bar exam.";
        subfieldSalaries =
            "Criminal lawyers can earn between \$70,000 and \$150,000 annually.";
        subfieldImagePath = "assets/subfields/criminal_law.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Corporate Law":
        subfieldDefinition =
            "Corporate Law focuses on the legal aspects of business and commerce.";
        subfieldImportance =
            "It is crucial for ensuring compliance with regulations and protecting business interests.";
        subfieldWhatYouLearn =
            "Students learn about contract law, mergers and acquisitions, and corporate governance.";
        subfieldCareerOpportunities =
            "Careers include corporate lawyer, legal consultant, and compliance officer.";
        subfieldSkillsNeeded =
            "Strong analytical, negotiation, and communication skills are essential.";
        subfieldHowToGetStarted =
            "Obtain a law degree and gain experience in corporate law settings.";
        subfieldSalaries =
            "Corporate lawyers typically earn between \$90,000 and \$180,000 per year.";
        subfieldImagePath = "assets/subfields/corporate_law.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Family Law":
        subfieldDefinition =
            "Family Law deals with legal issues related to family relationships, such as marriage and child custody.";
        subfieldImportance =
            "It is essential for protecting the rights and well-being of families.";
        subfieldWhatYouLearn =
            "Students learn about divorce, child custody, and adoption law.";
        subfieldCareerOpportunities =
            "Careers include family lawyer, mediator, and legal advocate.";
        subfieldSkillsNeeded =
            "Empathy, negotiation, and strong communication skills are key.";
        subfieldHowToGetStarted =
            "Complete a law degree with a focus on family law and gain relevant experience.";
        subfieldSalaries =
            "Family lawyers typically earn between \$60,000 and \$120,000 annually.";
        subfieldImagePath = "assets/subfields/family_law.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      // Arts and Humanities Subfields
      case "History":
        subfieldDefinition =
            "History is the study of past events, particularly in human affairs.";
        subfieldImportance =
            "Understanding history helps us learn from past experiences and shape the future.";
        subfieldWhatYouLearn =
            "Students learn about historical events, research methods, and critical analysis.";
        subfieldCareerOpportunities =
            "Careers include historian, archivist, and museum curator.";
        subfieldSkillsNeeded =
            "Analytical thinking, research, and strong writing skills are essential.";
        subfieldHowToGetStarted =
            "Pursue a degree in history or a related field.";
        subfieldSalaries =
            "Historians can earn between \$50,000 and \$80,000 annually.";
        subfieldImagePath = "assets/subfields/history.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Literature":
        subfieldDefinition =
            "Literature is the study of written works, including fiction, poetry, and drama.";
        subfieldImportance =
            "It fosters critical thinking and enhances cultural understanding.";
        subfieldWhatYouLearn =
            "Students learn about literary analysis, writing techniques, and historical context.";
        subfieldCareerOpportunities =
            "Careers include writer, editor, and literary critic.";
        subfieldSkillsNeeded =
            "Creativity, strong communication, and analytical skills are key.";
        subfieldHowToGetStarted =
            "Pursue a degree in literature or creative writing.";
        subfieldSalaries =
            "Writers can earn between \$40,000 and \$80,000 annually.";
        subfieldImagePath = "assets/subfields/literature.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      case "Philosophy":
        subfieldDefinition =
            "Philosophy is the study of fundamental questions regarding existence, knowledge, and ethics.";
        subfieldImportance =
            "It encourages critical thinking and helps individuals understand complex ideas.";
        subfieldWhatYouLearn =
            "Students learn about various philosophical theories and ethical reasoning.";
        subfieldCareerOpportunities =
            "Careers include philosopher, ethics consultant, and academic researcher.";
        subfieldSkillsNeeded =
            "Analytical thinking, argumentation, and strong writing skills are essential.";
        subfieldHowToGetStarted =
            "Pursue a degree in philosophy or related fields.";
        subfieldSalaries =
            "Philosophers typically earn between \$50,000 and \$90,000 annually.";
        subfieldImagePath = "assets/subfields/philosophy.jpg";
        subfieldVideoLink = "https://www.youtube.com/";
        break;

      // Additional fields can be added in the same structure

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
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Find your Interest"),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Clarity.star_line),
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
                                    child: Image.asset(
                                      fieldImagePath ?? "",
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
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
                                          if (fieldVideoLink != null) {
                                            if (await canLaunch(
                                                fieldVideoLink.toString())) {
                                              await launch(
                                                  fieldVideoLink.toString());
                                            } else {
                                              throw 'Could not launch $fieldVideoLink';
                                            }
                                          } else {
                                            throw 'The video link is null';
                                          }
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
                              Future.delayed(
                                  const Duration(milliseconds: 100), () {
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
                                    top: Radius.circular(8)),
                                child: Image.asset(
                                  subfieldImagePath ?? "",
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
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
                                    if (subfieldVideoLink != null) {
                                      if (await canLaunch(
                                          subfieldVideoLink.toString())) {
                                        await launch(
                                            subfieldVideoLink.toString());
                                      } else {
                                        throw 'Could not launch $subfieldVideoLink';
                                      }
                                    } else {
                                      throw 'The video link is null';
                                    }
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
                                    onPressed: () {},
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








class PostgraduateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Postgraduate Education")),
      body: const Center(
        child: Text("Details for Postgraduate Education."),
      ),
    );
  }
}

class TechnicalVocationalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Technical and Vocational Education")),
      body: const Center(
        child: Text("Details for Technical and Vocational Education."),
      ),
    );
  }
}
