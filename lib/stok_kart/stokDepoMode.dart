class StokDepoModel {
  String? KOD = "";
  String? DEPOADI = "";
  double? BAKIYE = 0.0;

  StokDepoModel(
      {required this.KOD, required this.DEPOADI, required this.BAKIYE});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['KOD'] = KOD;
    data['DEPOADI'] = DEPOADI;
    data['BAKIYE'] = BAKIYE;

    return data;
  }

  StokDepoModel.fromJson(Map<String, dynamic> json) {
    KOD = json['KOD'].toString();
    DEPOADI = json['DEPOADI'].toString();
    BAKIYE = double.parse(json['BAKIYE'].toString());
  }
}
