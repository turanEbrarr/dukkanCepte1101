class KurModel {
  int? ID = 0;
  String? ACIKLAMA = "";
  double? KUR = 0.0;
  String? ANABIRIM = "";

  KurModel({required this.ID, required this.ACIKLAMA, required this.KUR,required this.ANABIRIM});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['ACIKLAMA'] = ACIKLAMA;
    data['KUR'] = KUR;
    data['ANABIRIM'] =ANABIRIM ;
    return data;
  }

  KurModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    ACIKLAMA = json['ACIKLAMA'].toString();
    KUR = double.parse(json['KUR'].toString());
    ANABIRIM = json['ANABIRIM'].toString();
  }
}
