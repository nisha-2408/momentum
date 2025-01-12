import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolution_tracker/constants/habits.dart';
import 'package:resolution_tracker/providers/auth.dart';

class AddHabitScreen extends StatefulWidget {
  static const routeName = '/add-habits';
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  final Set<int> selectedDays = {0, 4, 5};
  var selectedRepeat = 0;
  final List<int> _durations = [5, 10, 15, 30, 60, 90, 120];
  int _selectedDuration = 30;
  int _selectedIndexIcon = 0;
  final _blackListedActivity = [4, 5, 6, 9, 10];
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 0);

  void selectIcon(index) {
    setState(() {
      _selectedIndexIcon = index;
    });
  }

  var _isLoading = false;

  Future<void> _addHabit(BuildContext context) async {
    final userId = Provider.of<Auth>(context, listen: false).userId;
    final habitName = _habitController.text;
    final addDuration = !_blackListedActivity.contains(_selectedIndexIcon);
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance.collection("habits").add({
      'userId': userId,
      'name': habitName,
      'activity': _selectedIndexIcon,
      'repeat': selectedRepeat,
      'days': selectedDays,
      'time': _selectedTime.format(context),
      'duration': addDuration ? _selectedDuration : 0
    }).then((_) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop();
      });
    });
  }

  // Function to handle time selection
  Future<void> _pickTime(BuildContext context) async {
    final primaryColor = Theme.of(context).primaryColor;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        // Wrap the time picker in a custom Theme
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // Primary color for the picker
              onPrimary: Colors.white, // Text color on primary
              onSurface: Colors.black, // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor; // Cyan color
    final borderColor = primaryColor.withOpacity(0.5);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(9, 2, 9, 0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text("Add Habit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Habit Title",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    TextField(
                      controller: _habitController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Enter habit name',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Choose Activity",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    FitnessIconsGrid(
                      selectedIndex: _selectedIndexIcon,
                      onIconClicked: selectIcon,
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Repeat",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(repeat.length, (index) {
                        final isSelected = index == selectedRepeat;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRepeat = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            width: 100,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? primaryColor : borderColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              repeat[index],
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Days",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(days.length, (index) {
                        final isSelected = selectedDays.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedDays.remove(index);
                              } else {
                                selectedDays.add(index);
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            width: 40,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? primaryColor : borderColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              days[index],
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Select a specific time",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => _pickTime(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0F7FA), // Light cyan-like color
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _selectedTime
                            .format(context), // Formats time like 10:00 AM
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color:
                              Color(0xFF00BCD4), // Complementary to cyan color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!_blackListedActivity.contains(_selectedIndexIcon))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select Duration",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    DropdownButton<int>(
                      value: _selectedDuration,
                      items: _durations.map((int duration) {
                        return DropdownMenuItem<int>(
                          value: duration,
                          child: Text("$duration minutes"),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedDuration = newValue!;
                        });
                      },
                      dropdownColor: Color(0xFF2D2D2D),
                      icon:
                          Icon(Icons.arrow_drop_down, color: Color(0xFF00BCD4)),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      underline: Container(
                        height: 2,
                        color: Color(0xFF00BCD4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            if (_isLoading) {
              return;
            }
            // Define your logic to add a new habit here
            _addHabit(context);
          },
          label: Text(
            _isLoading ? "Adding Habit..." : "Add Habit",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor, // Button color
            minimumSize: const Size(200, 50), // Button size
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Rounded corners
            ),
          ),
        ),
      ),
    );
  }
}

class FitnessIconsGrid extends StatelessWidget {
  final int selectedIndex;
  final Function(int selectedIndex) onIconClicked;
  const FitnessIconsGrid(
      {super.key, required this.selectedIndex, required this.onIconClicked});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        height: 200, // Specify a fixed height for the GridView
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of items per row
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: icons.length, // Disable scrolling inside the GridView
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex; // Selected items
            return GestureDetector(
              onTap: () {
                onIconClicked(index);
              },
              child: CircleAvatar(
                backgroundColor:
                    isSelected ? primaryColor : primaryColor.withOpacity(0.3),
                radius: 30,
                child: Icon(
                  icons[index],
                  color: isSelected ? Colors.white : primaryColor,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
