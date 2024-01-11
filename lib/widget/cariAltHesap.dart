import 'package:flutter/material.dart';

class CariAltHesap {
  String? KOD = "";
  String? ALTHESAP = "";
  int? DOVIZID;
  String? VARSAYILAN =""; 

  CariAltHesap({required this.KOD, required this.ALTHESAP,required this.DOVIZID,required this.VARSAYILAN});

  CariAltHesap.fromJson(Map<String, dynamic> json) {
    KOD = json['KOD'];
    ALTHESAP = json['ALTHESAP'];
    DOVIZID = int.parse(json['DOVIZID'].toString());
    VARSAYILAN = json['VARSAYILAN'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['KOD'] = KOD;
    data['ALTHESAP'] = ALTHESAP;
    data['DOVIZID'] = DOVIZID;
    data['VARSAYILAN'] = VARSAYILAN;
    return data;
  }
}
