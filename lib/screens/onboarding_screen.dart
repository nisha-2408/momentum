import 'package:flutter/material.dart';
import 'package:resolution_tracker/constants/onboard_screen.dart';
import 'package:resolution_tracker/widgets/carousal_animated_indicator.dart';
import 'package:resolution_tracker/widgets/onboarding.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) => setState(() {
                _selectedIndex = index;
              }),
              itemCount: demoData.length,
              itemBuilder: (context, index) {
                return Onboarding(
                  illustration: demoData[index]['illustration'],
                  text: demoData[index]['text'],
                  title: demoData[index]['title'],
                );
              },
            ),
          ),
          CarousalAnimatedIndicator(selectedIndex: _selectedIndex),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Adjust border radius
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  "Let's Get Started".toUpperCase(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
