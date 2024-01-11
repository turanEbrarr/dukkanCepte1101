import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../localDB/veritabaniIslemleri.dart';
import '../main.dart';
import '../widget/ctanim.dart';

class FisHareket {
  int? ID = 0;
  int? FIS_ID = 0;
  String? UUID = "";
  int? MIKTAR = 0;
  double? BRUTFIYAT = 0.0; // liste fiyatı
  double? ISKONTO = 0.0; // brutfiyat-netfiyat
  double? KDVDAHILNETFIYAT = 0.0; //NETFİYAT*(1+(KDVTUTAR/100))
  double? KDVORANI = 0.0;
  double? KDVTUTAR = 0.0; // NETFİYAT*(KDVORANI/100)
  double? ISK = 0.0;
  double? ISK2 = 0.0;
  double? NETFIYAT = 0.0; // brut * (1-(ISK1/100))*(1-(ISK2/100))
  double? BRUTTOPLAMFIYAT = 0.0; //burut*miktar
  double? NETTOPLAM = 0.0;
  double? ISKONTOTOPLAM = 0.0;
  double? KDVDAHILNETTOPLAM = 0.0;
  double? KDVTOPLAM = 0.0;
  String? STOKKOD = "";
  String? STOKADI = "";
  String? BIRIM = "";
  int? BIRIMID = 0;
  int? DOVIZID = 0;
  String? DOVIZADI = "";
  String? TARIH = DateFormat("yyyy-MM-dd").format(DateTime.now());
  double? KUR = 0.0;
  String? ACIKLAMA1 = "";

  FisHareket({
    required this.ID,
    required this.FIS_ID,
    required this.STOKKOD,
    required this.STOKADI,
    required this.KDVORANI,
    required this.MIKTAR,
    required this.BRUTFIYAT,
    required this.ISKONTO,
    required this.ISK,
    required this.ISK2,
    required this.NETFIYAT,
    required this.KDVDAHILNETFIYAT,
    required this.BRUTTOPLAMFIYAT,
    required this.NETTOPLAM,
    required this.KDVDAHILNETTOPLAM,
    required this.KDVTOPLAM,
    required this.ISKONTOTOPLAM,
    required this.BIRIM,
    required this.BIRIMID,
    required this.KDVTUTAR,
    required this.DOVIZID,
    required this.DOVIZADI,
    required this.TARIH,
    required this.KUR,
    required this.ACIKLAMA1,
    required this.UUID,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['FIS_ID'] = FIS_ID;
    data['STOKKOD'] = STOKKOD;
    data['STOKADI'] = STOKADI;
    data['KDVORANI'] = KDVORANI;
    data['MIKTAR'] = MIKTAR;
    data['BRUTFIYAT'] = BRUTFIYAT;
    data['ISKONTO'] = ISKONTO;
    data['ISK'] = ISK;
    data['ISK2'] = ISK2;
    data['NETFIYAT'] = NETFIYAT;
    data['KDVDAHILNETFIYAT'] = KDVDAHILNETFIYAT;
    data['BRUTTOPLAMFIYAT'] = BRUTTOPLAMFIYAT;
    data['NETTOPLAM'] = NETTOPLAM;
    data['ISKONTOTOPLAM'] = ISKONTOTOPLAM;
    data['KDVDAHILNETTOPLAM'] = KDVDAHILNETTOPLAM;
    data['KDVTOPLAM'] = KDVTOPLAM;
    data['BIRIM'] = BIRIM;
    data['BIRIMID'] = BIRIMID;
    data['KDVTUTAR'] = KDVTUTAR;
    data['DOVIZID'] = DOVIZID;
    data['DOVIZADI'] = DOVIZADI;
    data['TARIH'] = TARIH;
    data['KUR'] = KUR;
    data['ACIKLAMA1'] = ACIKLAMA1;
    data['UUID'] = UUID;
    return data;
  }

  FisHareket.empty()
      : this(
          ID: 0,
          FIS_ID: 0,
          STOKKOD: "",
          STOKADI: "",
          KDVORANI: 0.0,
          ISKONTO: 0.0,
          MIKTAR: 0,
          BRUTFIYAT: 0.0,
          ISK: 0.0,
          ISK2: 0.0,
          BRUTTOPLAMFIYAT: 0.0,
          NETFIYAT: 0.0,
          KDVDAHILNETFIYAT: 0.0,
          BIRIM: "",
          BIRIMID: 0,
          KDVTUTAR: 0.0,
          DOVIZID: 0,
          DOVIZADI: "",
          TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          KUR: 1.0,
          ACIKLAMA1: "",
          UUID: "",
          ISKONTOTOPLAM: 0.0,
          KDVDAHILNETTOPLAM: 0.0,
          KDVTOPLAM: 0.0,
          NETTOPLAM: 0.0,
        );
  FisHareket.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    FIS_ID = int.parse(json['FIS_ID'].toString());
    STOKKOD = json['STOKKOD'];
    STOKADI = json['STOKADI'];
    KDVORANI = double.parse(json['KDVORANI'].toString());
    MIKTAR = int.parse(json['MIKTAR'].toString());
    BRUTFIYAT = double.parse(json['BRUTFIYAT'].toString());
    ISKONTO = double.parse(json['ISKONTO'].toString());
    ISK = double.parse(json['ISK'].toString());
    ISK2 = double.parse(json['ISK2'].toString());
    NETFIYAT = double.parse(json['NETFIYAT'].toString());
    KDVDAHILNETFIYAT = double.parse(json['KDVDAHILNETFIYAT'].toString());
    BRUTTOPLAMFIYAT = double.parse(json['BRUTTOPLAMFIYAT'].toString());
    NETTOPLAM = double.parse(json['NETTOPLAM'].toString());
    ISKONTOTOPLAM = double.parse(json['ISKONTOTOPLAM'].toString());
    KDVDAHILNETTOPLAM = double.parse(json['KDVDAHILNETTOPLAM'].toString());
    KDVTOPLAM = double.parse(json['KDVTOPLAM'].toString());
    BIRIM = json['BIRIM'];
    BIRIMID = int.parse(json['BIRIMID'].toString());
    KDVTUTAR = double.parse(json['KDVTUTAR'].toString());
    DOVIZID = int.parse(json['DOVIZID'].toString());
    DOVIZADI = json['DOVIZADI'];
    TARIH = json['TARIH'];
    KUR = double.parse(json['KUR'].toString());
    ACIKLAMA1 = json['ACIKLAMA1'];
    UUID = json['UUID'];
  }

 // uyak

  Future<int> fisHareketSil(int Id) async {
    var result =
        await Ctanim.db?.delete("TBLFISHAR", where: 'ID = ?', whereArgs: [Id]);
    return result;
  }
}
