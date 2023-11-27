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

//Class Defining what a Habit is
class Habit {
  String title;
  String description;
  int value;
  IconData iconData;

  Habit({required this.title, required this.description, required this.value, required this.iconData});
}

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

//Main Page with the home menu and everything. Also includes the Add new habit dialog
class _HabitTrackerPageState extends State<HabitTrackerPage> {

  //Variable needed to update the icon in the add new dialog, since it doesn't handle state updates in the showDialog
  IconData? _selectedIcon;

  //Define the list of available icons to choose from
  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.book,
    Icons.music_note,
    Icons.work,
    // ... add more, potentially also custom icons and icons not from the Icons class
  ];
  // List storing all the user habits
  final List<Habit> _habits = [];

  //Self-explanatory: Add a new habit to the list
  void _addHabit(String title, String description, IconData icon) {
    if(title.isNotEmpty){
      setState(() {
        _habits.add(Habit(title: title, description: description, value: 0, iconData: icon));
      });
    }
  }

  //Render the stuff in the home menu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: ListView.builder(
        itemCount: (_habits.length / 2).ceil(), // Divide by 2 and round up
        itemBuilder: (context, index) {
          // Calculate the indices for the left and right habits
          int leftIndex = index * 2;
          int rightIndex = (index * 2) + 1;

          return Row(
            children: [
              if (leftIndex < _habits.length)
                _buildHabitCard(_habits[leftIndex]),
              if (rightIndex < _habits.length)
                _buildHabitCard(_habits[rightIndex]),
            ],
          );
        },
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
            // Handle the tap event
            print('Habit Pressed: ${habit.title}');
            setState(() {
              habit.value++;
            });
          },
          child: ListTile(
            leading: Icon(habit.iconData),
            title: Text(habit.title),
            subtitle: Text("Count: ${habit.value}"),
          ),
        ),
      ),
    );
  }

  //Add new Habit dialog
  Future<void> _showAddHabitDialog() async{ //The Dialog for adding a new habit
    TextEditingController titleController = TextEditingController();
    IconData selectedIcon = availableIcons.first;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog){
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
                    _addHabit(titleController.text, "Some description", selectedIcon);
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