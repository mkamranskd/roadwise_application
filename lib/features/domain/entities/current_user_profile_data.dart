import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch current user's details from Firestore
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // No user is logged in
      return null;
    }

    try {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        // User document does not exist
        return null;
      }
    } catch (e) {
      // Handle errors
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Example function to update user details
  Future<void> updateUserDetails(Map<String, dynamic> data) async {
    User? user = _auth.currentUser;
    if (user == null) {
      // No user is logged in
      return;
    }

    try {
      await _firestore.collection('Users').doc(user.uid).update(data);
    } catch (e) {
      // Handle errors
      print('Error updating user details: $e');
    }
  }
}




















///////////////////////////////////////////////////////////
/*


copy this code in any screen to get access of the Current User Details by currentUser!['fullName']

  Map<String, dynamic>? currentUser;
  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
    _fetchUserDetails();

  }
  Future<void> _fetchUserDetails() async {
    final userDetails = await _userService.getCurrentUserDetails();
    setState(() {
      currentUser = userDetails;
    });
  }











 */








