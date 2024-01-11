import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

import '../widget/ctanim.dart';
import 'depoHareket.dart';

class Sayim {
  int? ID = 0;
  String? TARIH = DateFormat("yyyy-MM-dd").format(DateTime.now());
  int? SUBEID = 0;
  int? DEPOID = 0;
  String? PLASIYERKOD = "";
  String? ACIKLAMA = "";
  bool? DURUM = false;
  String? ONAY = "H";
  bool? AKTARILDIMI = false;
  String? UUID = "";
  List<SayimHareket> sayimStokListesi = [];

  Sayim(this.ID, this.TARIH, this.SUBEID, this.DEPOID, this.PLASIYERKOD,
      this.ACIKLAMA, this.DURUM, this.ONAY, this.AKTARILDIMI, this.UUID);

  Sayim.empty() : this(0, "", 0, 0, "", "", false, "", false, "");

  Sayim.fromDepo(Sayim depo, List<SayimHareket> depohareket) {
    this.ID = depo.ID;
    this.TARIH = depo.TARIH;
    this.SUBEID = depo.DEPOID;
    this.DEPOID = depo.SUBEID;
    this.PLASIYERKOD = depo.PLASIYERKOD;
    this.ACIKLAMA = depo.ACIKLAMA;
    this.DURUM = depo.DURUM;
    this.ONAY = depo.ONAY;
    this.AKTARILDIMI = depo.AKTARILDIMI;
    this.UUID = depo.UUID;
    this.sayimStokListesi = depohareket;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ID"] = ID;
    data["TARIH"] = TARIH;
    data["SUBEID"] = SUBEID;
    data["DEPOID"] = DEPOID;
    data["PLASIYERKOD"] = PLASIYERKOD;
    data["ACIKLAMA"] = ACIKLAMA;
    data["DURUM"] = DURUM;
    data["ONAY"] = ONAY;
    data["AKTARILDIMI"] = AKTARILDIMI;
    data["UUID"] = UUID;
    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ID"] = ID;
    data["TARIH"] = TARIH;
    data["SUBEID"] = SUBEID;
    data["DEPOID"] = DEPOID;
    data["PLASIYERKOD"] = PLASIYERKOD;
    data["ACIKLAMA"] = ACIKLAMA;
    data["DURUM"] = DURUM;
    data["ONAY"] = ONAY;
    data["AKTARILDIMI"] = AKTARILDIMI;
    data["UUID"] = UUID;
    data['STOKLISTESI'] =
        sayimStokListesi.map((fis1) => fis1.toJson()).toList();
    return data;
  }

  Sayim.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    TARIH = json['TARIH'];
    SUBEID = int.parse(json['SUBEID'].toString());
    DEPOID = int.parse(json['DEPOID'].toString());
    PLASIYERKOD = json['PLASIYERKOD'];

    ACIKLAMA = json['ACIKLAMA'];
    DURUM = json['DURUM'] == 0 ? false : true;
    ONAY = json['ONAY'];
    AKTARILDIMI = json['AKTARILDIMI'] == 0 ? false : true;
    UUID = json['UUID'];
  }
  //fromJson2 Yazılmadı...
  Future<int?> sayimEkle({required Sayim sayim}) async {
    var result;
    //fis.TIP = Ctanim().MapFisTip[belgeTipi];

    if (sayim.ID != 0) {
      try {
        await Ctanim.db?.update("TBLSAYIMSB", sayim.toJson(),
            where: 'ID = ?',
            whereArgs: [sayim.ID]).then((value) => result = value);

        for (var element in sayim.sayimStokListesi) {
          if (element.ID! > 0) {
            Ctanim.db?.update("TBLSAYIMHAR", element.toJson(),
                where: "ID=?", whereArgs: [element.ID]);
          } else {
            element.ID = null;
            Ctanim.db?.insert("TBLSAYIMHAR", element.toJson());
          }
        }

        return result;
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      print("else");
      try {
        sayim.ID = null;
        print("DEPOID BOŞ OLMAMALI!!!!!!!!!!!!!!!!!!!");
        if (sayim.DEPOID != "") {
          //CARİKODDU?
          result = await Ctanim.db
              ?.insert("TBLSAYIMSB", sayim.toJson())
              .then((value) => sayim.ID = value);
          print("ELse:" + sayim.ID.toString());
          for (var element in sayim.sayimStokListesi) {
            element.SAYIMID = result;
            element.ID = null;
            Ctanim.db?.insert("TBLSAYIMHAR", element.toJson());
          }

          return result;
        }
        return result;
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Future<void> sayimVeHareketSil(int fisId) async {
    //FisHareket idsi fiş id te eşitleri sil

    await Ctanim.db
        ?.delete("TBLSAYIMHAR", where: "SAYIMID = ?", whereArgs: [fisId]);
    //fisleri sil
    await Ctanim.db?.delete("TBLSAYIMSB", where: "ID = ?", whereArgs: [fisId]);
  }
}
