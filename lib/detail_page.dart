// lib/detail_page.dart
import 'package:flutter/material.dart';
import 'db.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final users = await DatabaseHelper().getAllUsers();
    setState(() {
      _users = users;
    });
  }

  String _getGenderText(int sex) {
    return sex == 0 ? 'Male' : 'Female';
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user['id']}'),
            Text('Name: ${user['name']}'),
            Text('Gender: ${_getGenderText(user['sex'])}'),
            Text('Salary: \$${user['salary']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, index) {
          final user = _users[index];
          return ListTile(
            title: Text('ID: ${user['id']} - Name: ${user['name']}'),
            onTap: () => _showUserDetails(user),
          );
        },
      ),
    );
  }
}
