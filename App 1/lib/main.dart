import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  Habit({
    required this.title,
    required this.description,
    required this.value,
    required this.iconData,
    this.unitValue,
    this.unit, // Initialize to null
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
  ];
  final List<Habit> _originalHabits = [];
  final List<Habit> _habits = [];
  final List<Habit> oldHabits = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _originalHabits.addAll([
      Habit(title: 'Walk', description: 'Morning workout', value: 0, unitValue: "10" , unit : Unit.Length, iconData: Icons.fitness_center),
      Habit(title: 'Reading', description: 'Read a book', value: 0, unitValue: "30", unit : Unit.Duration, iconData: Icons.book),
      Habit(title: 'Music', description: 'Play an instrument', value: 0, unitValue: "15", unit : Unit.Duration, iconData: Icons.music_note),
      Habit(title: 'Work', description: 'Complete tasks', value: 0, unitValue: "5", unit : Unit.Duration, iconData: Icons.work),
    ]);

    _habits.addAll(_originalHabits);
    oldHabits.addAll(_originalHabits);
  }

  void _addHabit(String title, String description, String unitValue, Unit unit, IconData icon) {
    if (title.isNotEmpty) {
      setState(() {
        _habits.add(Habit(title: title, description: description, value: 0, unitValue: unitValue, unit : unit, iconData: icon));
        oldHabits.add(Habit(title: title, description: description, value: 0, unitValue: unitValue, unit : unit, iconData: icon));
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
          .where((habit) => habit.title.toLowerCase().contains(query.toLowerCase()))
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
        title: const Text('Habit Tracker'),
        
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              _filterSearchResults(value);
            },
            decoration: const InputDecoration(
              labelText: 'Search',
              hintText: 'Search habits...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (_habits.length / 2).ceil(),
              itemBuilder: (context, index) {
                int leftIndex = index * 2;
                int rightIndex = (index * 2) + 1;
                return Row(
                  children: [
                    if (leftIndex < _habits.length) _buildHabitCard(_habits[leftIndex]),
                    if (rightIndex < _habits.length) _buildHabitCard(_habits[rightIndex]),
                  ],
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
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () {
          print('Habit Pressed: ${habit.title}');
          setState(() {
            habit.value++;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title, unitValue, and unit on the same height
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${habit.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Adjust the font size as needed
                        ),
                      ),
                      if (habit.unitValue != null && habit.unitValue != "")
                        Text("${habit.unitValue} ${habit.unit == Unit.Duration ? 'min' : 'km'}"),
                    ],
                  ),
                  // Three vertical dots for details
                  GestureDetector(
                    onTap: () {
                      _showDetailsPage(context, habit);
                    },
                    child: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            // Count, flame, and "days" text below the title and unit
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${habit.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0, // Adjust the font size as needed
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Icon(
                    Icons.whatshot,
                    color: Colors.orange,
                  ),
                  Text(" days"),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


void _showDetailsPage(BuildContext context, Habit habit) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailsPage(habit: habit),
    ),
  );
}


 




  Future<void> _showAddHabitDialog() async {
    TextEditingController titleController = TextEditingController();
    IconData selectedIcon = availableIcons.first;
    TextEditingController selectedValue = TextEditingController();
    Unit selectedUnit = Unit.Duration;

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
                    DropdownButton<IconData>(
                      value: _selectedIcon ?? availableIcons.first,
                      onChanged: (IconData? newValue) {
                        selectedIcon = newValue!;
                        setStateDialog(() => _selectedIcon = newValue);
                        setState(() => _selectedIcon = newValue);
                      },
                      items: availableIcons.map<DropdownMenuItem<IconData>>((IconData value) {
                        return DropdownMenuItem<IconData>(
                          value: value,
                          child: Icon(value),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: selectedValue,
                            decoration: const InputDecoration(labelText: 'Amount/Duration'),
                          ),
                        ),
                        DropdownButton<Unit>(
                          value: selectedUnit,
                          onChanged: (Unit? newValue) {
                            setStateDialog(() {
                              selectedUnit = newValue!;
                              // Set selectedUnit based on the selected label
                              selectedUnit = (newValue == Unit.Duration) ? Unit.Duration : Unit.Length;
                            });
                          },
                          items: Unit.values.map<DropdownMenuItem<Unit>>((Unit value) {
                            return DropdownMenuItem<Unit>(
                              value: value,
                              child: Text(value == Unit.Duration ? 'min' : 'km'),
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
                    _addHabit(titleController.text, "Some description", selectedValue.text, selectedUnit, selectedIcon);
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

class DetailsPage extends StatefulWidget {
  final Habit habit;

  const DetailsPage({required this.habit});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  late TextEditingController selectedDescription;
  Unit selectedUnit = Unit.Duration;

  @override
  void initState() {
    super.initState();
    selectedDescription = TextEditingController(text: widget.habit.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editing ${widget.habit.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded (
              child: TextField(
                controller: selectedDescription,
                decoration: const InputDecoration(labelText: 'Description: '), 
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the home page
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
