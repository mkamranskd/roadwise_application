import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/svg_illustrations.dart';

class UniversitiesScreen extends StatefulWidget {
  final String heading;

  UniversitiesScreen({required this.heading});

  @override
  _UniversitiesScreenState createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  bool allResultsEmpty = false;
  List<QueryDocumentSnapshot> universities = [];
  Map<String, List<Map<String, dynamic>>> universityDetails = {}; // Stores university URLs and filtered data
  bool isLoading = true; // Track if data is still loading

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  // Function to fetch universities and filter them
  Future<void> fetchUniversities() async {
    final String path = '/countries/Pakistan/states/Sindh/universities';
    try {
      var snapshot = await FirebaseFirestore.instance.collection(path).get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          universities = snapshot.docs;
        });

        bool anyResultsFound = false;

        // Fetch details for each university and filter by the heading value
        for (var university in universities) {
          String? url = university['depCollectionUrl'];
          if (url != null && url.isNotEmpty) {
            List<Map<String, dynamic>> details =
            await fetchAndFilterJson(url, widget.heading);
            if (details.isNotEmpty) {
              setState(() {
                universityDetails[university.id] = details;
              });
              anyResultsFound = true;
            }
          }
        }

        // Update state to stop loading if results are found or not
        setState(() {
          allResultsEmpty = !anyResultsFound;
          isLoading = false;
        });
      } else {
        setState(() {
          allResultsEmpty = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching universities: $e");
      setState(() {
        allResultsEmpty = true;
        isLoading = false;
      });
    }
  }

  // Function to fetch and filter the JSON
  Future<List<Map<String, dynamic>>> fetchAndFilterJson(
      String? url, String keyword) async {
    if (url == null || url.isEmpty) {
      return [];
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .where((item) =>
        item['text'] != null &&
            item['href'] != null &&
            (item['text']
                .toString()
                .trim()
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
                item['href']
                    .toString()
                    .trim()
                    .toLowerCase()
                    .contains(keyword.toLowerCase())))
            .map((item) => {
          'text': item['text'],
          'href': item['href'],
        })
            .toList();
      }
    } catch (e) {
      print('Error fetching JSON data: $e');
    }
    return [];
  }

  // Function to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Function to make a phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    var status = await Permission.phone.status;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
    if (status.isDenied) {
      if (await Permission.phone.request().isGranted) {
        final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
        await launchUrl(launchUri);
      }
    } else if (status.isGranted) {
      _launchCaller(phoneNumber);
    } else {
      throw 'Permission denied';
    }
  }

  // Function to launch the caller app
  void _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Universities: ${widget.heading}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ) // Show loading indicator while fetching data
            : Column(
          children: [
            if (allResultsEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.string(
                      height: 200,
                      width: 200,
                      noResultsIllistration,
                      fit: BoxFit.scaleDown,
                    ),
                    const Text(
                      'No universities found.',
                    ),
                  ],
                ),
              ),
            Expanded(
              child: universities.isEmpty
                  ? const Center(child: Text('No universities available'))
                  : ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  var university = universities[index];
                  String? url = university['depCollectionUrl'];

                  // Only show universities and their departments if the heading is found in either
                  // the university name or in any department offering (from the JSON response)
                  if (universityDetails.containsKey(university.id)) {
                    return FadeIn(
                      duration: const Duration(milliseconds: 1000),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                              ),
                              child: ExpansionTile(
                                title: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Text(university['name'],
                                      style: const TextStyle(fontSize: 20)),
                                ),
                                leading: ClipOval(
                                  child: Image.network(
                                    university['logoUrl'] != null &&
                                        university['logoUrl']!
                                            .isNotEmpty
                                        ? university['logoUrl']
                                        : 'https://firebasestorage.googleapis.co/v0/b/roadwise-application-54684.appspot.com/o/universitesLogo%2Ferror.png?alt=media&token=68a525ed-f351-4555-bd68-4f5fce02e29c',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/error.png');
                                    },
                                  ),
                                ),
                                children: [
                                  ListTile(
                                    title: Text(university['shortFormName']),
                                    leading: const Icon(Icons.web),
                                    trailing: IconButton(
                                      onPressed: () {
                                        _launchURL(university['webPage']);
                                      },
                                      icon: const Icon(Clarity.link_line),
                                    ),
                                    subtitle: Text(university['webPage']),
                                  ),
                                  ListTile(
                                    title: Text(university['city']),
                                    leading: const Icon(Clarity.map_marker_line),
                                  ),
                                  ListTile(
                                    title: Text(university['contactNo']),
                                    leading: const Icon(Icons.contact_page),
                                    trailing: IconButton(
                                      onPressed: () {
                                        makePhoneCall(university['contactNo']);
                                      },
                                      icon: const Icon(Clarity.mobile_phone_line),
                                    ),
                                  ),
                                  ...universityDetails[university.id]!.map((item) {
                                    return ListTile(
                                      title: Text(
                                          'Offering ${item['text'] ?? 'Unknown'}'),
                                      subtitle: Text(
                                          item['href'] ?? 'No URL available'),
                                      trailing: IconButton(
                                        onPressed: () {
                                          _launchURL(item['href']);
                                        },
                                        icon: const Icon(Clarity.link_line),
                                      ),
                                      leading: const Icon(Icons.workspace_premium),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
