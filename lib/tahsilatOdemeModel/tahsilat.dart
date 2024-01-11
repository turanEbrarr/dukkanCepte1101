import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilatHaraket.dart';
import 'package:dukkan_cepte/widget/cari.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';

class Tahsilat {
  int? ID = 0;
  int? TIP = 0;
  String? ISLEMTIPI = "";
  String? UUID = "";
  String? CARIKOD = "";
  String? CARIADI = "";
  double GENELTOPLAM = 0.0;
  String? BELGENO = "";
  Cari cariKart = Cari();
  String? PLASIYERKOD = "";
  String? TARIH = DateFormat("yyyy-MM-dd").format(DateTime.now());
  bool? AKTARILDIMI = false;
  bool? DURUM = false;
  int? SUBEID = 0;
  List<TahsilatHareket> tahsilatHareket = [];

  Tahsilat(
      this.ID,
      this.TIP,
      this.ISLEMTIPI,
      this.UUID,
      this.CARIKOD,
      this.GENELTOPLAM,
      this.PLASIYERKOD,
      this.TARIH,
      this.BELGENO,
      this.DURUM,
      this.AKTARILDIMI,
      this.SUBEID);

  Tahsilat.empty()
      : this(
            0,
            0,
            "",
            "",
            "",
            0.0,
            "",
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "",
            false,
            false,
            0);

  Tahsilat.fromTahsilat(
      Tahsilat tahsilat, List<TahsilatHareket> tahsilatHareket) {
    this.ID = tahsilat.ID;
    this.TIP = tahsilat.TIP;
    this.ISLEMTIPI = tahsilat.ISLEMTIPI;
    this.UUID = tahsilat.UUID;
    this.CARIKOD = tahsilat.CARIKOD;
    this.GENELTOPLAM = tahsilat.GENELTOPLAM;
    this.PLASIYERKOD = tahsilat.PLASIYERKOD;
    this.TARIH = tahsilat.TARIH;
    this.AKTARILDIMI = tahsilat.AKTARILDIMI;
    this.DURUM = tahsilat.DURUM;
    this.tahsilatHareket = tahsilatHareket;
    this.SUBEID = tahsilat.SUBEID;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['TIP'] = TIP;
    data['ISLEMTIPI'] = ISLEMTIPI;
    data['UUID'] = UUID;
    data['CARIKOD'] = CARIKOD;
    data['CARIADI'] = CARIADI;
    data['GENELTOPLAM'] = GENELTOPLAM;
    data['PLASIYERKOD'] = PLASIYERKOD;
    data['TARIH'] = TARIH;
    data['BELGENO'] = BELGENO;
    data['DURUM'] = DURUM;
    data['AKTARILDIMI'] = AKTARILDIMI;
    data['SUBEID'] = SUBEID;

    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['TIP'] = TIP;
    data['ISLEMTIPI'] = ISLEMTIPI;
    data['UUID'] = UUID;
    data['CARIKOD'] = CARIKOD;
    data['CARIADI'] = CARIADI;
    data['GENELTOPLAM'] = GENELTOPLAM;
    data['PLASIYERKOD'] = PLASIYERKOD;
    data['TARIH'] = TARIH;
    data['BELGENO'] = BELGENO;
    data['DURUM'] = DURUM;
    data['AKTARILDIMI'] = AKTARILDIMI;
    data['SUBEID'] = SUBEID;
    data['TAHSILATHAREKET'] =
        tahsilatHareket.map((fis1) => fis1.toJson()).toList();
    return data;
  }

  Tahsilat.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    TIP = int.parse(json['TIP'].toString());
    ISLEMTIPI = json['ISLEMTIPI'].toString();
    UUID = json['UUID'].toString();
    SUBEID = int.parse(json['SUBEID'].toString());
    CARIKOD = json['CARIKOD'].toString();
    CARIADI = json['CARIADI'].toString();
    GENELTOPLAM = double.parse(json['GENELTOPLAM'].toString());
    PLASIYERKOD = json['PLASIYERKOD'].toString();
    BELGENO = json['BELGENO'].toString();
    TARIH = json['TARIH'].toString();
    DURUM = json['DURUM'] == 0 ? false : true;
    AKTARILDIMI = json['AKTARILDIMI'] == 0 ? false : true;
  }

  Future<int?> tahsilatEkle(
      {required Tahsilat tahsilat, required String belgeTipi}) async {
    var result;
    tahsilat.TIP = Ctanim().MapIlslemTip[belgeTipi];

    if (tahsilat.ID != 0) {
      try {
        await Ctanim.db?.update("TBLTAHSILATSB", tahsilat.toJson(),
            where: 'ID = ?',
            whereArgs: [tahsilat.ID]).then((value) => result = value);

        for (var element in tahsilat.tahsilatHareket) {
          if (element.ID! > 0) {
            Ctanim.db?.update("TBLTAHSILATHAR", element.toJson(),
                where: "ID=?", whereArgs: [element.ID]);
          } else {
            element.ID = null;
            Ctanim.db?.insert("TBLTAHSILATHAR", element.toJson());
          }
        }

        return result;
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      try {
        tahsilat.ID = null;
        if (tahsilat.CARIKOD != "") {
          result = await Ctanim.db
              ?.insert("TBLTAHSILATSB", tahsilat.toJson())
              .then((value) => tahsilat.ID = value);

          tahsilat.tahsilatHareket.forEach((element) {
            element.TAHSILATID = result;
            element.ID = null;
            Ctanim.db?.insert("TBLTAHSILATHAR", element.toJson());
          });

          return result;
        }
        return result;
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Future<void> tahsilatVeHareketSil(int tahsilatID) async {
    //FisHareket idsi fiş id te eşitleri sil

    await Ctanim.db?.delete("TBLTAHSILATHAR",
        where: "TAHSILATID = ?", whereArgs: [tahsilatID]);
    //fisleri sil
    await Ctanim.db
        ?.delete("TBLTAHSILATSB", where: "ID = ?", whereArgs: [tahsilatID]);
  }
  
}
