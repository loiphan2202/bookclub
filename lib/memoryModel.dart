class Memory {
  final int id;
  final String image;
  final String content;
  final String author;
  final String color;

  Memory({
    required this.id,
    required this.image,
    required this.content,
    required this.author,
    required this.color,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      image: json['anh'],
      content: json['noidung'],
      author: json['tacgia'],
      color: json['color'],
    );
  }
}
