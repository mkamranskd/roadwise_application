import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  const CommonHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
            height: 100,
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
            height: 75,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/light-2.png'),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 30,
            width: 50,
            height: 50,
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
              margin: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontFamily: 'bifur', fontSize: 50.0),
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
