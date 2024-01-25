import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/faturaFis/fisEkParam.dart';
import 'package:dukkan_cepte/genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';
import '../faturaFis/fis.dart';
import '../faturaFis/fisHareket.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../widget/ctanim.dart';

class FisController extends GetxController {

  
  RxList<FisHareket> gecmisFisHareket = <FisHareket>[].obs;
  RxList<Fis> sonListem = <Fis>[].obs;
  Rx<Fis>? fis = Fis.empty().obs;
  RxList<Fis> list_fis = <Fis>[].obs;
  RxList<Fis> list_fis_son10 = <Fis>[].obs;
  RxList<Fis> list_fis_gidecek = <Fis>[].obs;
  RxList<Fis> list_fis_giden = <Fis>[].obs;
  RxList<Fis> list_fis_kaydedilen = <Fis>[].obs;
  RxList<Fis> list_fis_giden_tarihli = <Fis>[].obs;
  RxList<Fis> list_fis_kaydedilen_tarihli = <Fis>[].obs;
  RxDouble toplam = 0.0.obs;

  late DateTime fis_tarihi;
  List<FisHareket> denemelistesi = [];

  void fiseStokEkle(
      {
      required String belgeTipi,  
      required bool urunListedenMiGeldin,
      required double KUR,
      required String TARIH,
      required String Aciklama1,
      required String UUID,
      required String stokAdi,
      required String stokKodu,
      required double KDVOrani,
      required int miktar,
      required double burutFiyat,
      required double iskonto,
      required double iskonto2,
      required String birim,
      required int birimID,
      required int dovizId,
      required String dovizAdi}) {
    bool stokVarMi = false;
    int? fisId = fis!.value.ID;

    double HbrutFiyat = burutFiyat;
    double HnetFiyat = HbrutFiyat * (1 - iskonto / 100) * (1 - iskonto2 / 100);
    double Hiskonto = HbrutFiyat - HnetFiyat;
    double HkdvDahilNetFiyat = (HnetFiyat * (1 + KDVOrani / 100));
    double HkdvTutar = HnetFiyat * (KDVOrani / 100);
    double HbrutToplamFiyat = 0.0;
    double HnetToplamFiyat = 0.0;
    double HiskontoToplamFiyat = 0.0;
    double HkdvDahilNetFiyatToplam = 0.0;
    double HkdvTutarToplam = 0.0;
    KUSURAT Kfiyat;
    KUSURAT Kmiktar;
    KUSURAT Kkur;
    KUSURAT KdovizFiyat ;
    KUSURAT Ktutar;
    KUSURAT KdovTutar;
    int tip = Ctanim().MapFisTip[belgeTipi]??0;

    if(tip == 3||tip==12||tip==17){
       Kfiyat = KUSURAT.ALISFIYAT;
       Kmiktar = KUSURAT.ALISMIKTAR;
       Kkur = KUSURAT.ALISKUR;
       KdovizFiyat = KUSURAT.ALISDOVFIYAT;
       Ktutar=KUSURAT.ALISTUTAR;
       KdovTutar=KUSURAT.ALISDOVTUTAR;
    }
    else if(tip == 1||tip==4||tip==6){
       Kfiyat=KUSURAT.PERFIYAT;
       Kmiktar=KUSURAT.PERMIKTAR;
       Kkur=KUSURAT.PERKUR;
       KdovizFiyat=KUSURAT.PERDOVFIYAT;
       Ktutar=KUSURAT.PERTUTAR;
       KdovTutar=KUSURAT.PERDOVTUTAR;
    }
    else{
       Kfiyat=KUSURAT.FIYAT;
       Kmiktar=KUSURAT.MIKTAR;
       Kkur=KUSURAT.KUR;
       KdovizFiyat=KUSURAT.DOVFIYAT;
       Ktutar=KUSURAT.TUTAR;
       KdovTutar=KUSURAT.DOVTUTAR;
    }

    for (FisHareket fisHareket in fis!.value.fisStokListesi) {
      if (fisHareket.STOKKOD == stokKodu) {
        stokVarMi = true;
        if (urunListedenMiGeldin == false) {
          fisHareket.MIKTAR =
              int.parse((fisHareket.MIKTAR! + miktar).toString());
           //  fisHareket.MIKTAR =
          //    int.parse(Ctanim.noktadanSonraAlinacakParametreli(Kmiktar,double.parse((fisHareket.MIKTAR! + miktar).toString())));  
          HbrutToplamFiyat = HbrutFiyat * fisHareket.MIKTAR!;
          HnetToplamFiyat = HnetFiyat * fisHareket.MIKTAR!;
          HiskontoToplamFiyat = Hiskonto * fisHareket.MIKTAR!;
          HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * fisHareket.MIKTAR!;
          HkdvTutarToplam = HkdvTutar * fisHareket.MIKTAR!;
        } else {
          fisHareket.MIKTAR = int.parse((miktar).toString());
          HbrutToplamFiyat = HbrutFiyat * fisHareket.MIKTAR!;
          HnetToplamFiyat = HnetFiyat * fisHareket.MIKTAR!;
          HiskontoToplamFiyat = Hiskonto * fisHareket.MIKTAR!;
          HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * fisHareket.MIKTAR!;
          HkdvTutarToplam = HkdvTutar * fisHareket.MIKTAR!;
        }

        fisHareket.KDVORANI = Ctanim.noktadanSonraAlinacak(KDVOrani);
        fisHareket.BRUTFIYAT = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HbrutFiyat,doubleMiDonsun: true);
        fisHareket.ISKONTO = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,Hiskonto,doubleMiDonsun: true);
        fisHareket.KDVDAHILNETFIYAT =
            Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvDahilNetFiyat,doubleMiDonsun: true);
        fisHareket.KDVTUTAR = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvTutar,doubleMiDonsun: true);
        fisHareket.NETFIYAT = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HnetFiyat,doubleMiDonsun: true);
        fisHareket.NETTOPLAM = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HnetToplamFiyat,doubleMiDonsun: true);
        fisHareket.BRUTTOPLAMFIYAT =
             Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HbrutToplamFiyat,doubleMiDonsun: true);
        fisHareket.ISKONTOTOPLAM =
            Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HiskontoToplamFiyat,doubleMiDonsun: true);
        fisHareket.KDVDAHILNETTOPLAM =
         Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvDahilNetFiyatToplam,doubleMiDonsun: true);
        fisHareket.KDVTOPLAM =  Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvTutarToplam,doubleMiDonsun: true);
        fisHareket.ISK = Ctanim.noktadanSonraAlinacak(iskonto);
        fisHareket.ISK2 = Ctanim.noktadanSonraAlinacak(iskonto2);
        //fisHareket.BURUTFIYAT = burutFiyat;
        //fisHareket.ISK = iskonto;

        // fisHareket.NETFIYAT = burutFiyat * (1 - iskonto / 100);
        //fisHareket.KDVDAHILNETFIYAT =
        //  (burutFiyat * (1 - iskonto / 100)) * miktar;

        return;
      }
    }
    HbrutToplamFiyat = HbrutFiyat * miktar;
    HnetToplamFiyat = HnetFiyat * miktar;
    HiskontoToplamFiyat = Hiskonto * miktar;
    HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * miktar;
    HkdvTutarToplam = HkdvTutar * miktar;
    FisHareket yeniFisHareket = FisHareket(
      UUID: UUID,
      TARIH: TARIH,
      KUR: KUR,
      ACIKLAMA1: Aciklama1,
      ID: 0,
      FIS_ID: fisId,
      STOKKOD: stokKodu,
      STOKADI: stokAdi,
      KDVORANI: KDVOrani,
      MIKTAR: int.parse(miktar.toString()),//parametre eklenebilir
      BRUTFIYAT: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HbrutFiyat,doubleMiDonsun: true),
      ISK: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,iskonto,doubleMiDonsun: true),
      ISK2: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,iskonto2,doubleMiDonsun: true),
      ISKONTO: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,Hiskonto,doubleMiDonsun: true),
      KDVDAHILNETFIYAT: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvDahilNetFiyat,doubleMiDonsun: true),
      KDVTUTAR: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvTutar,doubleMiDonsun: true),
      NETFIYAT: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HnetFiyat,doubleMiDonsun: true),
      BRUTTOPLAMFIYAT: Ctanim.noktadanSonraAlinacak(HbrutToplamFiyat),
      BIRIM: birim,
      BIRIMID: birimID,
      DOVIZADI: dovizAdi,
      DOVIZID: dovizId,
      ISKONTOTOPLAM: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HiskontoToplamFiyat,doubleMiDonsun: true),
      KDVDAHILNETTOPLAM: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvDahilNetFiyatToplam,doubleMiDonsun: true),
      KDVTOPLAM: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HkdvTutarToplam,doubleMiDonsun: true),
      NETTOPLAM:Ctanim.noktadanSonraAlinacakParametreli(Kfiyat,HnetToplamFiyat,doubleMiDonsun: true),
    );

    fis!.value.fisStokListesi.add(yeniFisHareket);
  }

  void fiseFiyatsizStokEkle({
    required String TARIH,
    required String Aciklama1,
    required String UUID,
    required String stokAdi,
    required String stokKodu,
    required double KDVOrani,
    required int miktar,
    required String birim,
    required int birimID,
  }) {
    bool stokVarMi = false;
    int? fisId = fis!.value.ID;

    for (FisHareket fisHareket in fis!.value.fisStokListesi) {
      if (fisHareket.STOKKOD == stokKodu) {
        stokVarMi = true;
        fisHareket.MIKTAR = fisHareket.MIKTAR! + miktar;
        fisHareket.BRUTFIYAT = 0;

        fisHareket.ISKONTO = 0;
        fisHareket.KDVDAHILNETFIYAT = 0;
        fisHareket.KDVTUTAR = 0;
        fisHareket.NETFIYAT = 0;
        fisHareket.NETTOPLAM = 0;
        fisHareket.BRUTTOPLAMFIYAT = 0;
        fisHareket.ISKONTOTOPLAM = 0;
        fisHareket.KDVDAHILNETTOPLAM = 0;
        fisHareket.KDVTOPLAM = 0;
        //fisHareket.BURUTFIYAT = burutFiyat;
        //fisHareket.ISK = iskonto;

        // fisHareket.NETFIYAT = burutFiyat * (1 - iskonto / 100);
        //fisHareket.KDVDAHILNETFIYAT =
        //  (burutFiyat * (1 - iskonto / 100)) * miktar;

        return;
      }
    }
    FisHareket yeniFisHareket = FisHareket(
      UUID: UUID,
      TARIH: TARIH,
      KUR: 0,
      ACIKLAMA1: Aciklama1,
      ID: 0,
      FIS_ID: fisId,
      STOKKOD: stokKodu,
      STOKADI: stokAdi,
      KDVORANI: KDVOrani,
      MIKTAR: miktar,
      BRUTFIYAT: 0,
      ISK: 0,
      ISK2: 0,
      ISKONTO: 0,
      KDVDAHILNETFIYAT: 0,
      KDVTUTAR: 0,
      NETFIYAT: 0,
      BRUTTOPLAMFIYAT: 0,
      BIRIM: birim,
      BIRIMID: birimID,
      DOVIZADI: "",
      DOVIZID: 0,
      ISKONTOTOPLAM: 0,
      KDVDAHILNETTOPLAM: 0,
      KDVTOPLAM: 0,
      NETTOPLAM: 0,
    );

    fis!.value.fisStokListesi.add(yeniFisHareket);
  }

  Future<void> listFisGetir({required String belgeTip}) async {
    List<Fis> tt = [];
    getfis(belgeTip).then((value) {
      tt = value;
      tt.forEach((element) {
        getFisHar(element.ID!).then((value) => element.fisStokListesi = value);
        getFisEkParam(element.ID!).then((value) => element.listFisEkParam = value);
        

        //await fisHareketGetir(fisId: element.ID!,belgeTip: belgeTip ).then((value) {element.fisStokListesi = value;});
//cari kod
        if (belgeTip != "Depo_Transfer") {
          element.cariKart =
              cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
        }
      });
      list_fis.assignAll(tt);
    }); //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }
// DEPO İÇİN
/*
  Future<void> listDepoFisGetir({required String belgeTip}) async {
    //  List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",where: 'DURUM = ? AND TIP = ?', whereArgs: [false, Ctanim().MapFisTip[belgeTip]]);
    // print(Ctanim().MapFisTip[belgeTip]);
    List<Fis> tt = [];
    getfis(belgeTip).then((value) {
      tt = value;
      tt.forEach((element) {
        getFisHar(element.ID!).then((value) => element.fisStokListesi = value);
        //await fisHareketGetir(fisId: element.ID!,belgeTip: belgeTip ).then((value) {element.fisStokListesi = value;});
      });
      list_fis.assignAll(tt);
    }); //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }
  */

  Future<List<Fis>> getfis(String belgeTip) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ? AND TIP = ?',
        whereArgs: [false, Ctanim().MapFisTip[belgeTip]]);
    List<Fis> tt1 =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return tt1;
  }
// Gİdecek Fişleri Çekmek için yazıldı

  Future<void> listGidecekFisGetir({required String belgeTip}) async {
    List<Fis> tt = await getGidecekfis(belgeTip);
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<FisHareket> fisHar = await getFisHar(element.ID!);
      List<FisEkParam> fisEkParam = await getFisEkParam(element.ID!);
      element.fisStokListesi = fisHar;
      element.listFisEkParam = fisEkParam;
      if (belgeTip != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    }
    list_fis_gidecek.addAll(tt);
  }

  Future<void> listGidecekTekFisGetir(
      {required String belgeTip, required int fisID}) async {
    list_fis_gidecek.clear();
    List<Fis> tt = await getGidecekTekfis(belgeTip, fisID);
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<FisHareket> fisHar = await getFisHar(element.ID!);
      List<FisEkParam> fisEkParam = await getFisEkParam(element.ID!);
      element.fisStokListesi = fisHar;
      element.listFisEkParam = fisEkParam;
      if (belgeTip != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    }
    list_fis_gidecek.addAll(tt);
  }

  Future<List<Fis>> getGidecekTekfis(String belgeTip, int fisID) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'ID = ?',
        whereArgs: [
          fisID
        ]); // doprudan fiş ıd veriyosun diğer bakılacaklara gerek yok ki
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }

  Future<List<Fis>> getGidecekfis(String belgeTip) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ? AND TIP = ? AND AKTARILDIMI = ?',
        whereArgs: [true, Ctanim().MapFisTip[belgeTip], false]);
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }

  Future<RxList<Fis>> listSonFisleriGetir() async {
    List<Fis> tt = await getSonFis();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
       List<FisEkParam> fisEkParams = await getFisEkParam(element.ID!);
      element.fisStokListesi = fisHarList;
      element.listFisEkParam = fisEkParams; // demmekiiii lazım tuaaan
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_son10.assignAll(tt);
    return list_fis_son10;
  }

  Future<List<Fis>> getSonFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ?', whereArgs: [false], orderBy: 'ID DESC', limit: 10);
    List<Fis> son10Fis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return son10Fis;
  }

  Future<RxList<Fis>> listGidenFisleriGetir() async {
    List<Fis> tt = await getGidenFis();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_giden.assignAll(tt);
    return list_fis_giden;
  }

  Future<List<Fis>> getGidenFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'AKTARILDIMI = ?',
        whereArgs: [true],
        limit: 50,
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listKaydedilmisFisleriGetir() async {
    List<Fis> tt = await getKaydedilmisFis();
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_kaydedilen.assignAll(tt);
    return list_fis_kaydedilen;
  }

  Future<List<Fis>> getKaydedilmisFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ? AND AKTARILDIMI = ?',
        whereArgs: [true, false],
        limit: 50,
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listTarihliGidenFisleriGetir(
      String basTar, String bitTar) async {
    List<Fis> tt = await getTarihliGidenFis(basTar, bitTar);

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_giden_tarihli.assignAll(tt);
    return list_fis_giden_tarihli;
  }

  Future<List<Fis>> getTarihliGidenFis(String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ?',
        whereArgs: [true, basTar, bitTar],
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listTarihliKaydedilenFisleriGetir(
      String basTar, String bitTar) async {
    List<Fis> tt = await getTarihliKaydedilenFis(basTar, bitTar);
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_kaydedilen_tarihli.assignAll(tt);
    return list_fis_kaydedilen_tarihli;
  }

  Future<List<Fis>> getTarihliKaydedilenFis(
      String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ? AND DURUM = ?',
        whereArgs: [false, basTar, bitTar, true],
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<int> getFisSayisi({required String belgeTipi}) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLFISSB",
      columns: ["TIP"],
      where: 'DURUM = ? AND TIP = ?',
      whereArgs: [false, Ctanim().MapFisTip[belgeTipi]],
    );
    return result.length;
  }

  Future<int> getFislerSayisi(
      {required String belgeTipi1,
      required String belgeTipi2,
      required String belgeTipi3}) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLFISSB",
      columns: ["TIP"],
      where: 'DURUM = ? AND (TIP = ? OR TIP = ? OR TIP = ?)',
      whereArgs: [
        false,
        Ctanim().MapFisTip[belgeTipi1],
        Ctanim().MapFisTip[belgeTipi2],
        Ctanim().MapFisTip[belgeTipi3]
      ],
    );
    return result.length;
  }

/* bu fonksiyona gerek yok galiba

  Future<List<FisHareket>> fisHareketGetir({
    required int fisId,
    required String belgeTip,
  }) async {
    //  List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISHAR",where: 'FIS_ID = ? ', whereArgs:[fisId, ]);
    List<FisHareket> tt1 = [];
    getFisHar(fisId).then((value) {
      tt1 = value;
    });
    return tt1;
//     List<FisHareket> tt1 =  List.generate(result.length, (i) => FisHareket.fromJson(result[i]));
  }
//// buraya kadar 
*/
  Future<List<FisHareket>> getFisHar(int fisId) async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLFISHAR", where: 'FIS_ID = ? ', whereArgs: [fisId]);
    List<FisHareket> tt1 =
        List.generate(result.length, (i) => FisHareket.fromJson(result[i]));
    return tt1;
  }
    Future<List<FisEkParam>> getFisEkParam(int fisId) async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLFISEKPARAM", where: 'FISID = ? ', whereArgs: [fisId]);
    List<FisEkParam> tt1 =
        List.generate(result.length, (i) => FisEkParam.fromJson(result[i]));
    return tt1;
  }

//
  /*  Future<void> listFisStokHareketGetir(String Kod) async
 { 
  gecmisFisHareket.clear();
  sonListem.clear();
  
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISHAR",where: 'STOKKOD = ?', whereArgs: [Kod]); 
    List<FisHareket> yy=   List.generate(result.length, (i) => FisHareket.fromJson(result[i]));
    yy.forEach((element) async{    
     List<Map<String, dynamic>> donus = await Ctanim.db?.query("TBLFISSB",where: 'ID = ?', whereArgs: [element.FIS_ID]); 
    Fis fis=   List.generate(donus.length, (i) => Fis.fromJson(donus[i])).first;
    if(element.STOKKOD == Kod){
      gecmisFisHareket.add(element);

    }
    
//    fis.fisStokListesi=gecmisFisHareket;
    sonListem.add(Fis.fromFis(fis, gecmisFisHareket)); 
   });
//    list_fis.assignAll(yy); 
 } */
  Widget gecmisSatisYok() {
    return Center(child: Text("Geçmiş Satış Bilgisi Bulunamadı."));
  }

  Future<void> listFisStokHareketGetir(String Kod) async {
    gecmisFisHareket.clear();
    sonListem.clear();

    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLFISHAR", where: 'STOKKOD = ?', whereArgs: [Kod]);
    if (result.isEmpty) {
      gecmisSatisYok();
      return;
    }

    String fisIDs = result
        .map((e) => e['FIS_ID'].toString())
        .join(','); // fiş idler , ayrılıp stringe at

    List<Map<String, dynamic>> donus = await Ctanim.db?.query("TBLFISSB",
        where: 'ID IN ($fisIDs)'); // Tüm fişler tek seferde getirilir

    for (Map<String, dynamic> fisMap in donus) {
      Fis fis = Fis.fromJson(fisMap);

      // Fişteki stok hareketlerinden sadece Kod'a uygun olanlar seçilir ve gecmisFisHareket listesine eklenir
      List<FisHareket> fisHareketleri = result
          .where((e) => e['FIS_ID'] == fis.ID && e['STOKKOD'] == Kod)
          .map((e) => FisHareket.fromJson(e))
          .toList();
      fis.fisStokListesi = fisHareketleri;

      sonListem.add(Fis.fromFis(fis, fisHareketleri));
    }
  }
/*
 Future<void> FisGetir(int id) async
 { 
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",where: 'ID = ?', whereArgs: [id]); 
    List<Fis> tt=   List.generate(result.length, (i) => Fis.fromJson(result[i]));

    tt.forEach((element) async{  
    element.fisStokListesi=await fisHareketGetir(element.ID!, );

    for(int i=0; i<element.fisStokListesi.length; i++){
      element.fisStokListesi[i].STOKKOD = stokKartEx.searchList.where((c) => c.KOD==element.fisStokListesi[i].STOKKOD).toString();
    }
    //element.fisStokListesi = cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD); 
   });
  
    list_fis.assignAll(tt); 
 } 
*/
}
