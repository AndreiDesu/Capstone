import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(
      Uri.parse("http://192.168.100.238/flutter_api/get_users.php"), // You'll need to create this
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        setState(() {
          users = jsonData['data'];
        });
      }
    }
  }

  Future<void> createOrUpdateUser({Map<String, dynamic>? user}) async {
    final _formKey = GlobalKey<FormState>();
    final firstnameController = TextEditingController(text: user?['firstname']);
    final lastnameController = TextEditingController(text: user?['lastname']);
    final miController = TextEditingController(text: user?['mi']);
    final addressController = TextEditingController(text: user?['address']);
    final emailController = TextEditingController(text: user?['email']);
    final contactController = TextEditingController(text: user?['contact']);
    final passwordController = TextEditingController(text: user?['password']);
    final roleidController = TextEditingController(text: user?['roleid']?.toString() ?? '2');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? "Create User" : "Edit User"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _textField("First Name", firstnameController),
                _textField("Last Name", lastnameController),
                _textField("Middle Initial", miController),
                _textField("Address", addressController),
                _textField("Email", emailController),
                _textField("Contact", contactController),
                _textField("Password", passwordController, obscureText: true),
                _textField("Role ID", roleidController),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              final Map<String, String> body = {
                "firstname": firstnameController.text,
                "lastname": lastnameController.text,
                "mi": miController.text,
                "address": addressController.text,
                "email": emailController.text,
                "contact": contactController.text,
                "password": passwordController.text,
                "roleid": roleidController.text,
              };

              String url;
              if (user == null) {
                url = "http://192.168.100.238/flutter_api/create_user.php";
              } else {
                url = "http://192.168.100.238/flutter_api/edit_user.php";
                body["id"] = user['id'].toString();
              }

             final response = await http.post(
  Uri.parse(url),
  headers: {'Content-Type': 'application/json'},
  body: json.encode(body),
);

              final jsonResponse = json.decode(response.body);

              if (jsonResponse['status'] == 'success') {
                Navigator.pop(context);
                fetchUsers();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(jsonResponse['message'])),
                );
              }
            },
            child: Text(user == null ? "Create" : "Update"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteUser(String id) async {
  final response = await http.post(
    Uri.parse("http://192.168.100.238/flutter_api/delete_user.php"),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"id": id}),
  );

  final jsonResponse = json.decode(response.body);

  if (jsonResponse['status'] == 'success') {
    fetchUsers();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(jsonResponse['message'])),
    );
  }
}

  Widget _textField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _userCard(Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text("${user['firstname']} ${user['lastname']}"),
        subtitle: Text("Email: ${user['email']}"),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => createOrUpdateUser(user: user),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(user['id'].toString()),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteUser(id);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(children: users.map((u) => _userCard(u)).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createOrUpdateUser(),
        child: Icon(Icons.add),
        tooltip: "Create User",
      ),
    );
  }
}
