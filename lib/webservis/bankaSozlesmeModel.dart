class BankaSozlesmeModel {
  int? ID = 0;
  int? BANKAID = 0;
  String? ADI = "";
  int? TIP = 0;

  BankaSozlesmeModel(
      {required this.ID,
      required this.BANKAID,
      required this.ADI,
      required this.TIP});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['BANKAID'] = BANKAID;
    data['ADI'] = ADI;
    data['TIP'] = TIP;

    return data;
  }

  BankaSozlesmeModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    BANKAID = int.parse(json['BANKAID'].toString());
    ADI = json['ADI'].toString();
    TIP = int.parse(json['TIP'].toString());
  }
}
