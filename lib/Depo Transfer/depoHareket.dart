import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../widget/ctanim.dart';

class SayimHareket {
  int? ID = 0;
  int? SAYIMID = 0;
  String? STOKKOD = "";
  String? STOKADI = "";
  String? BIRIM = "";
  int? BIRIMID = 0;
  int? MIKTAR = 0;
  String? ACIKLAMA = "";
  String? RAF = "";
  String? UUID = "";

  SayimHareket({
    required this.ID,
    required this.SAYIMID,
    required this.STOKKOD,
    required this.STOKADI,
    required this.BIRIM,
    required this.BIRIMID,
    required this.MIKTAR,
    required this.ACIKLAMA,
    required this.RAF,
    required this.UUID,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['SAYIMID'] = SAYIMID;
    data['STOKKOD'] = STOKKOD;
    data['STOKADI'] = STOKADI;
    data['BIRIM'] = BIRIM;
    data['BIRIMID'] = BIRIMID;
    data['MIKTAR'] = MIKTAR;
 
    data['ACIKLAMA'] = ACIKLAMA;
    data['RAF'] = RAF;
    data['UUID'] = UUID;
    return data;
  }

  SayimHareket.empty()
      : this(
            ID: 0,
            SAYIMID: 0,
            STOKKOD: "",
            STOKADI: "",
            BIRIM: "",
            BIRIMID :0,
            MIKTAR: 0,
            ACIKLAMA: "",
            RAF: "",
            UUID: "");

  SayimHareket.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    SAYIMID = int.parse(json['SAYIMID'].toString());
    STOKKOD = json['STOKKOD'];
    STOKADI = json['STOKADI'];
    BIRIM = json['BIRIM'];
    MIKTAR = int.parse(json['MIKTAR'].toString());
    BIRIMID = int.parse(json['BIRIMID'].toString());
    
    ACIKLAMA = json['ACIKLAMA'];
    RAF = json['RAF'];
    UUID = json['UUID'];
  }
  Future<int?> sayimHareketEkle(SayimHareket sayimHareket) async {
    if (sayimHareket.ID! > 0) {
      try {
        var result = await Ctanim.db?.update(
            "TBLSAYIMHAR", sayimHareket.toJson(),
            where: 'ID = ?', whereArgs: [sayimHareket.ID]);
        return result;
      } on PlatformException catch (e) {
        return -1;
      }
    } else {
      try {
        sayimHareket.ID = null;
        var result =
            await Ctanim.db?.insert("TBLSAYIMHAR", sayimHareket.toJson());

        return result;
      } on PlatformException catch (e) {
        return -1;
      }
    }
  }

  Future<int> sayimHareketSil(int Id) async {
    var result = await Ctanim.db
        ?.delete("TBLSAYIMHAR", where: 'ID = ?', whereArgs: [Id]);
    return result;
  }
}
