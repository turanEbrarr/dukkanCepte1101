import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../widget/ctanim.dart';

class TahsilatHareket {
  int? ID = 0;
  int? TAHSILATID;
  String? UUID = "";
  int? TIP = 0;
  String? ALTHESAP = "";
  double? TUTAR = 0.0;
  String? KASAKOD = "";
  int? DOVIZID = 0;
  double? KUR = 0.0;
  int? TAKSIT = 0;
  String? DOVIZ = "";
  String? CEKSERINO = "";
  String? YERI = "";
  String? VADETARIHI = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? ASIL = "";
  String ACIKLAMA = "";
  String? BELGENO = "";
  int? SOZLESMEID = 0;
  bool? AKTARILDIMI = false;

  TahsilatHareket({
    required this.ID,
    required this.TAHSILATID,
    required this.UUID,
    required this.TIP,
    required this.TUTAR,
    required this.KASAKOD,
    required this.DOVIZID,
    required this.ALTHESAP,
    this.KUR,
    required this.TAKSIT,
    required this.DOVIZ,
    required this.CEKSERINO,
    required this.YERI,
    required this.VADETARIHI,
    required this.ASIL,
    required this.ACIKLAMA,
    required this.BELGENO,
    required this.SOZLESMEID,
    //required this.AKTARILDI_MI
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['TAHSILATID'] = TAHSILATID;
    data['UUID'] = UUID;
    data['TIP'] = TIP;
    data['KASAKOD'] = KASAKOD;
    data['KUR'] = KUR;
    data['DOVIZID'] = DOVIZID;
    data['TUTAR'] = TUTAR;
    data['TAKSIT'] = TAKSIT;
    data['DOVIZ'] = DOVIZ;
    data['CEKSERINO'] = CEKSERINO;
    data['YERI'] = YERI;
    data['VADETARIHI'] = VADETARIHI;
    data['ASIL'] = ASIL;
    data['ACIKLAMA'] = ACIKLAMA;
    data['BELGENO'] = BELGENO;
    data['ALTHESAP'] = ALTHESAP;
    data['SOZLESMEID'] = SOZLESMEID;
    data['AKTARILDIMI'] = AKTARILDIMI;
    return data;
  }

  TahsilatHareket.empty()
      : this(
            ID: 0,
            TAHSILATID: 0,
            UUID: "",
            ACIKLAMA: "",
            ALTHESAP: "",
            //AKTARILDI_MI: false,
            ASIL: "",
            KUR:  0.0,
            BELGENO: "",
            CEKSERINO: "",
            DOVIZ: "",
            DOVIZID: 0,
            KASAKOD: "",
            SOZLESMEID: 0,
            TAKSIT: 0,
            TIP: 0,
            TUTAR: 0.0,
            VADETARIHI: "",
            YERI: "");

  TahsilatHareket.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    TAHSILATID = int.parse(json['TAHSILATID'].toString());
    UUID = json['UUID'];
    TIP = int.parse(json['TIP'].toString());
    TUTAR = double.parse(json['TUTAR'].toString());
     KUR = double.parse(json['KUR'].toString());
    TAKSIT = int.parse(json['TAKSIT'].toString());
    KASAKOD = json['KASAKOD'];
    DOVIZID = int.parse(json['DOVIZID'].toString());
    DOVIZ = json['DOVIZ'];
    CEKSERINO = json['CEKSERINO'];
    ALTHESAP = json['ALTHESAP'];
    YERI = json['YERI'];
    VADETARIHI = json['VADETARIHI'];
    ASIL = json['ASIL'];
    ACIKLAMA = json['ACIKLAMA'];
    BELGENO = json['BELGENO'];
    SOZLESMEID = int.parse(json['SOZLESMEID'].toString());
    AKTARILDIMI = json['AKTARILDIMI'] == 0 ? false : true;
  }
  Future<int?> tahsilatHareketEkle(TahsilatHareket tahsilatHareket) async {
    if (tahsilatHareket.ID! > 0) {
      try {
        var result = await Ctanim.db?.update(
            "TBLTAHSILATHAR", tahsilatHareket.toJson(),
            where: 'ID = ?', whereArgs: [tahsilatHareket.ID]);
        return result;
      } on PlatformException catch (e) {
        return -1;
      
      }
    } else {
      try {
        tahsilatHareket.ID = null;
        var result =
            await Ctanim.db?.insert("TBLTAHSILATHAR", tahsilatHareket.toJson());

        return result;
      } on PlatformException catch (e) {
        return -1;
        print(e);
      }
    }
  }

  Future<int> tahsilatHareketSil(int Id) async {
    var result = await Ctanim.db
        ?.delete("TBLTAHSILATHAR", where: 'ID = ?', whereArgs: [Id]);
    return result;
  }
}
