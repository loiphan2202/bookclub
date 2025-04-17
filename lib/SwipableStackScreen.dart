import 'package:flutter/material.dart';
import 'package:mybookshophonmi/memoryModel.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: SwipableStackScreen(),
  ));
}

class SwipableStackScreen extends StatefulWidget {
  @override
  _SwipableStackScreenState createState() => _SwipableStackScreenState();
}

class _SwipableStackScreenState extends State<SwipableStackScreen> {
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
    final response = await http.get(Uri.parse('http://192.168.88.157/api/api.php?action=getMemories'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        _memories = jsonData.map((data) => Memory.fromJson(data)).toList().reversed.toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load memories');
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
        title: Text('Quotes Of All Time'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SwipableStack(
              controller: _controller,
              builder: (context, properties) {
                final itemIndex = properties.index % _memories.length;
                final memory = _memories[itemIndex];
                final color = Color(int.parse(memory.color.replaceAll('#', ''), radix: 16) + 0xFF000000);
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color, color.withOpacity(1.0)],
                      ),
                    ),
                    padding: EdgeInsets.all(20),
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
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '- ${memory.author} -',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
