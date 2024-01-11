import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilat.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilatHaraket.dart';
import '../faturaFis/fis.dart';
import '../faturaFis/fisHareket.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../widget/ctanim.dart';

class TahsilatController extends GetxController {
  RxList<TahsilatHareket> gecmisTahsilatHareket = <TahsilatHareket>[].obs;
  RxList<Tahsilat> sonTahsilatListem = <Tahsilat>[].obs;
  Rx<Tahsilat>? tahsilat = Tahsilat.empty().obs;
  RxList<Tahsilat> list_tahsilat = <Tahsilat>[].obs;
  RxList<Tahsilat> list_gidecek_tahsilat = <Tahsilat>[].obs;
  RxList<Tahsilat> list_tahsilat_son10 = <Tahsilat>[].obs;
  RxList<Tahsilat> list_tahsilat_giden = <Tahsilat>[].obs;
  RxList<Tahsilat> list_tahsilat_giden_tarihli = <Tahsilat>[].obs;
  RxList<Tahsilat> list_tahsilat_kaydedilen = <Tahsilat>[].obs;
  RxList<Tahsilat> list_tahsilat_kaydedilen_tarihli = <Tahsilat>[].obs;

  RxDouble toplam = 0.0.obs;
  late DateTime tahsilat_tarihi;
  List<Tahsilat> denemeTahsilatlistesi = [];

  void tahsilataHareketEkle(
      {required int ID,
      required String UID,
      required String altHesap,
      required int tip,
      required double tutar,
      required String aciklama,
      required int taksit,
      required String doviz,
      required int dovizID,
      required double kur,
      required String kasaKod,
      required String cekSeriNo,
      required String yeri,
      required String vadeTarihi,
      required String asil,
      required String belgeNo,
      required int sozlesmeId}) {
    bool hareketVarMi = false;
    int? tahsilatId = tahsilat!.value.ID;
    for (TahsilatHareket tahsilatHareket in tahsilat!.value.tahsilatHareket) {
      if (tahsilatHareket.TIP == tip && tahsilatHareket.BELGENO == belgeNo) {
        hareketVarMi = true;
        tahsilatHareket.KUR = kur;
        tahsilatHareket.TUTAR = tutar;
        tahsilatHareket.TAKSIT = taksit;
        tahsilatHareket.DOVIZ = doviz;
        tahsilatHareket.CEKSERINO = cekSeriNo;
        tahsilatHareket.YERI = yeri;
        tahsilatHareket.ALTHESAP = altHesap;
        tahsilatHareket.VADETARIHI = vadeTarihi;
        tahsilatHareket.ASIL = asil;
        tahsilatHareket.BELGENO = belgeNo;
        tahsilatHareket.SOZLESMEID = sozlesmeId;
        tahsilatHareket.KASAKOD = kasaKod;
        tahsilatHareket.DOVIZID = dovizID;
        return;
      }
    }
    TahsilatHareket yeniTahsilatHareket = TahsilatHareket(
      ID: 0,
      ACIKLAMA: aciklama,
      ASIL: asil,
      BELGENO: belgeNo,
      CEKSERINO: cekSeriNo,
      TAHSILATID: tahsilatId,
      DOVIZ: doviz,
      SOZLESMEID: sozlesmeId,
      KASAKOD: kasaKod,
      DOVIZID: dovizID,
      ALTHESAP: altHesap,
      TAKSIT: taksit,
      TIP: tip,
      TUTAR: tutar,
      UUID: UID,
      VADETARIHI: vadeTarihi,
      YERI: yeri,
      KUR: kur,
      //AKTARILDI_MI: false
    );

    tahsilat!.value.tahsilatHareket.add(yeniTahsilatHareket);
  }

  Future<void> listTahsilatGetir({required String belgeTip}) async {
    List<Tahsilat> tt = [];
    getfis(belgeTip).then((value) {
      tt = value;
      tt.forEach((element) {
        getTahsilatHar(element.ID!)
            .then((value) => element.tahsilatHareket = value);
        //await fisHareketGetir(fisId: element.ID!,belgeTip: belgeTip ).then((value) {element.fisStokListesi = value;});

        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      });
      list_tahsilat.assignAll(tt);
    }); //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }

  Future<RxList<Tahsilat>> listSonTahsilatlarGetir() async {
    List<Tahsilat> tt = await getSonTahsilat();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<TahsilatHareket> fisHarList = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = fisHarList;
      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    });

    list_tahsilat_son10.assignAll(tt);
    return list_tahsilat_son10;
  }

  Future<List<Tahsilat>> getSonTahsilat() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'DURUM = ?', whereArgs: [false], orderBy: 'ID DESC', limit: 10);
    List<Tahsilat> son10Fis =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return son10Fis;
  }

  Future<RxList<Tahsilat>> listGidenTahsilatGetir() async {
    List<Tahsilat> tt = await getGidenTahsilat();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<TahsilatHareket> fisHarList = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = fisHarList;

      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    });

    list_tahsilat_giden.assignAll(tt);
    return list_tahsilat_giden;
  }

  Future<List<Tahsilat>> getGidenTahsilat() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'AKTARILDIMI = ?',
        whereArgs: [true],
        limit: 50,
        orderBy: 'ID DESC');
    List<Tahsilat> gidenFis =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Tahsilat>> listTarihliGidenTahsilatleriGetir(
      String basTar, String bitTar) async {
    List<Tahsilat> tt = await getTarihliGidenTahsilat(basTar, bitTar);
    await Future.forEach(tt, (element) async {
      List<TahsilatHareket> fisHarList = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = fisHarList;

      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    });

    list_tahsilat_giden_tarihli.assignAll(tt);
    return list_tahsilat_giden_tarihli;
  }

  Future<List<Tahsilat>> getTarihliGidenTahsilat(
      String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ?',
        whereArgs: [true, basTar, bitTar],
        orderBy: 'ID DESC');
    List<Tahsilat> gidenFis =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Tahsilat>> listKaydedilenTahsilatGetir() async {
    List<Tahsilat> tt = await getKaydedilenTahsilat();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<TahsilatHareket> fisHarList = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = fisHarList;

      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    });

    list_tahsilat_kaydedilen.assignAll(tt);
    return list_tahsilat_kaydedilen;
  }

  Future<List<Tahsilat>> getKaydedilenTahsilat() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'AKTARILDIMI = ? AND DURUM = ?',
        whereArgs: [false, true],
        limit: 50,
        orderBy: 'ID DESC');
    List<Tahsilat> gidenFis =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Tahsilat>> listTarihliKaydedilenTahsilatleriGetir(
      String basTar, String bitTar) async {
    List<Tahsilat> tt = await getTarihliKaydedilenTahsilat(basTar, bitTar);
    await Future.forEach(tt, (element) async {
      List<TahsilatHareket> fisHarList = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = fisHarList;

      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    });

    list_tahsilat_kaydedilen_tarihli.assignAll(tt);
    return list_tahsilat_kaydedilen_tarihli;
  }

  Future<List<Tahsilat>> getTarihliKaydedilenTahsilat(
      String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ? AND DURUM = ?',
        whereArgs: [false, basTar, bitTar, true],
        orderBy: 'ID DESC');
    List<Tahsilat> gidenFis =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return gidenFis;
  }

  Future<List<Tahsilat>> getfis(String belgeTip) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'DURUM = ? AND TIP = ?',
        whereArgs: [0, Ctanim().MapIlslemTip[belgeTip]]);
    List<Tahsilat> tt1 =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return tt1;
  }

  Future<int> getTahsilatSayisi({required String belgeTipi}) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLTAHSILATSB",
      columns: ["TIP"],
      where: 'DURUM = ? AND TIP = ?',
      whereArgs: [false, Ctanim().MapIlslemTip[belgeTipi]],
    );
    return result.length;
  }

  Future<int> getTahsilatlarSayisi(
      {required String belgeTipi1, required String belgeTipi2}) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLTAHSILATSB",
      columns: ["TIP"],
      where: 'DURUM = ? AND (TIP = ? OR TIP = ?)',
      whereArgs: [
        false,
        Ctanim().MapIlslemTip[belgeTipi1],
        Ctanim().MapIlslemTip[belgeTipi2]
      ],
    );
    return result.length;
  }

  Future<void> listGidecekTahsilatGetir({required String belgeTip}) async {
    //  List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",where: 'DURUM = ? AND TIP = ?', whereArgs: [false, Ctanim().MapFisTip[belgeTip]]);
    // print(Ctanim().MapFisTip[belgeTip]);
    List<Tahsilat> tt = await getGidecekfis(belgeTip);
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<TahsilatHareket> tahHar = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = tahHar;
      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    }
    list_gidecek_tahsilat.addAll(tt);

    //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }

  Future<List<Tahsilat>> getGidecekfis(String belgeTip) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATSB",
        where: 'AKTARILDIMI = ? AND DURUM = ? AND TIP = ?',
        whereArgs: [false, true, Ctanim().MapIlslemTip[belgeTip]]);
    List<Tahsilat> tt1 =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return tt1;
  }

  Future<void> listGidecekTekTahsilatGetir({required int tahsilatID}) async {
    List<Tahsilat> tt = await getGidecekTekfis(tahsilatID);
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<TahsilatHareket> tahHar = await getTahsilatHar(element.ID!);
      element.tahsilatHareket = tahHar;
      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    }
    list_gidecek_tahsilat.addAll(tt);

    //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }

  Future<List<Tahsilat>> getGidecekTekfis(int tahsilatID) async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLTAHSILATSB", where: ' ID = ?', whereArgs: [tahsilatID]);
    List<Tahsilat> tt1 =
        List.generate(result.length, (i) => Tahsilat.fromJson(result[i]));
    return tt1;
  }

  Future<List<TahsilatHareket>> fisHareketGetir({
    required int tahsilatId,
    required String belgeTip,
  }) async {
    //  List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISHAR",where: 'FIS_ID = ? ', whereArgs:[fisId, ]);
    List<TahsilatHareket> tt1 = [];
    getTahsilatHar(tahsilatId).then((value) {
      tt1 = value;
    });
    return tt1;
//     List<FisHareket> tt1 =  List.generate(result.length, (i) => FisHareket.fromJson(result[i]));
  }

  Future<List<TahsilatHareket>> getTahsilatHar(int tahsilatId) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLTAHSILATHAR",
        where: 'TAHSILATID = ? ', whereArgs: [tahsilatId]);
    List<TahsilatHareket> tt1 = List.generate(
        result.length, (i) => TahsilatHareket.fromJson(result[i]));
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
 } 
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
*/
}
