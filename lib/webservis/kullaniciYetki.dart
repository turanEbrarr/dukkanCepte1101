class KullaniciYetki {
  KullaniciYetki({this.sira, this.deger});
  int? sira;
  String? deger;
  KullaniciYetki.fromJson(Map<String, dynamic> json) {
    sira = int.parse(json['MENUNO'].toString());
    deger = json['DEGER'].toString();
  }
}
