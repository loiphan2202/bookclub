class Book {
  int documentId;
  String anh;
  String gioithieu;
  int luotxem;
  String noidung;
  String tacgia;
  String ten;
  String theloai;

  Book({
    required this.documentId,
    required this.anh,
    required this.gioithieu,
    required this.luotxem,
    required this.noidung,
    required this.tacgia,
    required this.ten,
    required this.theloai,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
  return Book(
    documentId: json['documentId'] != null ? int.parse(json['documentId'].toString()) : 0,
    anh: json['anh'] != null ? json['anh'].toString() : '',
    gioithieu: json['gioithieu'] != null ? json['gioithieu'].toString() : '',
    luotxem: json['luotxem'] != null ? int.parse(json['luotxem'].toString()) : 0,
    noidung: json['noidung'] != null ? json['noidung'].toString() : '',
    tacgia: json['tacgia'] != null ? json['tacgia'].toString() : '',
    ten: json['ten'] != null ? json['ten'].toString() : '',
    theloai: json['theloai'] != null ? json['theloai'].toString() : '',
  );
}
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'anh': anh,
      'gioithieu': gioithieu,
      'luotxem': luotxem,
      'noidung': noidung,
      'tacgia': tacgia,
      'ten': ten,
      'theloai': theloai,
    };
  }
}
