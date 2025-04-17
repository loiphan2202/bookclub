import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mybookshophonmi/signUp.dart';
import 'package:mybookshophonmi/userModel.dart';

import 'homePage.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser({required String email, required String password, required BuildContext context}) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.88.157/api/api.php?action=login'), // Thay địa chỉ IP của bạn vào đây
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': 'loipt.22it@vku.udn.vn',
          'password': '123456',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Đăng nhập thành công, điều hướng đến trang chính với id của user
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(user: UserModel.fromJson(responseData['user'])),
            ),
          );
        } else {
          // Đăng nhập không thành công, hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception('Failed to load data');
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
                "Log In",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                _loginUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context,
                );
              },
            ),
            TextButton(
              child: Text("Don't have an account? Sign up here"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignUp(), // Thay thế bằng trang đăng ký của bạn
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
