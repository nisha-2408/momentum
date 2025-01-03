import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/providers/auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }
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
              await Provider.of<Auth>(context, listen: false).logOut();
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
