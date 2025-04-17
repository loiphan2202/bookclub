import 'package:flutter/material.dart';
import 'package:mybookshophonmi/userModel.dart';
import 'package:mybookshophonmi/login.dart'; // Đảm bảo rằng bạn import đúng đường dẫn cho LoginScreen

class UserProfileWidget extends StatelessWidget {
  final UserModel user;

  UserProfileWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/236x/21/5b/f2/215bf2ad433690a0cd4d3dd9e42c92d8.jpg',
              ),
            ),
            SizedBox(height: 20),
            Text(
              user.name ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              user.email ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()), // Điều hướng đến màn hình đăng nhập
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
