import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressWidget extends StatelessWidget {
  final double progress;
  final int completedTasks;
  final int totalTasks;

  const ProgressWidget({
    Key? key,
    required this.completedTasks,
    required this.totalTasks,
  })  : progress = completedTasks / totalTasks,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // The container with the rest of the content
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                      width: 140), // This creates space for the floating image
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress == 0
                              ? 'Let\'s start working on your goal!'
                              : progress == 1
                                  ? 'You have completed all your tasks!'
                                  : 'Your Daily Goal Almost Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          progress == 0
                              ? 'No tasks completed yet.'
                              : '$completedTasks of $totalTasks completed',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (progress != 0)
                LinearPercentIndicator(
                  lineHeight: 12.0,
                  percent: progress,
                  backgroundColor: Colors.white38,
                  progressColor: Colors.white,
                  barRadius: const Radius.circular(10),
                  animation: true,
                  animationDuration: 800,
                ),

              const SizedBox(height: 8),

              // Display percentage text only if progress is 0
              if (progress != 0)
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
            ],
          ),
        ),
        // The floating image positioned outside the container
        Positioned(
          top: progress == 0
              ? -30
              : -90, // Adjust to control how far the image floats up
          left: progress == 0 ? 10 : -20,
          child: Image.asset(
            progress == 0
                ? 'assets/images/neutral.png'
                : 'assets/images/happy.png',
            width: progress == 0 ? 160 : 220,
            height: progress == 0 ? 160 : 220,
          ),
        ),
      ],
    );
  }
}
