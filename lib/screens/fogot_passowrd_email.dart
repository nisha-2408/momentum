import 'package:flutter/material.dart';

class ForgotPasswordEmail extends StatefulWidget {
  static const routeName = '/forgot_email';
  const ForgotPasswordEmail({super.key});

  @override
  State<ForgotPasswordEmail> createState() => _ForgotPasswordEmailState();
}

class _ForgotPasswordEmailState extends State<ForgotPasswordEmail> {
  final TextEditingController _emailController = TextEditingController();
  var notShowPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/forgot.png')),
              const SizedBox(height: 20),
              // Login Title
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forgot Password?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Don't worry! It happens. Please enter the email or phone number associated with your account.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Email or Phone',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Handle next action
                    final email = _emailController.text;

                    // Debug: Print credentials
                    print('Email: $email');
                    Navigator.of(context).pushNamed('/forgot_password');
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
