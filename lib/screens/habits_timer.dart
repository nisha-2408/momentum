import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitsTimerScreen extends StatefulWidget {
  static const routeName = '/timer';
  const HabitsTimerScreen({super.key});

  @override
  State<HabitsTimerScreen> createState() => _HabitsTimerScreenState();
}

class _HabitsTimerScreenState extends State<HabitsTimerScreen> {
  late Timer _timer;
  Duration _remainingTime = Duration(minutes: 30);
  Duration _totalTime = Duration(minutes: 30);
  var _habit;
  var _habitId;

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  double _calculatePercentageGone() {
    final goneTime = _totalTime - _remainingTime;
    return goneTime.inSeconds / _totalTime.inSeconds;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      final args =
          ModalRoute.of(context)?.settings.arguments as QueryDocumentSnapshot;
      setState(() {
        _habit = args.data();
        _habitId = args.id;
        var duration = (args?.data() as Map<String, dynamic>)['duration'];
        _remainingTime = Duration(minutes: duration);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - Duration(seconds: 1);
        } else {
          _timer.cancel();
          giveUp();
          _showCompletionDialog();
        }
      });
    });
  }

  String formatMinutes(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes minute${totalMinutes == 1 ? '' : 's'}';
    } else {
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;
      return '$hours hour${hours == 1 ? '' : 's'}'
          '${minutes > 0 ? ' and $minutes minute${minutes == 1 ? '' : 's'}' : ''}';
    }
  }

  Future<void> giveUp() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final percentage = _calculatePercentageGone();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('habits-log')
        .where('habitId', isEqualTo: _habitId)
        .where('date', isEqualTo: formattedDate)
        .get();

    // Check if a matching document exists
    if (querySnapshot.docs.isNotEmpty) {
      // You can choose to update a specific document (assuming one match here)
      DocumentSnapshot doc = querySnapshot.docs.first; // Take the first match

      // Update the document
      await FirebaseFirestore.instance
          .collection('habits-log')
          .doc(doc.id)
          .update({
        'percent': percentage, // Safely cast to Map
        // Add other fields you want to update here
      });
    } else {
      await FirebaseFirestore.instance.collection("habits-log").add({
        'habitId': _habitId,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'percent': percentage
      });
    }
    if (percentage == 1) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('completed')
          .where('userId', isEqualTo: _habit['userId'])
          .where('date', isEqualTo: formattedDate)
          .get();

      // Check if a matching document exists
      if (querySnapshot.docs.isNotEmpty) {
        // You can choose to update a specific document (assuming one match here)
        DocumentSnapshot doc = querySnapshot.docs.first; // Take the first match

        // Update the document
        await FirebaseFirestore.instance
            .collection('completed')
            .doc(doc.id)
            .update({
          'count': (doc.data() as Map<String, dynamic>)['count'] +
              1, // Safely cast to Map
          // Add other fields you want to update here
        });
      } else {
        await FirebaseFirestore.instance.collection("completed").add(
            {'userId': _habit['userId'], 'date': formattedDate, 'count': 1});
      }
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showCustomDialog(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    showDialog(
      context: context,
      barrierDismissible:
          true, // Whether the dialog can be dismissed by tapping outside of it
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Are you done with the task?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await giveUp(); // Close the dialog
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to leave this page?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _showCompletionDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You have completed the task.'),
      ),
    );

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    _habit['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    "You've already taken the hardest step, there's very little left",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Iceberg graphic (placeholder for now)
                  Container(
                    height: 300,
                    width: 300,
                    child: Center(
                      child: Image.asset("assets/images/timer.png"),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Timer display
                  Column(
                    children: [
                      Text(
                        _formatDuration(_remainingTime),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        formatMinutes(_habit['duration']),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // "Don't Give Up!" Button
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          _showCustomDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust border radius
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "Give Up :(".toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
