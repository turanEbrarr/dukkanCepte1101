import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Depo Transfer/depo.dart';

import '../Depo Transfer/depoHareket.dart';
import '../faturaFis/fis.dart';
import '../faturaFis/fisHareket.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../widget/ctanim.dart';

class SayimController extends GetxController {
  RxList<SayimHareket> gecmisSayimHareket = <SayimHareket>[].obs;
  RxList<Sayim> sonDepoListem = <Sayim>[].obs;

  Rx<Sayim>? sayim = Sayim.empty().obs;
  RxList<Sayim> list_Depo = <Sayim>[].obs;

  RxList<Sayim> list_gidecek_Depo = <Sayim>[].obs;
  RxDouble toplam = 0.0.obs;
  RxList<Sayim> list_fis_giden = <Sayim>[].obs;
  RxList<Sayim> list_fis_giden_tarihli = <Sayim>[].obs;
  RxList<Sayim> list_fis_kaydedilen = <Sayim>[].obs;
  RxList<Sayim> list_fis_kaydedilen_tarihli = <Sayim>[].obs;
  late DateTime Depo_tarihi;
  List<Sayim> denemeDepolistesi = [];

  void DepoaHareketEkle({
    required int SAYIMID,
    required String STOKKOD,
    required String STOKADI,
    required String BIRIM,
    required int BIRIMID,
    required int MIKTAR,
    required double FIYAT,
    required String ACIKLAMA,
    required String RAF,
    required String UUID,
  }) {
    bool hareketVarMi = false;
    int? DepoId = sayim!.value.ID;
    for (SayimHareket sayimHareket in sayim!.value.sayimStokListesi) {
      if (sayimHareket.STOKKOD == STOKKOD) {
        hareketVarMi = true;
        sayimHareket.BIRIM = BIRIM;
        sayimHareket.BIRIMID = BIRIMID;
        sayimHareket.MIKTAR = sayimHareket.MIKTAR! + MIKTAR;

        sayimHareket.ACIKLAMA = ACIKLAMA;
        sayimHareket.RAF = RAF;

        //DİĞER ÖZELİLKLER EKLENMEDİ GEREK YOK
        return;
      }
    }
    //FİS HAREKETTE AKTARILDI MI YOK BİZ DE VAR FONKSİYONA ALINMADI ??????
    SayimHareket yeniSayimHareket = SayimHareket(
      ID: 0, BIRIM: BIRIM, MIKTAR: MIKTAR, BIRIMID: BIRIMID,
      STOKADI: STOKADI, STOKKOD: STOKKOD,
      UUID: UUID, ACIKLAMA: ACIKLAMA, RAF: RAF, SAYIMID: SAYIMID,

      //AKTARILDI_MI: false
    );

    sayim!.value.sayimStokListesi.add(yeniSayimHareket);
  }

  Future<void> listSayimGetir() async {
    List<Sayim> tt = [];
    getfis().then((value) {
      tt = value;
      tt.forEach((element) {
        getSayimHar(element.ID!)
            .then((value) => element.sayimStokListesi = value);
        //await fisHareketGetir(fisId: element.ID!,belgeTip: belgeTip ).then((value) {element.fisStokListesi = value;});
        // element.carikart yerine giden depo konulabilir mantık tam kavranmadı sor!.
      });
      list_Depo.assignAll(tt);
    }); //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }

  Future<List<Sayim>> getfis() async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLSAYIMSB", where: 'DURUM = ?', whereArgs: [0]);
    List<Sayim> tt1 =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return tt1;
  }

  Future<void> listGidecekDepoGetir() async {
    List<Sayim> tt = await getGidecekfis();
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<SayimHareket> tahHar = await getSayimHar(element.ID!);
      element.sayimStokListesi = tahHar;
      //üstteki elemen.carş nin aynısı silindi
    }
    list_gidecek_Depo.addAll(tt);

    //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }

  Future<List<Sayim>> getGidecekfis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLSAYIMSB",
        where: 'AKTARILDIMI = ? AND DURUM = ?', whereArgs: [false, true]);
    List<Sayim> tt1 =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return tt1;
  }

  Future<int> getSayimSayisi() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLSAYIMSB",
      columns: ["ID"],
      where: 'DURUM = ?',
      whereArgs: [false],
    );
    return result.length;
  }

  Future<void> listGidecekTekDepoGetir({required int sayimID}) async {
    List<Sayim> tt = await getGidecekTekfis(sayimID);
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<SayimHareket> tahHar = await getSayimHar(element.ID!);
      element.sayimStokListesi = tahHar;
      //üstteki elemen.carş nin aynısı silindi
    }
    list_gidecek_Depo.addAll(tt);

    //List.generate(result.length, (i) => Fis.fromJson(result[i]));
  }

  Future<List<Sayim>> getGidecekTekfis(int sayimID) async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLSAYIMSB", where: 'ID = ?', whereArgs: [sayimID]);
    List<Sayim> tt1 =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return tt1;
  }

  Future<List<SayimHareket>> fisHareketGetir({
    required int DepoId,
    required String belgeTip,
  }) async {
    //  List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISHAR",where: 'FIS_ID = ? ', whereArgs:[fisId, ]);
    List<SayimHareket> tt1 = [];
    getSayimHar(DepoId).then((value) {
      tt1 = value;
    });
    return tt1;
//     List<FisHareket> tt1 =  List.generate(result.length, (i) => FisHareket.fromJson(result[i]));
  }

  Future<List<SayimHareket>> getSayimHar(int sayimID) async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLSAYIMHAR", where: 'SAYIMID = ? ', whereArgs: [sayimID]);
    List<SayimHareket> tt1 =
        List.generate(result.length, (i) => SayimHareket.fromJson(result[i]));
    return tt1;
  }

  Future<RxList<Sayim>> listGidenFisleriGetir() async {
    List<Sayim> tt = await getGidenFis();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<SayimHareket> fisHarList = await getSayimHar(element.ID!);
      element.sayimStokListesi = fisHarList;
    });

    list_fis_giden.assignAll(tt);
    return list_fis_giden;
  }

  Future<List<Sayim>> getGidenFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLSAYIMSB",
        where: 'AKTARILDIMI = ?',
        whereArgs: [true],
        limit: 50,
        orderBy: 'ID DESC');
    List<Sayim> gidenFis =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Sayim>> listTarihliGidenFisleriGetir(
      String basTar, String bitTar) async {
    List<Sayim> tt = await getTarihliGidenFis(basTar, bitTar);

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<SayimHareket> fisHarList = await getSayimHar(element.ID!);
      element.sayimStokListesi = fisHarList;
    });

    list_fis_giden_tarihli.assignAll(tt);
    return list_fis_giden_tarihli;
  }

  Future<List<Sayim>> getTarihliGidenFis(String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLSAYIMSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ?',
        whereArgs: [true, basTar, bitTar],
        orderBy: 'ID DESC');
    List<Sayim> gidenFis =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Sayim>> listKaydedilenFisleriGetir() async {
    List<Sayim> tt = await getKaydedilenFis();
    await Future.forEach(tt, (element) async {
      List<SayimHareket> fisHarList = await getSayimHar(element.ID!);
      element.sayimStokListesi = fisHarList;
    });

    list_fis_kaydedilen.assignAll(tt);
    return list_fis_kaydedilen;
  }

  Future<List<Sayim>> getKaydedilenFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLSAYIMSB",
        where: 'AKTARILDIMI = ? AND DURUM = ?',
        whereArgs: [false, true],
        limit: 50,
        orderBy: 'ID DESC');
    List<Sayim> gidenFis =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Sayim>> listTarihliKaydedilenFisleriGetir(
      String basTar, String bitTar) async {
    List<Sayim> tt = await getTarihliKaydedilenFis(basTar, bitTar);

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<SayimHareket> fisHarList = await getSayimHar(element.ID!);
      element.sayimStokListesi = fisHarList;
    });

    list_fis_kaydedilen_tarihli.assignAll(tt);
    return list_fis_kaydedilen_tarihli;
  }

  Future<List<Sayim>> getTarihliKaydedilenFis(
      String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLSAYIMSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ? AND DURUM = ?',
        whereArgs: [false, basTar, bitTar, true],
        orderBy: 'ID DESC');
    List<Sayim> gidenFis =
        List.generate(result.length, (i) => Sayim.fromJson(result[i]));
    return gidenFis;
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
