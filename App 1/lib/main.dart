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
  IconData iconData;

  Habit({
    required this.title,
    required this.description,
    required this.value,
    required this.iconData,
  });
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _originalHabits.addAll([
      Habit(title: 'Exercise', description: 'Morning workout', value: 0, iconData: Icons.fitness_center),
      Habit(title: 'Reading', description: 'Read a book', value: 0, iconData: Icons.book),
      Habit(title: 'Music', description: 'Play an instrument', value: 0, iconData: Icons.music_note),
      Habit(title: 'Work', description: 'Complete tasks', value: 0, iconData: Icons.work),
    ]);

    _habits.addAll(_originalHabits);
  }

  void _addHabit(String title, String description, IconData icon) {
    if (title.isNotEmpty) {
      setState(() {
        _habits.add(Habit(title: title, description: description, value: 0, iconData: icon));
      });
    }
  }

  void _filterSearchResults(String query) {
    List<Habit> searchResults = [];

    if (query.isNotEmpty) {
      searchResults.addAll(_originalHabits
          .where((habit) => habit.title.toLowerCase().contains(query.toLowerCase()))
          .toList());
    } else {
      searchResults.addAll(_originalHabits);
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
          child: ListTile(
            leading: Icon(habit.iconData),
            title: Text(habit.title),
            subtitle: Text("Count: ${habit.value}"),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddHabitDialog() async {
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

class HabitSearchDelegate extends SearchDelegate<Habit> {
  final List<Habit> habits;
  final List<Habit> originalHabits;

  HabitSearchDelegate(this.habits, this.originalHabits);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Reset _habits to the original list when the search is canceled
        habits.clear();
        habits.addAll(originalHabits);
        close(context, Habit(title: 'No Selection', description: '', value: 0, iconData: Icons.error));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    List<Habit> searchResults = habits
        .where((habit) => habit.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].title),
          onTap: () {
            // Fix the issue by providing a single Habit object, not a list
            close(context, searchResults[index]);
          },
        );
      },
    );
  }
}
