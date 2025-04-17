import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'bookCardWidget.dart';
import 'bookModel.dart';

Widget homePageContainer(BuildContext context) {
 Future<List<Book>> fetchBooks() async {
  final response = await http.get(Uri.parse('http://192.168.88.157/api/api.php?action=getBooks'));

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> data = json.decode(response.body).cast<Map<String, dynamic>>();
    return data.map((json) => Book.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

  return FutureBuilder<List<Book>>(
    future: fetchBooks(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No books found'));
      }

      var bookList = snapshot.data!;

      return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - kToolbarHeight - 200,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Theme.of(context).backgroundColor,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: bookList.length,
                    itemBuilder: (context, index) {
                      var book = bookList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookCardWidget(book: book),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FractionallySizedBox(
                                widthFactor: 0.8,
                                child: Image.network(
                                  book.anh,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              book.ten,
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}