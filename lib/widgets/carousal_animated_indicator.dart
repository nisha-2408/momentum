import 'package:flutter/material.dart';
import 'package:resolution_tracker/constants/onboard_screen.dart';

class AnimatedLine extends StatelessWidget {
  final bool isActive;

  const AnimatedLine({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width * 0.85;
    final double activeWidth =
        totalWidth * 1.5 / demoData.length; // 60% for active
    final double inactiveWidth = totalWidth * 0.6 / demoData.length;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? activeWidth : inactiveWidth,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey[400],
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class CarousalAnimatedIndicator extends StatelessWidget {
  final int selectedIndex;
  const CarousalAnimatedIndicator({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          demoData.length,
          (index) => Padding(
                padding: EdgeInsets.only(right: 8),
                child: AnimatedLine(isActive: index == selectedIndex),
              )),
    );
  }
}
