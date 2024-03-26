import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  const CommonHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/background.png'),
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
                  image: AssetImage('lib/assets/images/light-1.png'),
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
                  image: AssetImage('lib/assets/images/light-2.png'),
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
                  image: AssetImage('lib/assets/images/clock.png'),
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: const EdgeInsets.only(top: 140),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontFamily: 'bifur', fontSize: 75.0),
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