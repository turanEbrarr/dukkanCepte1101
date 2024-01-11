class LogModel {
  int? ID;
  int? FISID;
  String? TABLOADI;
  String? UUID;
  String? HATAACIKLAMA;
  String? CARIADI;

  LogModel({this.ID, this.FISID, this.UUID, this.HATAACIKLAMA, this.CARIADI, required this.TABLOADI});

  // 'fromJson' methodu, JSON formatındaki veriyi alarak LogModel nesnesine dönüştürür.
  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      ID: int.parse(json['ID'].toString()),
      TABLOADI: json['TABLOADI'],
      FISID: int.parse(json['FISID'].toString()),
      UUID: json['UUID'],
      HATAACIKLAMA: json['HATAACIKLAMA'],
      CARIADI: json['CARIADI'],
    );
  }

  // 'toJson' methodu, LogModel nesnesini JSON formatına dönüştürür.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.ID;
    data['FISID'] = this.FISID;
    data['TABLOADI'] = this.TABLOADI;
    data['UUID'] = this.UUID;
    data['HATAACIKLAMA'] = this.HATAACIKLAMA;
    data['CARIADI'] = this.CARIADI;
    return data;
  }
}
