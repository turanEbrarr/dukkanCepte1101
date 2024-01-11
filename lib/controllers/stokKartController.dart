import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:dukkan_cepte/widget/cari.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../main.dart';
import '../widget/veriler/listeler.dart';
import '../stok_kart/stok_tanim.dart';
import '../webservis/base.dart';

class StokKartController extends GetxController {
  RxList<StokKart> searchList = <StokKart>[].obs;
  RxList<StokKart> tempList = <StokKart>[].obs;

  // RxList<StokKart> stoklar = stoklar.obs;
  BaseService bs = BaseService();
  VeriIslemleri veriislemi = VeriIslemleri();

  @override
  void onInit() {
    super.onInit();
  }

/*  void sepetGuncellenenStok(int index, double iskonto, String fiyat) {
    var stokKart = searchList[index];

    stokKart.SATISISK = iskonto;
    stokKart.SFIYAT1 = double.parse(fiyat);
    update();
  }*/

  List<dynamic> fiyatgetir(StokKart Stok, String CariKod, String _FiyatTip,
     ) {
    bool fiyatDegistirsinMi = false;
    if (Ctanim.kullanici!.FIYATDEGISTIRILSIN == "E") {
      fiyatDegistirsinMi = true;
    }

    String Fiyattip = _FiyatTip;
    double kosulYoksaTekrarDonecek = 0.0;
    Cari seciliCari = Cari();
    double iskontoDegeri = 0;
    for (var cari in listeler.listCari) {
      if (cari.KOD == CariKod) {
        seciliCari = cari;
      }
    }

    Fiyattip = Fiyattip;
    String seciliFiyat = "";
    double kosuldanDonenFiyat = 0.0;
    if (CariKod != '') {
   

        if (Ctanim.kullanici!.SATISTIPI == "0") {
          StokKart ff = searchList.where((p0) => p0.KOD == Stok.KOD).first;

          if (Fiyattip == 'Fiyat1') {
            kosulYoksaTekrarDonecek == ff.SFIYAT1;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [ff.SFIYAT1, ff.SATISISK, "Fiyat1", true];
          } else if (Fiyattip == 'Fiyat2') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT2;
            // double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [ff.SFIYAT2, ff.SATISISK, "Fiyat2", true];
          } else if (Fiyattip == 'Fiyat3') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT3;
            // double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [ff.SFIYAT3, ff.SATISISK, "Fiyat3", true];
          } else if (Fiyattip == 'Fiyat4') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT4;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [ff.SFIYAT4, ff.SATISISK, "Fiyat4", true];
          } else if (Fiyattip == 'Fiyat5') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT5;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [ff.SFIYAT5, ff.SATISISK, "Fiyat5", true];
          } else {
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == 0.0;
            return [0.0, ff.SATISISK, Fiyattip, true];
          }
        } else if (Ctanim.kullanici!.SATISTIPI == "1") {

        } else if (Ctanim.kullanici!.SATISTIPI == "2") {
          double sonFiyat = 0.0;
          if(seciliCari.FIYAT == 1){
            sonFiyat = Stok.SFIYAT1!;

          }else if (seciliCari.FIYAT == 2){
            sonFiyat = Stok.SFIYAT2!;

          }else if (seciliCari.FIYAT == 3){
            sonFiyat = Stok.SFIYAT3!;

          }else if (seciliCari.FIYAT == 4){
            sonFiyat = Stok.SFIYAT4!;

          }else if (seciliCari.FIYAT == 5){
            sonFiyat = Stok.SFIYAT5!;

          }else{
            sonFiyat = 0.0;
          }

          return [sonFiyat, seciliCari.ISKONTO, seciliCari.FIYAT, false];
        } else if (Ctanim.kullanici!.SATISTIPI == "3") {
       
        }
        if (kosuldanDonenFiyat == 0) {
          if (Fiyattip == "Fiyat1") {
            return [Stok.SFIYAT1, Stok.SATISISK, _FiyatTip, true];
          } else if (Fiyattip == "Fiyat2") {
            return [Stok.SFIYAT2, Stok.SATISISK, _FiyatTip, true];
          } else if (Fiyattip == "Fiyat3") {
            return [Stok.SFIYAT3, Stok.SATISISK, _FiyatTip, true];
          } else if (Fiyattip == "Fiyat4") {
            return [Stok.SFIYAT4, Stok.SATISISK, _FiyatTip, true];
          } else if (Fiyattip == "Fiyat5") {
            return [Stok.SFIYAT5, Stok.SATISISK, _FiyatTip, true];
          }
        }
      
      return [];
    }
    return [];
  }
/*
  double iskontoGetir(String StokKod, String CariKod,
      {double isk1 = 0,
      double isk2 = 0,
      double isk3 = 0,
      double isk4 = 0,
      double isk5 = 0,
      double isk6 = 0}) {
    StokKart ff =
        stokKartEx.searchList.where(((p0) => p0.KOD == StokKod)).first;
    return ff.SATISISK;
  }
  */

  void searchB(String query) {
    if (query.isEmpty) {
      searchList.assignAll(listeler.liststok);
    } else {
      var results = listeler.liststok
          .where((value) =>
              value.ADI!.toLowerCase().contains(query.toLowerCase()) ||
              value.KOD!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      searchList.assignAll(results);
    }
  }


  Future aToZSort() async {
    Comparator<StokKart> sirala =
        (a, b) => a.ADI!.toLowerCase().compareTo(b.ADI!.toLowerCase());
    listeler.liststok.sort(sirala);
  }

//servisten stokları günceller
  Future<String> servisStokGetir() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      print("internet yok");
      const snackBar = SnackBar(
        content: Text(
          'İnternet bağlantısı yok.',
          style: TextStyle(fontSize: 16),
        ),
        showCloseIcon: true,
        backgroundColor: Colors.blue,
        closeIconColor: Colors.white,
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      return "İnternet bağlantısı yok.";
    } else {
      if (Ctanim.db == null) {
        const snackBar = SnackBar(
          content: Text(
            'Veritabanı bağlantısı başarısız.',
            style: TextStyle(fontSize: 16),
          ),
          showCloseIcon: true,
          backgroundColor: Colors.blue,
          closeIconColor: Colors.white,
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        return 'Veritabanı bağlantısı başarısız.';
      } else {
        String don = await bs.getirStoklar(
            kullaniciKodu: Ctanim.kullanici!.KOD, sirket: Ctanim.sirket!);
        return don;
      }
    }
  }
}
