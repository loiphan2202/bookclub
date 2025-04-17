import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybookshophonmi/homePageContainer.dart';


class Widget1 extends StatefulWidget {
  Widget1({Key? key}) : super(key: key);

  @override
  _Widget1State createState() => _Widget1State();
}

class _Widget1State extends State<Widget1> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    String searchText = _searchController.text;
    // TODO: Handle search action with the search text
    print('Performing search: $searchText');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Trang chủ',
                ),
                Tab(
                  text: 'kĩ năng sống',
                ),
                Tab(
                  text: 'tĩnh tâm',
                ),
                Tab(
                  text: 'tiểu thuyết',
                ),
                Tab(
                  text: 'VH-XH',
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.menu_book, color: Colors.green
                ,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Giới Thiệu"),
                      content: Text(
                        "Honmi là một ứng dụng đọc sách độc đáo và đa dạng, được thiết kế với mục tiêu lan tỏa tình yêu đến mọi người thông qua việc cung cấp truy cập dễ dàng đến những tác phẩm văn học tuyệt vời. Với Honmi, bạn có thể khám phá và đắm chìm trong hàng ngàn cuốn sách từ các kênh khác nhau, mang đến cho người dùng trải nghiệm đọc sách đa dạng và phong phú.\n\nỨng dụng Honmi không chỉ giới hạn trong việc cung cấp những tác phẩm từ các tác giả nổi tiếng, mà còn mở rộng đến những tác phẩm độc lập, sách tự xuất bản và cả những tác phẩm từ các nguồn bên ngoài. Điều này đảm bảo rằng người dùng có thể tìm thấy một loạt các thể loại sách, từ tiểu thuyết, kinh doanh, khoa học, tự lực, tâm linh, đến sách hướng dẫn và rất nhiều thể loại khác.\n\nHonmi mang đến một giao diện người dùng thân thiện, giúp người dùng dễ dàng tìm kiếm và lựa chọn sách theo sở thích cá nhân. Bạn có thể tạo danh sách yêu thích, đánh dấu trang, điều chỉnh cỡ chữ và chế độ đọc ban đêm để tạo trải nghiệm đọc sách tốt nhất.\n\nDù bạn là một người yêu thích văn học, người muốn mở rộng kiến thức, hay chỉ đơn giản là muốn giải trí thông qua việc đọc sách, Honmi sẽ đồng hành cùng bạn trên hành trình khám phá những câu chuyện tuyệt vời và truyền cảm hứng từ văn học đa dạng.",
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Đóng"),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Đóng hộp thoại khi người dùng nhấn nút
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',

              ),
              onSubmitted: (value) {
                _performSearch();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _performSearch();
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              //content1(context),
              homePageContainer(context),

              Container(


              ),
              Container(
                color: Colors.orangeAccent,
                child: const Icon(Icons.home),
              ),
              Container(
                color: Color.fromARGB(255, 255, 118, 64),
                child: const Icon(Icons.home),
              ),
              Container(
                color: const Color.fromARGB(255, 64, 255, 172),
                child: const Icon(Icons.home),
              ),
            ],
          )
      ),
    );
  }
}