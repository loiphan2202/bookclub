import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _registerUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.18/api/signup.php?action=signup'), // Thay địa chỉ IP của bạn vào đây
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Đăng ký thành công, điều hướng đến trang đăng nhập
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User registered successfully. Please log in.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Đăng ký không thành công, hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: "Full Name",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password",
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                hintText: "Confirm Password",
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {
                  _registerUser(
                    name: _fullNameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}