import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/providers/auth.dart';
import 'package:resolution_tracker/widgets/day_calendar.dart';
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
                  DayCalendar(),
                ],
              ),
            ),
    );
  }
}
