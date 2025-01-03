import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  var notShowPass = true;
  var _isLoading = false;
  var _isError = false;

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
                  'Sign Up',
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
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Full Name',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
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
                    if (_isLoading) {
                      return;
                    }
                    try {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final fullName = _nameController.text;
                      UserCredential user;
                      setState(() {
                        _isLoading = true;
                      });
                      user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.user!.uid)
                          .set({'name': fullName, 'email': email});
                      setState(() {
                        _isLoading = false;
                      });
                      // ignore: unrelated_type_equality_checks
                      //Navigator.popUntil(context, ModalRoute.withName('/'));
                      Navigator.of(context).pushReplacementNamed('/home');
                    } on HttpException catch (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      _isError = true;
                      var errorMessage = 'Authentication failed';
                      if (error.toString().contains('EMAIL_EXISTS')) {
                        errorMessage = 'This email address is already in use.';
                      } else if (error.toString().contains('INVALID_EMAIL')) {
                        errorMessage = 'This is not a valid email address';
                      } else if (error.toString().contains('WEAK_PASSWORD')) {
                        errorMessage = 'This password is too weak.';
                      }
                      _showErrorDialog(errorMessage);
                    } catch (error) {
                      print(error);
                      setState(() {
                        _isLoading = false;
                      });
                      _isError = true;
                      var errorMessage = 'Authentication failed';
                      if (error.toString().contains('email-already-in-use')) {
                        errorMessage = 'This email address is already in use.';
                      } else if (error.toString().contains('INVALID_EMAIL')) {
                        errorMessage = 'This is not a valid email address';
                      } else if (error.toString().contains('WEAK_PASSWORD')) {
                        errorMessage = 'This password is too weak.';
                      }
                      _showErrorDialog(errorMessage);
                    }
                    if (!_isError) {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                  child: Text(
                    _isLoading ? 'Signing up...' : 'Sign Up',
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        " Login",
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
    _nameController.dispose();
    super.dispose();
  }
}
