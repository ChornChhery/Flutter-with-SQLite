import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load existing users on startup
  }

  /// Load all users from the database
  Future<void> _loadUsers() async {
    final data = await DBHelper.getUsers();
    setState(() {
      _users = data;
    });
  }

  /// Add a new user to the database
  Future<void> _addUser() async {
    if (_controller.text.isNotEmpty) {
      await DBHelper.insertUser(_controller.text);
      _controller.clear();
      _loadUsers();
    }
  }

  /// Delete a user from the database
  Future<void> _deleteUser(int id) async {
    await DBHelper.deleteUser(id);
    _loadUsers();
  }

  /// Show a dialog to edit user name
  Future<void> _editUserDialog(int id, String currentName) async {
    TextEditingController editController = TextEditingController(text: currentName);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit User"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: "Enter new name"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                if (editController.text.isNotEmpty) {
                  await DBHelper.updateUser(id, editController.text);
                  Navigator.pop(context);
                  _loadUsers();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Example with Edit')),
      body: Column(
        children: [
          // Text input for adding a new user
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addUser,
                ),
              ),
            ),
          ),
          // Display the list of users
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_users[index]['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editUserDialog(
                          _users[index]['id'],
                          _users[index]['name'],
                        ),
                      ),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(_users[index]['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
