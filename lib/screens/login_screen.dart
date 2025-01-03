import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var notShowPass = true;
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

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
              Center(child: Image.asset('assets/images/login.png')),
              const SizedBox(height: 20),
              // Login Title
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Email or Phone TextField
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
              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              // Forget Account
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/forgot_email');
                  },
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: _isLoading ? Colors.grey : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // Handle next action
                    if (_isLoading) {
                      return;
                    }
                    try {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      setState(() {
                        _isLoading = true;
                      });
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
                        print('success');
                        Navigator.of(context).pushReplacementNamed('/home');
                      });
                      setState(() {
                        _isLoading = false;
                      });
                    } on HttpException catch (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      var errorMessage = 'Authentication failed';
                      if (error.toString().contains('EMAIL_NOT_FOUND')) {
                        errorMessage = 'Could not find a user with that email.';
                      } else if (error.toString().contains('wrong-password')) {
                        errorMessage = 'Invalid password.';
                      }
                      _showErrorDialog(errorMessage);
                    } catch (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      print(error);
                      var errorMessage;
                      if (error.toString().contains("wrong-password")) {
                        errorMessage = 'Invalid password.';
                      } else if (error.toString().contains("user-not-found")) {
                        errorMessage = 'Could not find a user with that email.';
                      } else {
                        errorMessage =
                            "Could not authenticate you!! Try again later :(";
                      }
                      _showErrorDialog(errorMessage);
                    }
                  },
                  child: Text(
                    _isLoading ? 'Logging in...' : 'Login',
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              SizedBox(
                  height: 55,
                  child: Center(
                    child: Text(
                      "or",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            image: AssetImage('assets/images/google_logo.png')),
                        Text(
                          "Google",
                          style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        " Create Account",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
