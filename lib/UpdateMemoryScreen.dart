import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mybookshophonmi/memoryModel.dart';

class UpdateMemoryScreen extends StatefulWidget {
  final Memory memory;

  UpdateMemoryScreen({required this.memory});

  @override
  _UpdateMemoryScreenState createState() => _UpdateMemoryScreenState();
}

class _UpdateMemoryScreenState extends State<UpdateMemoryScreen> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _noidungController = TextEditingController();

  final List<String> _colorOptions = [
    "#D3F6F3",
    "#F9FCE1",
    "#FEE9B2",
    "#FBD1B7",
    "#F9F5F6",
    "#F8E8EE",
    "#FDCEDF",
    "#F2BED1",
    "#E1F0DA",
    "#D4E7C5",
    "#BFD8AF",
    "#99BC85",
  ];

  String? _selectedColor;

  Color _parseColor(String colorHex) {
    return Color(int.parse(colorHex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          print('Image selected: ${_image!.path}');
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _noidungController.text = widget.memory.content;
    _selectedColor = widget.memory.color;
  }

  Future<void> _updateMemory() async {
    var uri = Uri.parse("http://192.168.88.157/api/api.php?action=updateMemory&id=${widget.memory.id}");
    var request = http.MultipartRequest("POST", uri);
    request.fields['id'] = widget.memory.id.toString();
    request.fields['noidung'] = _noidungController.text;
    request.fields['color'] = _selectedColor ?? '';

    if (_image != null) {
      var stream = http.ByteStream(_image!.openRead().cast());
      var length = await _image!.length();
      var multipartFile = http.MultipartFile('image', stream, length, filename: path.basename(_image!.path));
      request.files.add(multipartFile);
    }

    print('Uploading image to: $uri');
    print('Fields: ${request.fields}');

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print('Raw response: $responseBody');
        
        if (responseBody.isNotEmpty) {
          var jsonResponse = json.decode(responseBody);
          print('Parsed JSON response: $jsonResponse');
        
          if (jsonResponse['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update successful!")));
            Navigator.pop(context); // Navigate back to the previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update failed: ${jsonResponse['message']}")));
          }
        } else {
          print('Empty response body.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update memory. Please try again later.")));
        }
      } else {
        print('Failed to upload data. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update memory. Please try again later.")));
      }
    } catch (e) {
      print('Error uploading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred while updating memory. Please try again later.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Update your quotes here:',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _noidungController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'nội dung',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _selectedColor,
                hint: Text('Select a color'),
                onChanged: (value) {
                  setState(() {
                    _selectedColor = value;
                  });
                },
                items: _colorOptions.map((String color) {
                  Color colorValue = _parseColor(color);
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Container(
                      color: colorValue,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(color),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              _image == null
                  ? Image.network(
                      'http://192.168.88.157/api/uploads/${widget.memory.image}',
                      height: 200,
                    )
                  : Image.file(
                      _image!,
                      height: 200,
                    ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set màu nền cho nút
                       ),
                    child: Text('Choose Image'),
                  ),
                  ElevatedButton(
                    onPressed: _updateMemory,
                    child: Text('Cập Nhật'),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set màu nền cho nút
                       ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
