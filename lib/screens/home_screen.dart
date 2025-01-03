import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
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
              "Log Out",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
