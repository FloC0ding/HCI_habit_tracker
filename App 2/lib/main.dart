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
class HabitStatisticsPage extends StatefulWidget {
  final List<Habit> habits;

  const HabitStatisticsPage({Key? key, required this.habits}) : super(key: key);

  @override
  _HabitStatisticsPageState createState() => _HabitStatisticsPageState();
}

//Class Defining what a Habit is
class Habit {
  String title;
  String description;
  double value;
  IconData iconData;
  String unit;
  double requiredValue;
  String timeUnit;
  double requiredTime;
  int streak;

  Habit(
      {required this.title,
      required this.description,
      required this.value,
      required this.iconData,
      required this.unit,
      required this.requiredValue,
      required this.timeUnit,
      required this.requiredTime,
      required this.streak});
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
  final TextEditingController _searchController = TextEditingController();
  //Define the list of available icons to choose from
  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.book,
    Icons.music_note,
    Icons.work,
    Icons.directions_run,
    Icons.directions_bike,
    // ... add more, potentially also custom icons and icons not from the Icons class
  ];
  // List storing all the user habits
  final List<Habit> _habits = [
    Habit(
        title: "Go Running",
        description: "Go Running",
        value: 0,
        iconData: Icons.directions_run,
        unit: "km",
        requiredValue: 13.37,
        timeUnit: "days",
        requiredTime: 2,
        streak: 0),
    Habit(
        title: "Sing",
        description: "Sing",
        value: 0,
        iconData: Icons.music_note,
        unit: "times",
        requiredValue: 12,
        timeUnit: "months",
        requiredTime: 1,
        streak: 0),
    Habit(
        title: "Go to Work",
        description: "Go to Work",
        value: 0,
        iconData: Icons.work,
        unit: "times",
        requiredValue: 5,
        timeUnit: "weeks",
        requiredTime: 1,
        streak: 0),
    Habit(
        title: "Read",
        description: "Read",
        value: 0,
        iconData: Icons.book,
        unit: "min",
        requiredValue: 45,
        timeUnit: "days",
        requiredTime: 1,
        streak: 0),
  ];
  final List<Habit> _filteredhabits = [
    Habit(
        title: "Go Running",
        description: "Go Running",
        value: 0,
        iconData: Icons.directions_run,
        unit: "km",
        requiredValue: 13.37,
        timeUnit: "days",
        requiredTime: 2,
        streak: 0),
    Habit(
        title: "Play Instrument",
        description: "Play Instrument",
        value: 0,
        iconData: Icons.music_note,
        unit: "times",
        requiredValue: 12,
        timeUnit: "months",
        requiredTime: 1,
        streak: 0),
    Habit(
        title: "Go to Work",
        description: "Go to Work",
        value: 0,
        iconData: Icons.work,
        unit: "times",
        requiredValue: 5,
        timeUnit: "weeks",
        requiredTime: 1,
        streak: 0),
    Habit(
        title: "Read",
        description: "Read",
        value: 0,
        iconData: Icons.work,
        unit: "min",
        requiredValue: 45,
        timeUnit: "days",
        requiredTime: 1,
        streak: 0),
  ];
  //Last Habit that was deleted, used for UNDO function
  Habit _lastHabit = Habit(
      title: "no",
      description: "no",
      value: 0,
      iconData: Icons.book,
      requiredValue: 1,
      unit: "",
      requiredTime: 1,
      timeUnit: "",
      streak: 0);
  //Self-explanatory: Add a new habit to the list
  void _addHabit(String title, String description, IconData icon, String unit,
      double requiredValue, String timeUnit, double requiredTime) {
    if (title.isNotEmpty) {
      setState(() {
        _habits.add(Habit(
            title: title,
            description: description,
            value: 0,
            iconData: icon,
            requiredValue: requiredValue,
            unit: unit,
            requiredTime: requiredTime,
            timeUnit: timeUnit,
            streak: 0));
        _filteredhabits.add(Habit(
            title: title,
            description: description,
            value: 0,
            iconData: icon,
            requiredValue: requiredValue,
            unit: unit,
            requiredTime: requiredTime,
            timeUnit: timeUnit,
            streak: 0));
      });
    }
  }

  //Edits Habit at index

  void _editHabit(
      int index,
      String newTitle,
      IconData icon,
      double newValue,
      String unit,
      double requiredValue,
      String timeUnit,
      double requiredTime,
      int streak) {
    setState(() {
      _lastHabit = _habits[index];
      _habits[index] = Habit(
          title: newTitle,
          description: _habits[index].description,
          value: newValue,
          iconData: icon,
          unit: unit,
          requiredValue: requiredValue,
          requiredTime: requiredTime,
          timeUnit: timeUnit,
          streak: streak);
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

    void _filterSearchResults(String query) {
      List<Habit> searchResults = [];

      if (query.isNotEmpty) {
        searchResults.addAll(_filteredhabits
            .where((habit) =>
                habit.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
      } else {
        searchResults.addAll(_filteredhabits);
      }

      setState(() {
        _habits.clear();
        _habits.addAll(searchResults);
      });
    }

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
                MaterialPageRoute(
                    builder: (context) => HabitStatisticsPage(habits: _habits)),
              );
            },
          ),
        ],
      ),

      //List with all the habits
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
          SizedBox(height: 7),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                //Cards are clickable!
                return Card(
                    elevation: 4.0, //Shadow effect
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  content:
                                      Text("Deleted \"${_lastHabit.title}\""),
                                  action: SnackBarAction(
                                      label: "UNDO",
                                      onPressed: () => setState(
                                            () => _habits.insert(
                                                index, _lastHabit),
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
                            if (_habits[index].unit == "times") {
                              _habits[index].value++;
                              if (_habits[index].value >=
                                  _habits[index].requiredValue) {
                                _editHabit(
                                    index,
                                    _habits[index].title,
                                    _habits[index].iconData,
                                    _habits[index].value -
                                        _habits[index].requiredValue,
                                    _habits[index].unit,
                                    _habits[index].requiredValue,
                                    _habits[index].timeUnit,
                                    _habits[index].requiredTime,
                                    _habits[index].streak + 1);
                              }
                            } else {
                              _showSetAmountDialog(index);
                            }
                          });
                        },
                        child: ListTile(
                          leading: Icon(_habits[index].iconData),
                          title: Text(_habits[index].title),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${_habits[index].value == _habits[index].value.toInt() ? _habits[index].value.toInt() : _habits[index].value.toStringAsFixed(1)} / ${_habits[index].requiredValue == _habits[index].requiredValue.toInt() ? _habits[index].requiredValue.toInt() : _habits[index].requiredValue.toStringAsFixed(1)} ${_habits[index].unit == "times" && _habits[index].requiredValue == 1 ? "time" : _habits[index].unit} every ${_habits[index].requiredTime == 1 ? "" : (_habits[index].requiredTime == _habits[index].requiredTime.toInt() ? _habits[index].requiredTime.toInt() : _habits[index].requiredTime.toStringAsFixed(1))} ${_habits[index].requiredTime == 1 && _habits[index].timeUnit.isNotEmpty ? _habits[index].timeUnit.substring(0, _habits[index].timeUnit.length - 1) : _habits[index].timeUnit}"),
                              Row(
                                children: [
                                  Text(
                                    "${_habits[index].streak}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.whatshot,
                                    color: colorScheme.tertiary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //Text("${_habits[index].value} / ${_habits[index].requiredValue} ${_habits[index].unit}"),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
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
    TextEditingController requiredController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    String selectedTimeUnit = "days";
    String selectedUnit = "times";

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
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Complete every"),
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedTimeUnit,
                          onChanged: (String? newValue) {
                            setStateDialog(() {
                              selectedTimeUnit = newValue!;
                            });
                          },
                          items: ["days", "weeks", "months"]
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
                            controller: requiredController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: "Amount"),
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedUnit,
                          onChanged: (String? newValue) {
                            setStateDialog(() {
                              selectedUnit = newValue!;
                            });
                          },
                          items: ["times", "km", "min"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
                        "Some description",
                        selectedIcon,
                        selectedUnit,
                        double.parse(requiredController.text),
                        selectedTimeUnit,
                        double.parse(timeController.text));
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
    TextEditingController requiredController =
        TextEditingController(text: (_habits[index].requiredValue.toString()));
    TextEditingController timeController =
        TextEditingController(text: (_habits[index].requiredTime.toString()));
    String selectedUnit = _habits[index].unit;
    String selectedTimeUnit = _habits[index].timeUnit;
    TextEditingController streakController =
        TextEditingController(text: (_habits[index].streak.toString()));

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
                      decoration: const InputDecoration(labelText: 'Current Progress'),
                      keyboardType: TextInputType.number,
                      controller: numberController,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Current Streak'),
                      keyboardType: TextInputType.number,
                      controller: streakController,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedTimeUnit,
                          onChanged: (String? newValue) {
                            setStateDialog(() {
                              selectedTimeUnit = newValue!;
                            });
                          },
                          items: ["days", "weeks", "months"]
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
                            controller: requiredController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedUnit,
                          onChanged: (String? newValue) {
                            setStateDialog(() {
                              selectedUnit = newValue!;
                            });
                          },
                          items: ["times", "km", "min"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
                  child: const Text('Edit'),
                  onPressed: () {
                    _editHabit(
                        index,
                        titleController.text,
                        selectedIcon,
                        double.parse(numberController.text),
                        selectedUnit,
                        double.parse(requiredController.text),
                        selectedTimeUnit,
                        double.parse(timeController.text),
                        int.parse(streakController.text));
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

  Future<void> _showSetAmountDialog(int index) async {
    TextEditingController amountController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Record Habit'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: amountController,
                    ),
                    Text("${_habits[index].unit}"),
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
                    if (double.parse(amountController.text) +
                            _habits[index].value >=
                        _habits[index].requiredValue) {
                      _editHabit(
                          index,
                          _habits[index].title,
                          _habits[index].iconData,
                          double.parse(amountController.text) +
                              _habits[index].value -
                              _habits[index].requiredValue,
                          _habits[index].unit,
                          _habits[index].requiredValue,
                          _habits[index].timeUnit,
                          _habits[index].requiredTime,
                          _habits[index].streak + 1);
                    } else {
                      _editHabit(
                          index,
                          _habits[index].title,
                          _habits[index].iconData,
                          double.parse(amountController.text) +
                              _habits[index].value,
                          _habits[index].unit,
                          _habits[index].requiredValue,
                          _habits[index].timeUnit,
                          _habits[index].requiredTime,
                          _habits[index].streak);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Recorded \"${_lastHabit.title}\""),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Habit Statistics"),
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
