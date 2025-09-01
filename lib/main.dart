// lib/main.dart
import 'package:flutter/material.dart';
import 'db.dart';
import 'detail_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.deepPurple,
    ),
    home: UserForm(),
    debugShowCheckedModeBanner: false,
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
        SnackBar(content: Text('✅ User added successfully')),
      );

      _nameController.clear();
      _salaryController.clear();
      setState(() {
        _selectedSex = 0;
      });
    }
  }

  Widget _buildGenderRadio(String label, int value, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedSex = value),
        child: Card(
          elevation: 2,
          color: _selectedSex == value ? Colors.deepPurple[50] : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.deepPurple),
                Text(label, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('👤 Add New User'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: 'View Users',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPage()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "User Information",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(
                  labelText: 'Salary',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter salary' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildGenderRadio("Male", 0, Icons.male),
                  SizedBox(width: 10),
                  _buildGenderRadio("Female", 1, Icons.female),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Submit'),
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
