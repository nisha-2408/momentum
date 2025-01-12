import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/providers/auth.dart';
import 'package:resolution_tracker/widgets/day_calendar.dart';
import 'package:resolution_tracker/widgets/habits_of_day.dart';
import 'package:resolution_tracker/widgets/profile_banner_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _userName = 'Name';
  var _avatar = 'assets/images/avatar4.png';
  var _userId = '';
  var _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  var _isInit = true;
  var _isLoading = false;

  void setAvatar(String avatar) {
    setState(() {
      _avatar = avatar;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Auth>(context).getUserInfo().then((value) {
        setState(() {
          _userName = value?['name'];
          _avatar = value?['avatar'];
          _userId = value?['userId'];
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(9, 42, 9, 0),
              child: Column(
                children: [
                  ProfileBannerCard(
                    userName: _userName,
                    avatar: _avatar,
                    onAvatarSelected: setAvatar,
                    userId: _userId,
                  ),
                  DayCalendar(
                    selectedDay: _selectedDay,
                    setSelectedDay: (day) {
                      setState(() {
                        _selectedDay = day;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: HabitsOfTheDay(
                      selectedDay: _selectedDay,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: !_isLoading
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Define your logic to add a new habit here
                  Navigator.of(context).pushNamed('/add-habits');
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "New Habit",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor, // Button color
                  minimumSize: const Size(200, 50), // Button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                ),
              ),
            )
          : null, // Hide the floating button when loading
    );
  }
}
