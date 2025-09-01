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
        title: Text('👤 User Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.badge),
              title: Text('ID: ${user['id']}'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Name: ${user['name']}'),
            ),
            ListTile(
              leading: Icon(Icons.transgender),
              title: Text('Gender: ${_getGenderText(user['sex'])}'),
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Salary: \$${user['salary']}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user['id'].toString()),
          backgroundColor: Colors.deepPurple.shade100,
        ),
        title: Text(user['name']),
        subtitle: Text('Tap for details'),
        trailing: Icon(Icons.info_outline),
        onTap: () => _showUserDetails(user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📋 User List'),
      ),
      body: _users.isEmpty
          ? Center(child: Text('No users added yet'))
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (_, index) => _buildUserCard(_users[index]),
            ),
    );
  }
}
