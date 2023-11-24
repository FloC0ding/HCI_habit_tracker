import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HabitTrackerPage(),
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
        title: Text('Habit Tracker'),
      ),

      //List with all the habits
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {

          //Cards are clickable!
          return Card(
            elevation: 4.0, //Shadow effect
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              onTap: () {
                // Handle the tap event
                print('Habit Pressed: ${_habits[index].title}');
                setState(() {
                  _habits[index].value++;
                });
              },
              child: ListTile(
                leading: Icon(_habits[index].iconData),
                title: Text(_habits[index].title),
                subtitle: Text("Count: ${_habits[index].value}"),
              ),
            ),
          );
        },
      ),

      //Add new Habit button
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: Icon(Icons.add),
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
              title: Text('Add New Habit'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
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
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
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