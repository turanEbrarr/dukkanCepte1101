/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myjsonString>);
var myKullaniciModelNode = KullaniciModel.fromjson(map);
*/
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KullaniciModel {
  String? KOD;
  String? SIFRE;
  String? KASAKOD;
  String? ONLINE;
  String? ISLEMAKTARILSIN;
  String? SFIYAT1;
  String? SFIYAT2;
  String? SFIYAT3;
  String? SFIYAT4;
  String? SFIYAT5;
  String? FIYATDEGISTIRILSIN;
  int? YERELSUBEID;
  int? YERELDEPOID;
  String? ALISFIYATGORMESIN;

  KullaniciModel(
      {this.KOD,
      this.SIFRE,
      this.KASAKOD,
      this.ONLINE,
      this.ISLEMAKTARILSIN,
 
      this.SFIYAT1,
      this.SFIYAT2,
      this.SFIYAT3,
      this.SFIYAT4,
      this.SFIYAT5,
  
      this.FIYATDEGISTIRILSIN,
 
      this.YERELSUBEID,
      this.YERELDEPOID,
      this.ALISFIYATGORMESIN,
   
      });

  KullaniciModel.fromjson(Map<String, dynamic> json) {
    KOD = json['KOD'];
    SIFRE = json['SIFRE'];
    KASAKOD = json['KASAKOD'];
    ONLINE = json['ONLINE'];
    ISLEMAKTARILSIN = "H";

    SFIYAT1 = json['SFIYAT1'];
    SFIYAT2 = json['SFIYAT2'];
    SFIYAT3 = json['SFIYAT3'];
    SFIYAT4 = json['SFIYAT4'];
    SFIYAT5 = json['SFIYAT5'];
    FIYATDEGISTIRILSIN = json['FIYATDEGISTIRILSIN'];
    YERELSUBEID = 1 ;
    YERELDEPOID = 1;
    ALISFIYATGORMESIN = json['ALISFIYATGORMESIN'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['KOD'] = KOD; //
    data['SIFRE'] = SIFRE; //
    data['KASAKOD'] = KASAKOD;
    data['ONLINE'] = ONLINE; //
    data['ISLEMAKTARILSIN'] = ISLEMAKTARILSIN; //


    ///
    data['SFIYAT1'] = SFIYAT1; //
    data['SFIYAT2'] = SFIYAT2; //
    data['SFIYAT3'] = SFIYAT3; //
    data['SFIYAT4'] = SFIYAT4; //
    data['SFIYAT5'] = SFIYAT5; //

    ///?????????
    data['FIYATDEGISTIRILSIN'] = FIYATDEGISTIRILSIN; //

    data['YEREL_SUBEID'] = YERELSUBEID; //
    data['YEREL_DEPOID'] = YERELDEPOID; //
    ///?????????
    data['ALISFIYATGORMESIN'] = ALISFIYATGORMESIN;
    return data;
  }

  static Future<void> saveUser(KullaniciModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.tojson());
    await prefs.setString("kullanici", userJson);
  }

  static Future<KullaniciModel?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("kullanici");
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return KullaniciModel.fromjson(userMap);
    }
    return null;
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("kullanici");
  }
}
