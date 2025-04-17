import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mybookshophonmi/userModel.dart';

class UploadImageScreen extends StatefulWidget {
  final UserModel user;

  UploadImageScreen({required this.user});

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
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

  Future<void> _uploadData() async {
    if (_image == null) {
      print('No image to upload.');
      return;
    }

    var uri = Uri.parse("http://192.168.88.157/api/api.php?action=uploadMemory");
    var request = http.MultipartRequest("POST", uri);
    request.fields['noidung'] = _noidungController.text;
    request.fields['tacgia'] = widget.user.name;
    request.fields['idus'] = widget.user.id.toString();
    request.fields['color'] = _selectedColor ?? '';

    var stream = http.ByteStream(_image!.openRead().cast());
    var length = await _image!.length();
    var multipartFile = http.MultipartFile('image', stream, length, filename: path.basename(_image!.path));
    request.files.add(multipartFile);

    print('Uploading image to: $uri');
    print('Fields: ${request.fields}');

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          var jsonResponse = json.decode(value);
          print('Response: $jsonResponse');
          if (jsonResponse['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload successful!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed: ${jsonResponse['message']}")));
          }
        });
      } else {
        print('Failed to upload data. Status code: ${response.statusCode}');
        response.stream.transform(utf8.decoder).listen((value) {
          print('Response: $value');
        });
      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo Quotes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chào mừng đến với HONMI, nơi chia sẻ những bài học về cuộc sống. Hãy cùng chúng tôi chia sẻ những khoảnh khắc đáng nhớ và những bài học quý báu!',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                //fontWeight: FontWeight,
              ),
            ),
            SizedBox(height: 20), // Khoảng cách giữa dòng 1 và dòng 2
            TextField(
              controller: _noidungController,
              maxLines: null, // Cho phép nhiều dòng
              keyboardType: TextInputType.multiline, // Hiển thị text area
              decoration: InputDecoration(
                labelText: 'Nội dung',
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
                ? Text('No image selected.')
                : Image.file(_image!, height: 200),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set màu nền cho nút
                       ),
                  child: Text('Chọn ảnh'),
                ),
                ElevatedButton(
                  onPressed: _uploadData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set màu nền cho nút
                       ),
                  child: Text('Thêm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
