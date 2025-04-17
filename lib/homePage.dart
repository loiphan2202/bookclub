import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybookshophonmi/SwipableStackScreen.dart';
import 'package:mybookshophonmi/addMemory.dart';
import 'package:mybookshophonmi/userMemory.dart';
import 'package:mybookshophonmi/userModel.dart';
import 'package:mybookshophonmi/userProfileWidget.dart';
import 'package:mybookshophonmi/widget1.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({Key? key, required this.user}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.search),
            label: 'Community',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Quotes',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.newspaper),
            label: 'Create',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: 'Personal',
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _buildPage(_page),
    );
  }

  Widget _buildPage(int page) {
    switch (page) {
      case 0:
        return Widget1();
      case 1:
      // TODO: Add Widget for Search page
        return SwipableStackScreen(); //UploadImageScreen(user: widget.user); 
      case 2:
      // TODO: Add Widget for Chat page
        return UserMemory( idus: widget.user.id);
      case 3:
        return UploadImageScreen(user: widget.user);
      case 4:
      // TODO: Add Widget for Personal page
        return UserProfileWidget(user: widget.user);
      default:
        return Container();
    }
  }
}