import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../global/style.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _confirmDeleteAccount() async {
    // Generate a random 4-digit number
    Random random = Random();
    int randomNumber = 1000 + random.nextInt(9000);

    // Show the AlertDialog
    String? userInput = await _showConfirmationDialog(randomNumber);

    // Check if the user input matches the random number
    if (userInput == randomNumber.toString()) {
      // Proceed to delete the account
      await _deleteAccount();
    } else {
      // Show error if input doesn't match
      _showErrorDialog('Incorrect number. Account deletion cancelled.');
    }
  }

  Future<String?> _showConfirmationDialog(int randomNumber) {
    TextEditingController inputController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter the following number to confirm:'),
              Text(
                '$randomNumber',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter the number here',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Return the user's input
                Navigator.of(context).pop(inputController.text);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).delete();
        await user.delete();
        await user.delete();
        _showErrorDialog('Your account has been successfully deleted.');
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        _showErrorDialog('Please re-authenticate and try again.');
      } else {
        _showErrorDialog('An error occurred: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: ListView(
        children: [
          ProfileListItem(
            icon: Clarity.moon_line,
            title: 'Dark Mode',
            ontap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: DarkModeScreen()),
              );
            },
          ),
          ProfileListItem(
            icon: Clarity.notification_line,
            title: 'Notifications',
            ontap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: NotificationsScreen()),
              );
            },
          ),
          ProfileListItem(
            icon: Clarity.language_line,
            title: 'Language',
            ontap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: LanguageScreen()),
              );
            },
          ),
          ProfileListItem(
            icon: Clarity.user_line,
            title: 'Account',
            ontap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: AccountScreen()),
              );
            },
          ),
          ProfileListItem(
            icon: Clarity.shield_check_line,
            title: 'Privacy',
            ontap: () {
              Navigator.push(
                context,
                CustomPageRoute(child: PrivacyScreen()),
              );
            },
          ),
          ProfileListItem(
            icon: Clarity.trash_line,
            title: 'Delete your Account Data Permanently',
            ontap: () {
              _confirmDeleteAccount();
            },
          ),
        ],
      ),
    );
  }
}

class DarkModeScreen extends StatefulWidget {
  @override
  _DarkModeScreenState createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  bool isLoading = true;
  bool isDarkMode = false;
  bool fromFirebaseMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadDarkModeSetting();
  }

  Future<void> _loadDarkModeSetting() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        isDarkMode = userDoc['isThemeMode'] ?? false;
        fromFirebaseMode = userDoc['isThemeMode'] ?? false;
        isLoading = false;
      });
    }
  }

  Future<void> _saveDarkModeSetting(bool value) async {
    String userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'isThemeMode': value,
    });
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dark Mode Settings',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Colors.blue,
                size: 25,
              ),
            )
          : SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                          'To Take Effect, App needs to be restarted'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              isDarkMode = fromFirebaseMode;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _saveDarkModeSetting(value);
                          },
                          child: const Text('Restart'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Receive App Notifications'),
            value: true,
            onChanged: (value) {
              // Handle notification toggle
            },
          ),
          SwitchListTile(
            title: const Text('Receive Email Notifications'),
            value: false,
            onChanged: (value) {
              // Handle email notification toggle
            },
          ),
        ],
      ),
    );
  }
}

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English'),
            leading: Radio<String>(
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Urdu'),
            leading: Radio<String>(
              value: 'Urdu',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Sindhi'),
            leading: Radio<String>(
              value: 'Sindhi',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: Column(
        children: [
          ProfileListItem(
            icon: Clarity.lock_line,
            title: 'Change Password',
            ontap: () {},
          ),
          ProfileListItem(
            icon: Clarity.email_line,
            title: 'Change Email',
            ontap: () {},
          ),
        ],
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy',
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Two-Factor Authentication'),
            value: false,
            onChanged: (value) {
              // Handle two-factor authentication toggle
            },
          ),
          ListTile(
            title: const Text('Clear Search History'),
            onTap: () {
              // Handle clearing search history
            },
          ),
        ],
      ),
    );
  }
}
