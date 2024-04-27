import 'package:flutter/material.dart';

// Define a Task class to represent individual tasks
class Task {
  final String id;
  final String taskText;
  bool isDone;

  Task({
    required this.id,
    required this.taskText,
    this.isDone = false,
  });
}

// Define a TaskItem widget to display individual tasks
class TaskItem extends StatelessWidget {
  final Task task;
  final Function(Task) onTaskChanged;
  final Function(String) onDeleteItem;

  TaskItem({
    required this.task,
    required this.onTaskChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.taskText),
      leading: Checkbox(
        value: task.isDone,
        onChanged: (value) {
          onTaskChanged(task);
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          onDeleteItem(task.id);
        },
      ),
    );
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasksList = [
    Task(id: '1', taskText: 'Task 1'),
    Task(id: '2', taskText: 'Task 2', isDone: true),
    Task(id: '3', taskText: 'Task 3'),
  ];
  List<Task> _filteredTasks = [];
  TaskCategory _selectedCategory = TaskCategory.all;

  @override
  void initState() {
    _updateTasks();
    super.initState();
  }

  void _updateTasks() {
    setState(() {
      switch (_selectedCategory) {
        case TaskCategory.all:
          _filteredTasks = tasksList;
          break;
        case TaskCategory.completed:
          _filteredTasks = tasksList.where((task) => task.isDone).toList();
          break;
        case TaskCategory.pending:
          _filteredTasks = tasksList.where((task) => !task.isDone).toList();
          break;
      }
    });
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.isDone = !task.isDone;
      _updateTasks();
    });
  }

  void _deleteTask(String id) {
    setState(() {
      tasksList.removeWhere((task) => task.id == id);
      _updateTasks();
    });
  }

  void _showAddTaskDialog(BuildContext context) async {
    String newTaskText = '';

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTaskText = value;
            },
            decoration: InputDecoration(hintText: 'Enter task...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNewTask(newTaskText);
                Navigator.pop(dialogContext);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewTask(String taskText) {
    if (taskText.isNotEmpty) {
      String newTaskId = UniqueKey().toString();

      Task newTask = Task(
        id: newTaskId,
        taskText: taskText,
        isDone: false,
      );

      setState(() {
        tasksList.add(newTask);
        _updateTasks();
      });
    }
  }

  void _setSelectedCategory(TaskCategory category, BuildContext context) {
    setState(() {
      _selectedCategory = category;
      _updateTasks();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF883007),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/profile.jpeg"),
              ),
              accountName: Text("Student"),
              accountEmail: Text("student@gmail.com"),
            ),
            ListTile(
              title: Text("All Tasks"),
              leading: Icon(Icons.menu_outlined),
              onTap: () => _setSelectedCategory(TaskCategory.all, context),
            ),
            ListTile(
              title: Text("Completed Tasks"),
              leading: Icon(Icons.check_box),
              onTap: () =>
                  _setSelectedCategory(TaskCategory.completed, context),
            ),
            ListTile(
              title: Text("Pending Tasks"),
              leading: Icon(Icons.incomplete_circle),
              onTap: () => _setSelectedCategory(TaskCategory.pending, context),
            ),
            ListTile(
              title: Text("Help"),
              leading: Icon(Icons.help_center),
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                onChanged: (keyword) {
                  // Implement search functionality if needed
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF272626),
                    size: 20,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(maxHeight: 20, minWidth: 25),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) => TaskItem(
                  task: _filteredTasks[index],
                  onTaskChanged: _handleTaskChange,
                  onDeleteItem: _deleteTask,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFFCECAB7),
    );
  }
}

// Enumeration to represent different task categories
enum TaskCategory {
  all,
  completed,
  pending,
}
