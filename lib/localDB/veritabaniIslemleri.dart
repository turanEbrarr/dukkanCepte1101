import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/Depo%20Transfer/subeDepoModel.dart';
import 'package:dukkan_cepte/controllers/cariController.dart';
import 'package:dukkan_cepte/faturaFis/fisEkParam.dart';
import 'package:dukkan_cepte/stok_kart/stokDepoMode.dart';
import 'package:dukkan_cepte/webservis/kurModel.dart';

import 'package:dukkan_cepte/widget/cari.dart';
import 'package:dukkan_cepte/widget/cariAltHesap.dart';

import 'package:dukkan_cepte/widget/modeller/olcuBirimModel.dart';
import 'package:dukkan_cepte/widget/modeller/ondalikModel.dart';

import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../controllers/stokKartController.dart';
import '../stok_kart/stok_tanim.dart';
import '../webservis/bankaModel.dart';
import '../webservis/bankaSozlesmeModel.dart';
import '../widget/ctanim.dart';
import '../webservis/base.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/rafModel.dart';


CariController cariEx = Get.find(); // PUT DEĞİŞTİ
final StokKartController stokKartEx = Get.find();

class VeriIslemleri {
  //database stokları getir

  Future<List<StokKart>?> stokGetir() async {
    var result = await Ctanim.db?.query("TBLSTOKSB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKSB");
    listeler.liststok =
        List.generate(maps.length, (i) => StokKart.fromJson(maps[i]));
    stokKartEx.searchList.assignAll(listeler.liststok);
    return listeler.liststok;
  }

  //database stokları güncelle
  Future<int?> stokGuncelle(StokKart stokKart) async {
    var result = await Ctanim.db?.update("TBLSTOKSB", stokKart.toJson(),
        where: 'ID = ?', whereArgs: [stokKart.ID]);
    return result;
  }

  //database stok ekle
  Future<int?> stokEkle(StokKart stokKart, {bool yeniStokMu = false}) async {
    try {
      stokKart.ID = null;
      var result = await Ctanim.db?.insert("TBLSTOKSB", stokKart.toJson());
      if (yeniStokMu == true) {
        listeler.liststok.add(stokKart);
      }
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stokTabloTemizle() async {
    try {
      await Ctanim.db?.delete("TBLSTOKSB");
      print("TBLSTOKSB tablosu temizlendi.");

      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLSTOKSB");

      await Ctanim.db?.execute("""CREATE TABLE TBLSTOKSB (
         ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOD TEXT NOT NULL,
      ADI TEXT NOT NULL,
      SATDOVIZ TEXT,
      ALDOVIZ TEXT ,
      SATIS_KDV DECIMAL ,
      STOKTIP TEXT,
      ALIS_KDV DECIMAL,
      SFIYAT1 DECIMAL ,
      SFIYAT2 DECIMAL ,
      SFIYAT3 DECIMAL ,
      SFIYAT4 DECIMAL ,
      SFIYAT5 DECIMAL ,
      AFIYAT1 DECIMAL ,
      AFIYAT2 DECIMAL ,
      AFIYAT3 DECIMAL ,
      AFIYAT4 DECIMAL ,
      AFIYAT5 DECIMAL ,
      OLCUBIRIM1 TEXT ,
      OLCUBIRIM2 TEXT ,
      BIRIMADET1 TEXT ,
      OLCUBIRIM3 TEXT ,
      BIRIMADET2 TEXT ,
      RAPORKOD1 TEXT ,
      RAPORKOD1ADI TEXT ,
      RAPORKOD2 TEXT ,
      RAPORKOD2ADI TEXT ,
      RAPORKOD3 TEXT ,
      RAPORKOD3ADI TEXT ,
      RAPORKOD4 TEXT ,
      RAPORKOD4ADI TEXT ,
      RAPORKOD5 TEXT ,
      RAPORKOD5ADI TEXT ,
      RAPORKOD6 TEXT ,
      RAPORKOD6ADI TEXT ,
      RAPORKOD7 TEXT ,
      RAPORKOD7ADI TEXT ,
      RAPORKOD8 TEXT ,
      RAPORKOD8ADI TEXT ,
      RAPORKOD9 TEXT ,
      RAPORKOD9ADI TEXT ,
      RAPORKOD10 TEXT ,
      RAPORKOD10ADI TEXT ,
      URETICI_KODU TEXT ,
      URETICIBARKOD TEXT ,
      RAF TEXT ,
      GRUP_KODU TEXT ,
      GRUP_ADI TEXT ,
      ACIKLAMA TEXT ,
      ACIKLAMA1 TEXT ,
      ACIKLAMA2 TEXT ,
      ACIKLAMA3 TEXT ,
      ACIKLAMA4 TEXT ,
      ACIKLAMA5 TEXT ,
      ACIKLAMA6 TEXT ,
      ACIKLAMA7 TEXT ,
      ACIKLAMA8 TEXT ,
      ACIKLAMA9 TEXT ,
      ACIKLAMA10 TEXT ,
      SACIKLAMA1 TEXT ,
      SACIKLAMA2 TEXT ,
      SACIKLAMA3 TEXT ,
      SACIKLAMA4 TEXT ,
      SACIKLAMA5 TEXT ,
      SACIKLAMA6 TEXT ,
      SACIKLAMA7 TEXT ,
      SACIKLAMA8 TEXT ,
      SACIKLAMA9 TEXT ,
      SACIKLAMA10 TEXT ,
      KOSULGRUP_KODU TEXT ,
      KOSULALISGRUP_KODU TEXT ,
      MARKA TEXT ,
      AKTIF TEXT ,
      TIP TEXT ,
      B2CFIYAT DECIMAL ,
      B2CDOVIZ TEXT ,
      BARKOD1 TEXT ,
      BARKOD2 TEXT ,
      BARKOD3 TEXT ,
      BARKOD4 TEXT ,
      BARKOD5 TEXT ,
      BARKOD6 TEXT ,
      BARKODCARPAN1 DECIMAL ,
      BARKODCARPAN2 DECIMAL ,
      BARKODCARPAN3 DECIMAL ,
      BARKODCARPAN4 DECIMAL ,
      BARKODCARPAN5 DECIMAL ,
      BARKODCARPAN6 DECIMAL ,
      BARKOD1BIRIMADI TEXT ,
      BARKOD2BIRIMADI TEXT ,
      BARKOD3BIRIMADI TEXT ,
      BARKOD4BIRIMADI TEXT ,
      BARKOD5BIRIMADI TEXT ,
      BARKOD6BIRIMADI TEXT ,
      DAHAFAZLABARKOD TEXT ,
      BIRIM_AGIRLIK DECIMAL ,
      EN DECIMAL ,
      BOY DECIMAL ,
      YUKSEKLIK DECIMAL ,
      SATISISK DECIMAL ,
      ALISISK DECIMAL ,
      B2BFIYAT DECIMAL ,
      B2BDOVIZ TEXT ,
      LISTEFIYAT DECIMAL ,
      OLCUBR1 INTEGER,
      OLCUBR2 INTEGER,
      OLCUBR3 INTEGER,
      OLCUBR4 INTEGER,
      OLCUBR5 INTEGER,
      OLCUBR6 INTEGER,
      BARKODFIYAT1 DECIMAL,
      BARKODFIYAT2 DECIMAL,
      BARKODFIYAT3 DECIMAL,
      BARKODFIYAT4 DECIMAL,
      BARKODFIYAT5 DECIMAL,
      BARKODFIYAT6 DECIMAL,
      BARKODISK1 DECIMAL,
      BARKODISK2 DECIMAL,
      BARKODISK3 DECIMAL,
      BARKODISK4 DECIMAL,
      BARKODISK5 DECIMAL,
      BARKODISK6 DECIMAL,
      BAKIYE DECIMAL,
      LISTEDOVIZ TEXT 
      )""");

      print("TBLCARISB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

////database cari getir
  Future<List<Cari>?> cariGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLCARISB");
    listeler.listCari =
        List.generate(maps.length, (i) => Cari.fromJson(maps[i]));
    cariEx.searchCariList.assignAll(listeler.listCari);

    await cariAltHesapGetir();

    return listeler.listCari;
  }

  //database carileri güncelle
  Future<int?> cariGuncelle(Cari cariKart) async {
    var result = await Ctanim.db?.update("TBLCARISB", cariKart.toJson(),
        where: 'ID = ?', whereArgs: [cariKart.ID]);
    return result;
  }

  //database cari ekle
  Future<int?> cariEkle(Cari cariKart) async {
    try {
      cariKart.ID = null;
      var result = await Ctanim.db?.insert("TBLCARISB", cariKart.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> cariTabloTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLCARISB");
      print("TBLCARISB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLCARISB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLCARISB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOSULID INTEGER ,
      KOD TEXT NOT NULL,
      ADI TEXT NOT NULL,
      ILCE TEXT,
      IL TEXT ,
      ADRES TEXT ,
      VERGIDAIRESI TEXT,
      VERGINO TEXT ,
      KIMLIKNO TEXT ,
      TIPI TEXT ,
      TELEFON TEXT ,
      FAX TEXT ,
      FIYAT INTEGER ,
      ULKEID INTEGER ,
      EMAIL TEXT ,
      WEB TEXT ,
      PLASIYERID INTEGER ,
      ISKONTO DECIMAL ,
      EFATURAMI TEXT ,
      VADEGUNU TEXT ,
      BAKIYE DECIMAL 
      )""");

      print("TBLCARISB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> cariAltHesapTabloTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLCARIALTHESAPSB");
      print("TBLCARIALTHESAPSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLCARIALTHESAPSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute(""" CREATE TABLE TBLCARIALTHESAPSB (
      KOD TEXT ,
      ALTHESAP TEXT,
      DOVIZID INTEGER,
      VARSAYILAN TEXT
    )""");

      print("TBLCARIALTHESAPSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<List<CariAltHesap>?> cariAltHesapGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLCARIALTHESAPSB");

    listeler.listCariAltHesap =
        List.generate(maps.length, (i) => CariAltHesap.fromJson(maps[i]));

    for (int i = 0; i < listeler.listCari.length; i++) {
      for (var element2 in listeler.listCariAltHesap) {
        if (listeler.listCari[i].KOD == element2.KOD) {
          listeler.listCari[i].cariAltHesaplar.add(element2);
        }
      }
    }
    cariEx.searchCariList.assignAll(listeler.listCari);

    return listeler.listCariAltHesap;
  }

  //database carileri güncelle
  Future<int?> cariAltHesapGuncelle(CariAltHesap cariAltHesap) async {
    var result = await Ctanim.db?.update(
        "TBLCARIALTHESAPSB", cariAltHesap.toJson(),
        where: 'KOD = ?', whereArgs: [cariAltHesap.KOD]);
    return result;
  }

  //database cari ekle
  Future<int?> cariAltHesapEkle(CariAltHesap cariAltHesap) async {
    try {
      // cariAltHesap.KOD = null;
      var result =
          await Ctanim.db?.insert("TBLCARIALTHESAPSB", cariAltHesap.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<SubeDepoModel>?> subeDepoGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSUBEDEPOSB");
    listeler.listSubeDepoModel =
        List.generate(maps.length, (i) => SubeDepoModel.fromJson(maps[i]));

    return listeler.listSubeDepoModel;
  }

  //database carileri güncelle
  Future<int?> subeDepoGuncelle(SubeDepoModel subeDepoModel) async {
    var result = await Ctanim.db?.update(
        "TBLSUBEDEPOSB", subeDepoModel.toJson(), where: 'ID = ?', whereArgs: [
      subeDepoModel.ID
    ]); // ıd'ye göre mi güncelleme yapılacak ?????????????
    return result;
  }

  //database cari ekle
  Future<int?> subeDepoEkle(SubeDepoModel subeDepoModel) async {
    try {
      subeDepoModel.ID = null;
      var result =
          await Ctanim.db?.insert("TBLSUBEDEPOSB", subeDepoModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }


  /*Future<List<Cari>?> fisGetir() async {
    Database? db = await databaseHelper.database;
    var result = await db?.query("TBLFISSB");
    listeler.listCari = result!.map((e) => f.fromJson(e)).toList();
    cariEx.searchCariList.assignAll(listeler.listCari);
    return listeler.listCari;
  }
*/

  Future<int?> kurEkle(KurModel kurModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLKURSB", kurModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> kurTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLKURSB');
    }
  }

  Future<void> kurGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listKur.clear();
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLKURSB");
    listeler.listKur =
        List.generate(maps.length, (i) => KurModel.fromJson(maps[i]));
    print(listeler.listKur);
  }

  Future<int?> logKayitEkle(LogModel logModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLLOGSB", logModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<LogModel>?> logKayitGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLLOGSB");
    listeler.listLog =
        List.generate(maps.length, (i) => LogModel.fromJson(maps[i]));

    return listeler.listLog;
  }

  Future<List<OlcuBirimModel>?> olcuBirimGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLOLCUBIRIMSB");
    listeler.listOlcuBirim =
        List.generate(maps.length, (i) => OlcuBirimModel.fromJson(maps[i]));

    return listeler.listOlcuBirim;
  }

  //database carileri güncelle

  //database cari ekle
  Future<int?> olcuBirimEkle(OlcuBirimModel olcuBirimModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLOLCUBIRIMSB", olcuBirimModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> olcuBirimTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLOLCUBIRIMSB");
      print("TBLOLCUBIRIMSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLOLCUBIRIMSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLOLCUBIRIMSB (
     ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ACIKLAMA TEXT
      )""");

      print("TBLOLCUBIRIMSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> deleteAllImages() async {
    final db = await Ctanim?.db;
    await db?.execute('DELETE FROM images');
  }

  Future<int> insertImage(String imagePath) async {
    await deleteAllImages();
    return await Ctanim?.db.insert(
      'images',
      {'image_path': imagePath},
    );
  }

  Future<String?> getFirstImage() async {
    final List<Map<String, dynamic>> maps =
        await Ctanim.db.query('images', limit: 1);
    if (maps.isNotEmpty) {
      return maps.first['image_path'] as String;
    } else {
      return "";
    }
  }

  Future<int?> rafEkle(RafModel rafModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLRAFSB", rafModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<RafModel>> rafGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLRAFSB");
    listeler.listRaf =
        List.generate(maps.length, (i) => RafModel.fromJson(maps[i]));

    return listeler.listRaf;
  }

  Future<void> rafTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLRAFSB");
      print("TBLRAFSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLRAFSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLRAFSB (
     ID INTEGER PRIMARY KEY AUTOINCREMENT,
      RAF TEXT
      )""");

      print("TBLRAFSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }





  Future<int?> plasiyerBankaEkle(BankaModel bankaModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLPLASIYERBANKASB", bankaModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> plasiyerBankaTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLPLASIYERBANKASB');
    }
  }

  Future<void> plasiyerBankaGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listBankaModel.clear();
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLPLASIYERBANKASB");
    listeler.listBankaModel =
        List.generate(maps.length, (i) => BankaModel.fromJson(maps[i]));
    print(listeler.listBankaModel);
  }

  Future<int?> plasiyerBankaSozlesmeEkle(
      BankaSozlesmeModel bankaSozlesmeModel) async {
    try {
      var result = await Ctanim.db
          ?.insert("TBLPLASIYERBANKASOZLESMESB", bankaSozlesmeModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> plasiyerBankaSozlesmeTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLPLASIYERBANKASOZLESMESB');
    }
  }

  Future<void> plasiyerBankaSozlesmeGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listBankaSozlesmeModel.clear();
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLPLASIYERBANKASOZLESMESB");
    listeler.listBankaSozlesmeModel =
        List.generate(maps.length, (i) => BankaSozlesmeModel.fromJson(maps[i]));
    print(listeler.listBankaSozlesmeModel);
  }



  Future<void> islemTipiTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLSATISTIPSB');
    }
  }




  Future<void> stokFiyatListesiTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLSTOKFIYATLISTESISB');
    }
  }






  Future<void> ondalikGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLONDALIKSB");
    if (maps.length > 0) {
      Ctanim.ondalikModel = OndalikModel.fromJson(maps[0]);
    }
  }

  //database cari ekle
  Future<int?> ondalikEkle(OndalikModel ondalikModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLONDALIKSB", ondalikModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> ondalikTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLONDALIKSB");
      print("TBLONDALIKSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLONDALIKSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLONDALIKSB (
      SUBEID INTEGER,
      FIYAT INTEGER,
      MIKTAR INTEGER,
      KUR INTEGER,
      DOVFIYAT INTEGER,
      TUTAR INTEGER,
      DOVTUTAR INTEGER,
      ALISFIYAT INTEGER,
      ALISMIKTAR INTEGER,
      ALISKUR INTEGER,
      ALISDOVFIYAT INTEGER,
      ALISTUTAR INTEGER,
      ALISDOVTUTAR INTEGER,
      PERFIYAT INTEGER,
      PERMIKTAR INTEGER,
      PERKUR INTEGER,
      PERDOVFIYAT INTEGER,
      PERTUTAR INTEGER,
      PERDOVTUTAR INTEGER
    )""");

      print("TBLONDALIKSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }


  Future<void> stokDepoGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKDEPOSB");
    if (maps.length > 0) {
      listeler.listStokDepo =
          List.generate(maps.length, (i) => StokDepoModel.fromJson(maps[i]));
    }
  }

  //database cari ekle
  Future<int?> stokDepoEkle(StokDepoModel stokDepoModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLSTOKDEPOSB", stokDepoModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stokDepoTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLSTOKDEPOSB");
      print("TBLSTOKDEPOSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLSTOKDEPOSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""  CREATE TABLE TBLSTOKDEPOSB (
      KOD TEXT,
      DEPOADI TEXT,
      BAKIYE DECIMAL
    )""");

      print("TBLSTOKDEPOSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> fisEkParamGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query(
      "TBLFISEKPARAM",
      where: "FISID IS NULL OR FISID = 0 OR FISID = ''",
    );
    if (maps.length > 0) {

      listeler.listFisEkParam =
          List.generate(maps.length, (i) => FisEkParam.fromJson(maps[i]));
          for (var element in listeler.listFisEkParam) {
            if(element.ZORUNLU == "True" && (element.FISID == 0 || element.DEGER==null)){
              listeler.listFisEkParamZorunluID.add(element.ID!);
            }
          }
    }
  }
 

  //database cari ekle
  Future<int?> fisEkParamEkle(FisEkParam fisEkParam) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLFISEKPARAM", fisEkParam.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }
  /*
      await Ctanim.db
        ?.delete("TBLFISEKPARAM", where: "FISID = ?", whereArgs: [fisId]);
  */
  Future<void> fiseAitEkParamTemizle(int fisID) async {
        try {
      await Ctanim.db
        ?.delete("TBLFISEKPARAM", where: "FISID = ?", whereArgs: [fisID]);
   
    } on PlatformException catch (e) {
      print(e);
    }


  }

  Future<void> fisEkParamTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLFISEKPARAM");
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLFISEKPARAM");
      await Ctanim.db?.execute("""CREATE TABLE TBLFISEKPARAM(
      FISID INTEGER,
      ID INTEGER,
      DEGER TEXT,
      ACIKLAMA TEXT,
      TIP INTEGER,
      ZORUNLU TEXT,
      VERITIP TEXT 
    )""");

      print("TBLFISEKPARAM tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<int> veriGetir() async {
    await stokGetir(); // BUNLAR AŞAĞIDA DEĞİŞRİ TEMOE BAKILIYODU ARTK BÖYLE BAKIILIRO
    await cariGetir();
    await subeDepoGetir();
    await fisEkParamGetir();
    await ondalikGetir();

    await plasiyerBankaGetir();
    await plasiyerBankaSozlesmeGetir();
  
    await rafGetir();
    await olcuBirimGetir();
    await kurGetir();
    await stokDepoGetir();
    /*

    List<StokKart>? temp1 = await stokGetir();
    List<Cari>? temp2 = await cariGetir();
    List<SubeDepoModel>? temp3 = await subeDepoGetir();
    */
    if (listeler.liststok.length > 0 || listeler.listCari.length> 0 || listeler.listSubeDepoModel!.length > 0) {
      return 1;
    } else {
      return 0;
    }
  }
}
