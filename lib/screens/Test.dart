import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // GoogleMapController? _controller;
  Set<Marker> _markers = {};
  List<Marker> _allMarkers = [];

  @override
  void initState() {
    super.initState();
    // Fetch educational institute data from backend/API
    fetchInstituteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadwise'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.7749, -122.4194), // San Francisco coordinates
                zoom: 12,
              ),
              markers: _markers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _searchInstitutes,
                    child: const Text('Search'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showChatbot,
                    child: const Text('Chatbot'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
     // _controller = controller;
    });
  }

  void fetchInstituteData() {
    // Implement actual data fetching from backend/API
    // Add markers to _allMarkers based on fetched data
    // For demo purposes, let's add dummy data
    _allMarkers = [
      const Marker(
        markerId: MarkerId('1'),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(
          title: 'University of San Francisco',
          snippet: 'Private Jesuit university',
        ),
      ),
      const Marker(
        markerId: MarkerId('2'),
        position: LatLng(37.7749, -122.4294),
        infoWindow: InfoWindow(
          title: 'Stanford University',
          snippet: 'Private research university',
        ),
      ),
    ];

    // Initially, display all markers on the map
    _markers = Set.from(_allMarkers);
  }

  void _searchInstitutes() {
    // Implement search/filtering logic based on user input
    // Update _markers to display filtered institutes
    // For demo purposes, let's just display all markers again
    setState(() {
      _markers = Set.from(_allMarkers);
    });
  }

  void _showChatbot() {
    // Implement chatbot interface using Flutter Dialogflow package
    // For demo purposes, let's just display a placeholder dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chatbot'),
          content: const Text('Placeholder for chatbot interface'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}