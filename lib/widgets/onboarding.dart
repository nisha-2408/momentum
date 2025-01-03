import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  Onboarding(
      {super.key,
      required this.illustration,
      required this.text,
      required this.title});

  final String illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80), // Push everything to the top
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none, // Allow overlap outside the stack bounds
        children: [
          // Text container (Positioned below the image)
          Container(
            margin: const EdgeInsets.only(top: 290), // Overlapping effect
            width: MediaQuery.of(context).size.width * 0.85,
            height: 280,
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
            decoration: BoxDecoration(
              color: Color(0xFF77E6F2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Floating image above the container (Overlapping effect)
          Positioned(
            top: -30, // Slightly outside the stack bounds
            child: Image.asset(
              illustration,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
