class BankaModel {
  int? ID = 0;
  String? BANKAKODU = "";
  String? BANKAADI = "";
  

  BankaModel({required this.ID, required this.BANKAKODU, required this.BANKAADI});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['BANKAKODU'] = BANKAKODU;
    data['BANKAADI'] = BANKAADI;
  
    return data;
  }

  BankaModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    BANKAKODU = json['BANKAKODU'].toString();
    BANKAADI = json['BANKAADI'].toString();
   
  }
}
