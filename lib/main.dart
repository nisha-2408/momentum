import 'package:flutter/material.dart';
import 'package:resolution_tracker/screens/fogot_passowrd_email.dart';
import 'package:resolution_tracker/screens/forgot_password.dart';
import 'package:resolution_tracker/screens/home_screen.dart';
import 'package:resolution_tracker/screens/login_screen.dart';
import 'package:resolution_tracker/screens/onboarding_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:resolution_tracker/screens/signup_screen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momentum',
      theme: ThemeData(
        primaryColor: Color(0xFF00BCD4),
        scaffoldBackgroundColor: Color(0xFF101010), // Dark background
        brightness: Brightness.dark,

        // Text Theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white70,
          ),
        ),

        // Input Decorations
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1E1E1E), // Darker input field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
        ),

        // Custom Card
        cardTheme: const CardTheme(
          color: Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),

        // FloatingActionButton Theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00BCD4),
          foregroundColor: Colors.white,
        ),
      ),
      // home: const MyHomePage(title: 'Momentum Home Page'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (ctx) => MyHomePage(title: 'Momentum Home Page'),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        ForgotPasswordEmail.routeName: (ctx) => ForgotPasswordEmail(),
        ForgotPassword.routeName: (ctx) => ForgotPassword(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return OnboardingScreen();
  }
}
