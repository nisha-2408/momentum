import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:resolution_tracker/constants/habits.dart';

class HabitCard extends StatefulWidget {
  final habit;
  final DateTime day;
  const HabitCard({super.key, required this.habit, required this.day});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  var _percent = 0.0;
  var _isInit = true;

  Future<void> updateCompletedHabit() async {
    // Query to find the document based on userId and date
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.day);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('completed')
        .where('userId', isEqualTo: widget.habit.data()['userId'])
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
      await FirebaseFirestore.instance.collection("completed").add({
        'userId': widget.habit.data()['userId'],
        'date': formattedDate,
        'count': 1
      });
    }
  }

  void _showCustomDialog(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.day);
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
                      await FirebaseFirestore.instance
                          .collection("habits-log")
                          .add({
                        'habitId': widget.habit.id,
                        'date': formattedDate,
                        'percent': 1
                      });
                      await updateCompletedHabit();
                      Navigator.of(context).pop(); // Close the dialog
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
  void didChangeDependencies() {
    if (_isInit) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(widget.day);
      final id = widget.habit.id;
      FirebaseFirestore.instance
          .collection("habits-log")
          .where('habitId', isEqualTo: id)
          .where("date", isEqualTo: formattedDate)
          .get()
          .then((value) {
        setState(() {
          if (value.docs.isNotEmpty) {
            _percent = (value.docs[0].data()['percent'] as num).toDouble();
          }
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String formattedDate = DateFormat('yyyy-MM-dd').format(widget.day);
        String currentDay = DateFormat('yyyy-MM-dd').format(DateTime.now());
        if (_percent != 0 ||formattedDate != currentDay) {
          return;
        }
        if (widget.habit['duration'] != 0) {
          Navigator.of(context).pushNamed('/timer', arguments: widget.habit);
        }
        _showCustomDialog(context);
      },
      child: Card(
        color: const Color(0xFF2D2D2D),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          habitImages[widget.habit.data()['activity']],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.habit.data()['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                      if (_percent == 1)
                        Row(
                          children: [
                            Text(
                              "Completed",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16.0, // Adjust size of the tick mark
                            ),
                          ],
                        ),
                      Text(
                        widget.habit.data()['time'],
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              )),
              SizedBox(),
              Padding(
                padding: const EdgeInsets.all(5),
                child: CircularPercentIndicator(
                  radius: 34.0,
                  lineWidth: 6.0,
                  percent: _percent,
                  animation: true,
                  animationDuration: 1200,
                  center: Text(
                    '${(_percent * 100).toInt()}%',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  progressColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey[300]!,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
