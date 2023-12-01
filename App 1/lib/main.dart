import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HabitTrackerPage(),
    );
  }
}

class Habit {
  String title;
  String description;
  int value;
  String? unitValue;
  IconData iconData;
  Unit? unit; // New property
  bool clicked;
  int num_iterations;
  int limit_iterations;
  String timeUnit;
  Color color;
  Color flameColor;

  Habit({
    required this.title,
    required this.description,
    required this.value, //counts the amount of successful habit completions
    required this.iconData,
    this.unitValue, //Duration/length actual number
    this.unit, //Duration/Length unit
    required this.clicked,
    required this.num_iterations, //how many times habit has been done
    required this.limit_iterations, //number of times habit has to be completed for value to increase
    required this.timeUnit, //time limit to accomplish habit
    required this.color,
    required this.flameColor,
  });
}

enum Unit {
  Duration,
  Length,
}

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  IconData? _selectedIcon;
  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.book,
    Icons.music_note,
    Icons.work,
    Icons.sports_baseball,
    Icons.water_drop,
  ];
  final List<Habit> _originalHabits = [];
  final List<Habit> _habits = [];
  final List<Habit> oldHabits = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _originalHabits.addAll([
      Habit(
        title: 'Walk',
        description: 'Morning workout',
        value: 0,
        unitValue: "10",
        unit: Unit.Length,
        iconData: Icons.fitness_center,
        clicked: false,
        num_iterations: 0,
        limit_iterations: 10,
        timeUnit: "day",
        color: getRandomPastelColor(),
        flameColor: getRandomPastelColor2(),
      ),
      Habit(
        title: 'Reading',
        description: 'Read a book',
        value: 0,
        unitValue: "30",
        unit: Unit.Duration,
        iconData: Icons.book,
        clicked: false,
        num_iterations: 0,
        limit_iterations: 10,
        timeUnit: "week",
        color: getRandomPastelColor(),
        flameColor: getRandomPastelColor2(),
      ),
      Habit(
        title: 'Music',
        description: 'Play an instrument',
        value: 0,
        unitValue: "15",
        unit: Unit.Duration,
        iconData: Icons.music_note,
        clicked: false,
        num_iterations: 0,
        limit_iterations: 10,
        timeUnit: "week",
        color: getRandomPastelColor(),
        flameColor: getRandomPastelColor2(),
      ),
      Habit(
        title: 'Work',
        description: 'Complete tasks',
        value: 0,
        unitValue: "5",
        unit: Unit.Duration,
        iconData: Icons.work,
        clicked: false,
        num_iterations: 0,
        limit_iterations: 10,
        timeUnit: "week",
        color: getRandomPastelColor(),
        flameColor: getRandomPastelColor2(),
      ),
    ]);

    _habits.addAll(_originalHabits);

    oldHabits.addAll(_originalHabits);
  }

  // selects cards and flame color from preset list
  List<Color> colors = [
    Color(0xFFFFF9C4), // Light Yellow
    Color(0xFFFFE0B2), // Light Orange
    Color(0xFFFFCCBC), // Light Deep Orange
    Color(0xFFFFCDD2), // Light Red
    Color(0xFFF8BBD0), // Light Pink
    Color(0xFFE1BEE7), // Light Purple
    Color(0xFFD1C4E9), // Light Deep Purple
    Color(0xFFC5CAE9), // Light Indigo
    Color(0xFFBBDEFB), // Light Blue
    Color(0xFFB3E0F2), // Light Light Blue
    Color(0xFFB2EBF2), // Light Cyan
    Color(0xFFB2DFDB), // Light Teal
    Color(0xFFC8E6C9), // Light Green
    Color(0xFFDCEDC8), // Light Light Green
    Color(0xFFF0F4C3), // Light Lime
  ];
  List<Color> flameColors = [
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFF9800), // Orange
    Color(0xFFFF5722), // Deep Orange
    Color(0xFFF44336), // Red
    Color(0xFFE91E63), // Pink
    Color.fromARGB(255, 245, 88, 232), // Purple
    Color(0xFF673AB7), // Deep Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF2196F3), // Blue
    Color(0xFF03A9F4), // Light Blue
    Color(0xFF00BCD4), // Cyan
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
  ];

  int currentIndex = 0;

  Color getRandomPastelColor() {
    Color color = colors[currentIndex];
    currentIndex = (currentIndex + 1) % colors.length;
    return color; // Adjust opacity to make it lighter
  }

  int currentIndex2 = 0;

  Color getRandomPastelColor2() {
    Color color = flameColors[currentIndex];
    currentIndex = (currentIndex + 1) % flameColors.length;
    return color; // Adjust opacity to make it lighter
  }

  // end of color defs

  void _addHabit(
      String title,
      String description,
      String unitValue,
      Unit unit,
      IconData icon,
      int num_iterations,
      int limit_iterations,
      String timeUnit) {
    if (title.isNotEmpty) {
      Color c = getRandomPastelColor();
      Color flameC = getRandomPastelColor2();
      setState(() {
        _habits.add(Habit(
          title: title,
          description: description,
          value: 0,
          unitValue: unitValue,
          unit: unit,
          iconData: icon,
          clicked: false,
          num_iterations: num_iterations,
          limit_iterations: limit_iterations,
          timeUnit: timeUnit,
          color: c,
          flameColor: flameC,
        ));
        oldHabits.add(Habit(
          title: title,
          description: description,
          value: 0,
          unitValue: unitValue,
          unit: unit,
          iconData: icon,
          clicked: false,
          num_iterations: num_iterations,
          limit_iterations: limit_iterations,
          timeUnit: timeUnit,
          color: c,
          flameColor: flameC,
        ));
      });
    }
  }

  /*Habit deepCopyHabit(Habit originalHabit) {
    return Habit(
      title: originalHabit.title,
      description: originalHabit.description,
      value: originalHabit.value,
      unitValue: originalHabit.unitValue,
      iconData: originalHabit.iconData
    );
  }  */
  void _filterSearchResults(String query) {
    List<Habit> searchResults = [];

    if (query.isNotEmpty) {
      searchResults.addAll(oldHabits
          .where((habit) =>
              habit.title.toLowerCase().contains(query.toLowerCase()))
          .toList());
    } else {
      searchResults.addAll(oldHabits);
    }

    setState(() {
      _habits.clear();
      _habits.addAll(searchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(
              top: 30, bottom: 10), // Adjust top and bottom padding
          child: Text(
            'Habits',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'SFProDisplay',
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 16), // Adjust vertical padding
            child: Container(
              width: 370.0,
              height: 35,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _filterSearchResults(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search habits...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 229, 229, 229),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  // Other customization properties
                ),
              ),
            ),
          ),
          SizedBox(height: 7), // Add space between search bar and habit cards
          Expanded(
            child: ListView.builder(
              itemCount: (_habits.length / 2).ceil(),
              itemBuilder: (context, index) {
                int leftIndex = index * 2;
                int rightIndex = (index * 2) + 1;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4), // Adjust the horizontal padding
                  child: Row(
                    children: [
                      if (leftIndex < _habits.length)
                        _buildHabitCard(_habits[leftIndex]),
                      if (rightIndex < _habits.length)
                        _buildHabitCard(_habits[rightIndex]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    return Expanded(
      child: Card(
        elevation: 6.0,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: habit.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              15.0), // Increase this value for more rounding
        ),
        child: InkWell(
          onTap: () {
            // print('Habit Pressed: ${habit.title}');
            setState(() {
              habit.num_iterations++;
              habit.value +=
                  (habit.num_iterations / habit.limit_iterations).floor();
              habit.num_iterations =
                  habit.num_iterations % habit.limit_iterations;
              habit.clicked = habit.value > 0;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title, icon, and unit information
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side with title and icon
                    Row(
                      children: [
                        Icon(habit.iconData),
                        const SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            if (habit.unitValue != null &&
                                habit.unitValue != "")
                              Text(
                                  "${habit.unitValue} ${habit.unit == Unit.Duration ? 'min' : 'km'}"),
                          ],
                        ),
                      ],
                    ),
                    // Right side with green checkmark if habit is clicked
                    if (habit.clicked)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: habit.flameColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.check, color: habit.color),
                        ),
                      ),
                    // Right side with three dots if habit is not clicked
                    GestureDetector(
                      onTap: () {
                        _showDetailsPage(context, habit);
                      },
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
              // Count, flame, and "days" text below the title and icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${habit.value}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Icon(
                          Icons.whatshot,
                          color: habit.flameColor,
                        ),
                      ],
                    ),

                    //adding the new limit_iterations and iterations
                    Text(
                      '${habit.num_iterations} / ${habit.limit_iterations} per ${habit.timeUnit}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateHabit(Habit updatedHabit) {
    setState(() {
      final habitIndex = _habits.indexOf(updatedHabit);
      if (habitIndex != -1) {
        oldHabits[habitIndex].title = updatedHabit.title;
        oldHabits[habitIndex].description = updatedHabit.description;
        oldHabits[habitIndex].iconData = updatedHabit.iconData;
        oldHabits[habitIndex].value = updatedHabit.value;
        oldHabits[habitIndex].unit = updatedHabit.unit;
      }
    });
  }

  void deleteHabit(Habit habit) {
    setState(() {
      _habits.remove(habit);
      oldHabits.remove(habit);
    });
  }

  void _showDetailsPage(BuildContext context, Habit habit) async {
    final updatedHabit = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          habit: habit,
          availableIcons: availableIcons,
          deleteHabitCallback: deleteHabit,
        ),
      ),
    );

    // Check if the habit was updated
    if (updatedHabit != null) {
      updateHabit(updatedHabit);
    }
  }

  Future<void> _showAddHabitDialog() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    IconData selectedIcon = availableIcons.first;
    TextEditingController selectedValue = TextEditingController();
    Unit selectedUnit = Unit.Duration;
    TextEditingController limit_iterationsController = TextEditingController();
    String selectedTimeUnit = "day";

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add New Habit'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DropdownButton<IconData>(
                          value: _selectedIcon ?? availableIcons.first,
                          onChanged: (IconData? newValue) {
                            selectedIcon = newValue!;
                            setStateDialog(() => _selectedIcon = newValue);
                            setState(() => _selectedIcon = newValue);
                          },
                          items: availableIcons.map<DropdownMenuItem<IconData>>(
                              (IconData value) {
                            return DropdownMenuItem<IconData>(
                              value: value,
                              child: Icon(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    // number of times habit is done per time unit
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: limit_iterationsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Habit Frequency per'),
                          ),
                        ),
                        DropdownButton<String>(
                          value:
                              selectedTimeUnit, // This is crucial for displaying the selected value
                          onChanged: (String? newValue) {
                            setStateDialog(() {
                              selectedTimeUnit = newValue!;
                            });
                          },
                          items: <String>['day', 'week', 'month']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: selectedValue,
                            decoration: const InputDecoration(
                                labelText: 'Amount/Duration'),
                          ),
                        ),
                        DropdownButton<Unit>(
                          value: selectedUnit,
                          onChanged: (Unit? newValue) {
                            setStateDialog(() {
                              selectedUnit = newValue!;
                              // Set selectedUnit based on the selected label
                              selectedUnit = (newValue == Unit.Duration)
                                  ? Unit.Duration
                                  : Unit.Length;
                            });
                          },
                          items: Unit.values
                              .map<DropdownMenuItem<Unit>>((Unit value) {
                            return DropdownMenuItem<Unit>(
                              value: value,
                              child:
                                  Text(value == Unit.Duration ? 'min' : 'km'),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    _addHabit(
                        titleController.text,
                        descriptionController.text,
                        selectedValue.text,
                        selectedUnit,
                        selectedIcon,
                        0,
                        int.tryParse(limit_iterationsController.text) ?? 0,
                        selectedTimeUnit);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Details

class DetailsPage extends StatefulWidget {
  final Habit habit;
  final List<IconData> availableIcons;
  final Function(Habit) deleteHabitCallback;

  const DetailsPage({
    super.key,
    required this.habit,
    required this.availableIcons,
    required this.deleteHabitCallback,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController selectedTitle;
  late TextEditingController selectedDescription;
  late IconData selectedIcon;
  late TextEditingController selectedValue;
  late Unit? selectedUnit;
  late TextEditingController maxValue;
  late TextEditingController maxStreak;

  @override
  void initState() {
    super.initState();
    selectedDescription = TextEditingController(text: widget.habit.description);
    selectedTitle = TextEditingController(text: widget.habit.title);
    selectedIcon = widget.habit.iconData;
    selectedValue = TextEditingController(text: widget.habit.unitValue);
    selectedUnit = widget.habit.unit;
    maxValue =
        TextEditingController(text: (widget.habit.num_iterations).toString());
    maxStreak = TextEditingController(text: (widget.habit.value).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Set the color to black
          onPressed: () {
            Navigator.pop(context); // Add the navigation action you need
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(
            top: 3,
            bottom: 0,
            left: 2.0, // Add left padding to separate the arrow icon
          ),
          child: Text(
            ('Editing ${widget.habit.title}'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'SFProDisplay',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: selectedTitle,
              decoration: const InputDecoration(labelText: 'Title: '),
            ),
            TextField(
              controller: selectedDescription,
              decoration: const InputDecoration(labelText: 'Description: '),
            ),
            DropdownButton<IconData>(
              value: selectedIcon,
              onChanged: (IconData? newValue) {
                setState(() {
                  selectedIcon = newValue!;
                });
              },
              items: widget.availableIcons
                  .map<DropdownMenuItem<IconData>>((IconData value) {
                return DropdownMenuItem<IconData>(
                  value: value,
                  child: Icon(value),
                );
              }).toList(),
            ),

            // amount and duration was deleted since changing these options
            // would also change the meaning of the current statistics observed

            // decrease current counter and update value
            TextField(
              controller: maxValue,
              decoration:
                  const InputDecoration(labelText: 'Current Progress: '),
            ),
            TextField(
              controller: maxStreak,
              decoration:
                  const InputDecoration(labelText: 'Current Streak: '),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.deleteHabitCallback(widget.habit);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 9.0, horizontal: 16.0), // change values
                    ),
                    child: const Text('delete habit')),
                ElevatedButton(
                  onPressed: () {
                    widget.habit.title = selectedTitle.text;
                    widget.habit.description = selectedDescription.text;
                    widget.habit.iconData = selectedIcon;
                    widget.habit.unitValue = selectedValue.text;
                    widget.habit.unit = selectedUnit;
                    widget.habit.num_iterations = int.tryParse(maxValue.text) ??
                        0; //could be changed that if value is increased compared to before that a pop-up will appear
                    widget.habit.value = int.tryParse(maxStreak.text) ??
                        0;
                    widget.habit.num_iterations = widget.habit.num_iterations %
                        widget.habit.limit_iterations;
                    Navigator.pop(
                        context, widget.habit); // Return the updated habit
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
