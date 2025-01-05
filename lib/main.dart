import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/screens/fogot_passowrd_email.dart';
import 'package:resolution_tracker/screens/home_screen.dart';
import 'package:resolution_tracker/screens/login_screen.dart';
import 'package:resolution_tracker/screens/notification_screen.dart';
import 'package:resolution_tracker/screens/onboarding_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:resolution_tracker/screens/signup_screen.dart';
import 'package:resolution_tracker/providers/auth.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                  title: 'Momentum',
                  theme: ThemeData(
                    primaryColor: Color(0xFF00BCD4),
                    scaffoldBackgroundColor:
                        Color(0xFF101010), // Dark background
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
                        headlineSmall: TextStyle(
                          fontSize: 20,
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
                        displayLarge: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        )),

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
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                      backgroundColor: Color(0xFF00BCD4),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  // home: const MyHomePage(title: 'Momentum Home Page'),
                  debugShowCheckedModeBanner: false,
                  home: auth.isAuth
                      ? HomeScreen()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (context, snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? CircularProgressIndicator()
                                  : OnboardingScreen(),
                        ),
                  routes: {
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    SignupScreen.routeName: (ctx) => SignupScreen(),
                    ForgotPasswordEmail.routeName: (ctx) =>
                        ForgotPasswordEmail(),
                    HomeScreen.routeName: (ctx) => HomeScreen(),
                    NotificationScreen.routeName: (ctx) => NotificationScreen(),
                  })),
    );
  }
}
