import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mybookshophonmi/UpdateMemoryScreen.dart';
import 'package:mybookshophonmi/addMemory.dart';
import 'package:mybookshophonmi/login.dart';
import 'package:mybookshophonmi/memoryModel.dart';
import 'package:mybookshophonmi/userModel.dart';
import 'package:swipable_stack/swipable_stack.dart';

class UserMemory extends StatefulWidget {
  final int idus;

  UserMemory({required this.idus});

  @override
  _UserMemoryState createState() => _UserMemoryState();
}

class _UserMemoryState extends State<UserMemory> {
  late final SwipableStackController _controller;
  List<Memory> _memories = [];
  bool _isLoading = true;

  void _listenController() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
    _fetchMemories();
  }

  Future<void> _fetchMemories() async {
    final response = await http.get(Uri.parse(
        'http://192.168.88.157/api/api.php?action=getMemoryByIdus&idus=${widget.idus}'));
    if (response.statusCode == 200) {
      try {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _memories = jsonData.map((data) => Memory.fromJson(data)).toList().reversed.toList();
          _isLoading = false;
        });
      } catch (e) {
        print('Error parsing JSON: $e');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading memories')),
        );
      }
    } else {
      print('Failed to load memories. Status code: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load memories')),
      );
    }
  }

  Future<void> _deleteMemory(int id) async {
    final response = await http.get(Uri.parse(
        'http://192.168.88.157/api/api.php?action=deleteMemory&id=$id'));
    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            _memories.removeWhere((memory) => memory.id == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Memory deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete memory: ${jsonResponse['message']}')),
          );
        }
      } catch (e) {
        print('Error parsing JSON: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting memory')),
        );
      }
    } else {
      print('Failed to delete memory. Status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete memory')),
      );
    }
  }
  Future<UserModel> getUserById(int id) async {
    final response = await http.get(
      Uri.parse('http://192.168.88.157/api/api.php?action=getUserById&id=$id'),
  
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> _confirmDeleteDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this memory?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteMemory(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  

  void _navigateToUpdateMemoryScreen(Memory memory) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateMemoryScreen(memory: memory),
      ),
    );

    if (result == true) {
      // Refresh memories if update was successful
      _fetchMemories();
    }
  }

  void _navigateToAddMemoryScreen() async {
    UserModel user = await getUserById(widget.idus);
    // Điều hướng đến trang thêm mới memory
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>UploadImageScreen(user: user), // Thay AddMemoryScreen bằng trang bạn muốn điều hướng tới
      ),
    );

    if (result == true) {
      // Refresh memories if a new memory was added successfully
      _fetchMemories();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_listenController)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('honmi quotes của bạn'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: _memories.length + 1,
              itemBuilder: (context, index) {
                if (index == _memories.length) {
                  // Thẻ cuối cùng với dấu cộng
                  return GestureDetector(
                    onTap: _navigateToAddMemoryScreen,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  final memory = _memories[index];
                  final color = Color(int.parse(memory.color.replaceAll('#', ''), radix: 16) + 0xFF000000);
                  return GestureDetector(
                    onLongPress: () {
                      _confirmDeleteDialog(memory.id);
                    },
                    onTap: () {
                      _navigateToUpdateMemoryScreen(memory);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [color, color.withOpacity(1.0)],
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.network(
                                  'http://192.168.88.157/api/uploads/${memory.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              memory.content,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '- ${memory.author} -',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
