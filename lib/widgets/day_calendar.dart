import 'package:flutter/material.dart';

class DayCalendar extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime day) setSelectedDay;
  const DayCalendar(
      {super.key, required this.selectedDay, required this.setSelectedDay});

  @override
  State<DayCalendar> createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar> {
  final DateTime _startDay = DateTime(2025, 1, 1); // Start of the calendar
  final DateTime _endDay = DateTime(2025, 12, 31); // End of the calendar
  late final ScrollController _scrollController;

  var _focussedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Calculate the initial scroll offset based on the focused day's index
    final initialIndex = _focussedDay.difference(_startDay).inDays;
    _scrollController = ScrollController(
      initialScrollOffset: initialIndex * 68.0, // Adjust item width + margin
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2D2D2D),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row to display month on the left and year on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getMonthName(_focussedDay),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _focussedDay.year.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Display days with weekday name in a horizontally scrollable grid
            SizedBox(
              height: 100, // Set a fixed height for the calendar
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _calculateItemCount(),
                itemBuilder: (ctx, index) {
                  DateTime day = _calculateDay(index);

                  // Get the weekday name
                  String weekdayName = _getWeekdayName(day);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _focussedDay = day;
                      });
                      widget.setSelectedDay(day);
                    },
                    child: Container(
                      width: 60, // Width for each day (adjust as needed)
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSameDay(widget.selectedDay, day)
                            ? Theme.of(context).primaryColor
                            : isSameDay(DateTime.now(), day)
                                ? Color(0xFF0097A7)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSameDay(widget.selectedDay, day)
                            ? null
                            : isSameDay(DateTime.now(), day)
                                ? null
                                : Border.all(color: Colors.grey, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weekdayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateItemCount() {
    return _endDay.difference(_startDay).inDays + 1;
  }

  DateTime _calculateDay(int index) {
    return _startDay.add(Duration(days: index));
  }

  String _getWeekdayName(DateTime day) {
    List<String> weekdayNames = [
      'PL', // Placeholder for 0 index (not used)
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return weekdayNames[day.weekday];
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthName(DateTime day) {
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[day.month - 1];
  }
}
