import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

final _auth = FirebaseAuth.instance;
const kPrimaryColor = Color(0xff0a66c2);
const kPrimaryLightColor = Color(0xFFFFECDF);
Color primaryBlueColor =  const Color(0xff0094fd);

class TEXTBOX extends StatelessWidget {
  final String title;
  final TextEditingController? cont;
  const TEXTBOX({Key? key, required this.title, this.cont}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextField(
          obscureText: false,
          controller: cont,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: title,
            hintText: title,
          ),
        ),
        const SizedBox(height: 10), // Adjusted SizedBox height
      ],
    );
  }
}


class Field extends StatelessWidget {
  final String title;

  final String heading;
  const Field({super.key, required this.title, required this.heading, });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: heading,
          ),
          controller: TextEditingController(text: title),
        ),
        const SizedBox(height: 5), // Adjusted SizedBox height
      ],
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int count,total;
  const ProgressBar({super.key, required this.count,required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        StepProgressIndicator(
          totalSteps: total,
          currentStep: count,
          selectedColor: primaryBlueColor,
          unselectedColor: Colors.grey,
          customStep: (index, color, _) => color == primaryBlueColor
              ? Container(
            color: color,
            child:  Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Icon(
                Icons.check_circle,
                color: primaryBlueColor,
              ),
            ),
          )
              : Container(
            color: color,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}

class H1 extends StatelessWidget {
  final String title;
  final Color clr;
  const H1({super.key, required this.title,required this.clr});

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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15,),
      ],
    );
  }
}

class H2 extends StatelessWidget {
  final String title;
  final Color clr;

  const H2({super.key, required this.title,required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Text(
          title,
          textAlign: TextAlign.left,
          style:  TextStyle(
            color: clr,
            fontSize: 24,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12,),
      ],
    );
  }
}

class H3 extends StatelessWidget {
  final String title;

  final Color clr;

  const H3({super.key, required this.title,required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15,),
        Text(
          title,
          textAlign: TextAlign.left,
          style:  TextStyle(
            color: clr,
            fontSize: 18,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10,),
      ],
    );
  }
}

class H4 extends StatelessWidget {
  final String title;
  final Color clr;
  const H4({super.key, required this.title,required this.clr});

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
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8,),
      ],
    );
  }
}

class H5 extends StatelessWidget {
  final String title;
  final Color clr;

  const H5({super.key, required this.title,required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style:  TextStyle(
            color: clr,
            fontSize: 11,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

class H6 extends StatelessWidget {
  final String title;

  final Color clr;

  const H6({super.key, required this.title,required this.clr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style:  TextStyle(
            color: clr,
            fontSize: 5,
            fontFamily: 'Dubai',
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 0,),
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
          "   "+title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
              fontFamily: 'Dubai',
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 3,),
      ],
    );
  }
}

class CustomComboBox extends StatefulWidget {
  final String title;
  final List<String> items;
  final String firebaseFieldName; // New parameter to specify the Firebase field name
  final TextEditingController? controller;
  final String defaultValue;
  CustomComboBox({
    required this.title,
    required this.items,
    required this.firebaseFieldName,
    this.controller,
    this.defaultValue = '',
  });

  @override
  _CustomComboBoxState createState() => _CustomComboBoxState();
}

class _CustomComboBoxState extends State<CustomComboBox> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.items.first; // Initialize selected value with the first item
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Adjust padding here
            hintText: widget.title,
            hintStyle: TextStyle(color: Colors.grey[700], fontFamily: 'Dubai'),
          ),
          value: _selectedValue,
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedValue = newValue ?? '';
              _updateFirebaseField(newValue);
            });
          },
        ),
        const SizedBox(height: 5), // Adjust SizedBox height as needed
      ],
    );
  }

  void _updateFirebaseField(String? newValue) async {
    final user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .set({
        widget.firebaseFieldName: newValue,
      }, SetOptions(merge: true));
    }
  }
}

class CustomButton extends StatelessWidget {
  final String title;// Make navigateTo parameter optional
  final Color clr1;
  final Color clr2;// Added onPressed parameter
  final VoidCallback onTap;
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
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient:  LinearGradient(
                colors: [
                  clr1,
                  clr2,
                ],
              ),
            ),
            child:  Center(
              child: loading ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 35,
              ): Text(
                title,
                style: const TextStyle(color: Colors.white, fontFamily: 'Dubai',fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 15,),
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
                  style:  TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                isSelected
                    ? const Icon(Icons.check_circle, color: Colors.white,)
                    : const Icon(Icons.cancel, color: Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 15,),
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
                    fontSize: 16,
                    color: selectedIndex == index ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                selectedIndex == index
                    ? const Icon(Icons.check_circle, color: Colors.white,)
                    : const Icon(Icons.radio_button_unchecked, color: Colors.red),
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

  const CustomSearchBar({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:const TextStyle(color: Colors.black),
      keyboardType: TextInputType.text,
      controller: controller,
      decoration:  InputDecoration(
        border: InputBorder.none,
        hintText: "Search",

        prefixIcon: Icon(
          Clarity.search_line,
          size: 20,
          color: primaryBlueColor,
        ),
        suffixIcon:  Icon(
          Clarity.filter_line,
          size: 20,
          color: primaryBlueColor, // Assuming primaryBlueColor is defined
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'Dubai',
        ),
      ),
    );
  }
}






