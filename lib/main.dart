// lib/main.dart
import 'package:flutter/material.dart';
import 'db.dart';
import 'detail_page.dart';

void main() {
  runApp(MaterialApp(
    home: UserForm(),
  ));
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  int _selectedSex = 0; // 0 = Male, 1 = Female

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> user = {
        'name': _nameController.text,
        'sex': _selectedSex,
        'salary': double.parse(_salaryController.text),
      };
      await DatabaseHelper().insertUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully')),
      );

      _nameController.clear();
      _salaryController.clear();
      setState(() {
        _selectedSex = 0;
      });
    }
  }

  Widget _buildGenderRadio(String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: _selectedSex,
          onChanged: (val) {
            setState(() {
              _selectedSex = val!;
            });
          },
        ),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter salary' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Gender: "),
                  _buildGenderRadio('Male', 0),
                  _buildGenderRadio('Female', 1),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
