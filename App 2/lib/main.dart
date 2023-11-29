import 'package:flutter/material.dart';
// flutter pub add dynamic_color
import 'package:dynamic_color/dynamic_color.dart';
// flutter pub add flutter_slidable -> cmd in project root
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Habit Tracker',
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: const HabitTrackerPage(),
        );
      },
    );
  }
}

// Class for the Statistics page
class HabitStatisticsPage extends StatefulWidget{
  final List<Habit> habits;

  const HabitStatisticsPage({Key? key, required this.habits}) : super(key: key);

  @override
  _HabitStatisticsPageState createState() => _HabitStatisticsPageState();
}

//Class Defining what a Habit is
class Habit {
  String title;
  String description;
  int value;
  IconData iconData;

  Habit(
      {required this.title,
      required this.description,
      required this.value,
      required this.iconData});
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
  //Last Habit that was deleted, used for UNDO function
  Habit _lastHabit =
      Habit(title: "no", description: "no", value: 0, iconData: Icons.book);
  //Self-explanatory: Add a new habit to the list
  void _addHabit(String title, String description, IconData icon) {
    if (title.isNotEmpty) {
      setState(() {
        _habits.add(Habit(
            title: title, description: description, value: 0, iconData: icon));
      });
    }
  }

  //Edits Habit at index

  void _editHabit(int index, String newTitle, IconData icon, int newValue) {
    setState(() {
      _lastHabit = _habits[index];
      _habits[index] = Habit(
          title: newTitle,
          description: _habits[index].description,
          value: newValue,
          iconData: icon);
    });
  }

  //Deletes Habit from list
  void _deleteHabit(int index) {
    setState(() {
      _lastHabit = _habits[index];
      _habits.removeAt(index);
    });
  }

  //Render the stuff in the home menu
  @override
  Widget build(BuildContext context) {

    // Get the current color scheme
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),

        //Navigation to the Statistics Page
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HabitStatisticsPage(habits: _habits)),
              );
            },
          ),
        ],
      ),

      //List with all the habits
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          //Cards are clickable!
          return Card(
              elevation: 4.0, //Shadow effect
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Slidable(
                // Specify a key if the Slidable is dismissible.
                key: UniqueKey(),
                // The end action pane is the one at the right side.
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {
                    _deleteHabit(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Deleted \"${_lastHabit.title}\""),
                        action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () => setState(
                                  () => _habits.insert(index, _lastHabit),
                                )),
                      ),
                    );
                  }),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        _editHabitDialog(index);
                      },
                      //backgroundColor: const Color(0xFF0392CF),
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        _deleteHabit(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Deleted \"${_lastHabit.title}\""),
                            action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () => setState(
                                      () => _habits.insert(index, _lastHabit),
                                    )),
                          ),
                        );
                      },
                      //backgroundColor: const Color(0xFFFE4A49),
                      backgroundColor: colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
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
              ));
        },
      ),

      //Add new Habit button
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  //Add new Habit dialog
  Future<void> _showAddHabitDialog() async {
    //The Dialog for adding a new habit
    TextEditingController titleController = TextEditingController();
    IconData selectedIcon = availableIcons.first;

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
                      items: availableIcons
                          .map<DropdownMenuItem<IconData>>((IconData value) {
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
                    _addHabit(
                        titleController.text, "Some description", selectedIcon);
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

  Future<void> _editHabitDialog(int index) async {
    //The Dialog for adding a new habit
    TextEditingController titleController =
        TextEditingController(text: _habits[index].title);
    TextEditingController numberController =
        TextEditingController(text: (_habits[index].value).toString());
    IconData selectedIcon = availableIcons.first;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit Habit'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: numberController,
                    ),
                    DropdownButton<IconData>(
                      value: _selectedIcon ?? _habits[index].iconData,
                      onChanged: (IconData? newValue) {
                        selectedIcon = newValue!;
                        setStateDialog(() => _selectedIcon = newValue);
                        setState(() => _selectedIcon = newValue);
                      },
                      items: availableIcons
                          .map<DropdownMenuItem<IconData>>((IconData value) {
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
                  child: const Text('Edit'),
                  onPressed: () {
                    _editHabit(index, titleController.text, selectedIcon,
                        int.parse(numberController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Edited \"${_lastHabit.title}\""),
                        action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () => setState(
                                  () {
                                    _habits.removeAt(index);
                                    _habits.insert(index, _lastHabit);
                                  },
                                )),
                      ),
                    );
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

// The Statistics Page
// More complex statistics can be added using fl_chart or charts_flutter
class _HabitStatisticsPageState extends State<HabitStatisticsPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Habit Statistcs"),
      ),
      body: ListView.builder(
        itemCount: widget.habits.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.habits[index].title),
            trailing: Text("Count: ${widget.habits[index].value}"),
          );
        },
      ),
    );
}
}
