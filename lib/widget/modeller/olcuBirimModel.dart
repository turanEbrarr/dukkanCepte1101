class OlcuBirimModel {
  OlcuBirimModel({this.ID, this.ACIKLAMA});
  int? ID;
  String? ACIKLAMA;

  factory OlcuBirimModel.fromJson(Map<String, dynamic> json) {
    return OlcuBirimModel(
      ID: int.parse(json['ID'].toString()),
      ACIKLAMA: json['ACIKLAMA'].toString(),
    );
  }
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.ID;
    data['ACIKLAMA'] = this.ACIKLAMA;
  
    return data;
  }
}
