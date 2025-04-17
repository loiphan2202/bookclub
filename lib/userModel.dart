class UserModel {
  int id;
  String email;
  String name;
  String pass;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.pass,
  });

  // Chuyển từ JSON sang UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      pass: json['pass'] != null ? json['pass'] as String : '',
    );
  }

  // Chuyển từ UserModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'pass': pass,
    };
  }
}
