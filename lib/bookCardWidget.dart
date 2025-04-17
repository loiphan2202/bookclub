import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybookshophonmi/readBookScreen.dart';
import 'bookModel.dart';

class BookCardWidget extends StatelessWidget {
  final Book book;

  const BookCardWidget({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.94,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.network(
                            book.anh,
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            child: Text(
                              book.ten,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // Giới hạn văn bản chỉ hiển thị trên một dòng
                              style: GoogleFonts.dancingScript(
                                fontSize: screenWidth * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Tác Giả:',
                                style: GoogleFonts.readexPro(
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                              Text(
                                book.tacgia,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.readexPro(
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      color: Color(0x52178835),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Text(
                          book.gioithieu,
                          style: GoogleFonts.readexPro(
                            color: Theme.of(context).backgroundColor,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: ElevatedButton(
                      onPressed: () {
                        // Gọi giao diện ReadBookScreen và truyền vào đối tượng BookModel
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadBookScreen(book: book,),
                          ),
                        );
                      },
                      child: Text('Đọc Sách'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF249639),
                        textStyle: GoogleFonts.readexPro(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}