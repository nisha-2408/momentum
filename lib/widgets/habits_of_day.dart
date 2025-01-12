import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/providers/auth.dart';
import 'package:resolution_tracker/widgets/habit_card.dart';
import 'package:resolution_tracker/widgets/daily_progress.dart';

class HabitsOfTheDay extends StatefulWidget {
  final DateTime selectedDay;
  const HabitsOfTheDay({super.key, required this.selectedDay});

  @override
  State<HabitsOfTheDay> createState() => _HabitsOfTheDayState();
}

class _HabitsOfTheDayState extends State<HabitsOfTheDay> {
  var _isInit = true;
  var _isLoading = false;
  var habitsOfTheDay = [];
  var _completed = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      fetchHabits();
      fetchCompleted();
    }
    _isInit = false;
  }

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget as HabitsOfTheDay);
    if (widget.selectedDay != (oldWidget).selectedDay) {
      // Trigger Firestore query when selectedDay changes
      fetchHabits();
      fetchCompleted();
    }
  }

  void fetchHabits() {
    _isLoading = true;
    final id = Provider.of<Auth>(context, listen: false).userId;
    FirebaseFirestore.instance
        .collection("habits")
        .where('userId', isEqualTo: id)
        .where('days', arrayContains: widget.selectedDay.weekday % 7)
        .get()
        .then((value) {
      setState(() {
        habitsOfTheDay = value.docs;
      });
    });
  }

  void fetchCompleted() {
    _isLoading = true;
    final id = Provider.of<Auth>(context, listen: false).userId;
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
    FirebaseFirestore.instance
        .collection("completed")
        .where('userId', isEqualTo: id)
        .where('date', isEqualTo: formattedDate)
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          _completed = value.docs[0].data()['count'];
        } else {
          _completed = 0;
        }
        _isLoading = false;
      });
    });
  }

  // ProgressWidget(completedTasks: 15, totalTasks: 15),

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProgressWidget(
            completedTasks: _completed, totalTasks: habitsOfTheDay.length),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width:
                double.infinity, // Ensures the container spans the full width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Habits of the Day",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign:
                          TextAlign.left, // Ensures text alignment to the left
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/habits',
                            arguments: widget.selectedDay);
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
                if (habitsOfTheDay.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text('No Habits on this day!!'),
                    ),
                  ),
                // Handling habit cards based on habitsOfTheDay length
                if (!_isLoading)
                  for (var i = 0;
                      i <
                          (habitsOfTheDay.length > 2
                              ? 2
                              : habitsOfTheDay.length);
                      i++)
                    HabitCard(
                        habit: habitsOfTheDay[i], day: widget.selectedDay),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ) // Pass the individual habit to HabitCard
              ],
            ),
          ),
        )
      ],
    );
  }
}
