import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/postscreen.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  final TextEditingController _taskController = TextEditingController();
  List<Map<String, dynamic>> _tasks = [];
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTasks = prefs.getString('task_key');
    if (savedTasks != null) {
      setState(() {
        _tasks = List<Map<String, dynamic>>.from(json.decode(savedTasks));
      });
    }
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('task_key', json.encode(_tasks));
  }

  void _addTask(String title) {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 12,
            width: 20,
            child: Text(
              'Task cannot be empty!',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        ),
      );
      return; //exit the function if the task is empty
    }
    setState(() {
      _tasks.insert(0, {'title': title, 'completed': false});
      _animatedListKey.currentState
          ?.insertItem(0, duration: Duration(milliseconds: 500));
    });
    _taskController.clear();
    _saveTasks();
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    final removedTask = _tasks[index];

    setState(() {
      _animatedListKey.currentState?.removeItem(
        index,
        (context, animation) => _buildAnimatedTaskItem(removedTask, animation),
        duration: Duration(milliseconds: 500),
      );
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _navigateToPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do-Task'),
        actions: [
          IconButton(
            onPressed: _navigateToPostScreen,
            icon: Icon(Icons.list_alt),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(hintText: 'Add Task'),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () => _addTask(_taskController.text),
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Flexible(
              child: AnimatedList(
                key: _animatedListKey,
                initialItemCount: _tasks.length,
                itemBuilder: (context, index, animation) {
                  return _buildAnimatedTaskItem(_tasks[index], animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTaskItem(
      Map<String, dynamic> task, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.only(bottom: 8),
        elevation: 5,
        child: ListTile(
          leading: Checkbox(
            value: task['completed'],
            onChanged: (_) => _toggleTask(_tasks.indexOf(task)),
          ),
          title: Text(
            task['title'],
          ),
          trailing: IconButton(
            onPressed: () => _deleteTask(_tasks.indexOf(task)),
            icon: Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
