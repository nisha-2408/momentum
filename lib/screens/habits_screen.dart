import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/providers/auth.dart';
import 'package:resolution_tracker/widgets/habit_card.dart';

class HabitsScreen extends StatefulWidget {
  static const routeName = '/habits';
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _habits = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      final args = ModalRoute.of(context)?.settings.arguments as DateTime;
      final weekDay = args.weekday % 7;
      final id = Provider.of<Auth>(context, listen: false).userId;
      FirebaseFirestore.instance
          .collection("habits")
          .where('userId', isEqualTo: id)
          .where('days', arrayContains: weekDay)
          .get()
          .then((value) {
        setState(() {
          _isLoading = false;
          _habits = value.docs;
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
          : Container(
              margin: EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(9, 42, 9, 0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns the text to the left
                children: [
                  Text(
                    "Habits of the Day",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  if (_habits
                      .isNotEmpty) // Adds spacing between the title and the list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _habits.length,
                        itemBuilder: (context, index) {
                          return HabitCard(
                              habit: _habits[index], day: DateTime.now());
                        },
                      ),
                    ),
                  if (_habits.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text("No Habits on this day!"),
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
