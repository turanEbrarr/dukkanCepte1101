import 'package:flutter/services.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

BaseService bs = BaseService();

class DatabaseHelper {
  DatabaseHelper(String databaseName) {
    _databaseName = "";
    _databaseName = databaseName;
  }
  static String? _databaseName;
  static final _databaseVersion = 10;

  static Database? _database;

  Future<Database?> database() async {
    if (_database == null) {
      _database = await _initDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    var ourDb = await openDatabase(path,
        version: _databaseVersion,
        onCreate: tabloOlustur,
        onUpgrade: _onUpgrade);
    return ourDb;
  }

  static Future<void> deleteDatabase() async {
    Ctanim.db = null;
    DatabaseHelper._database = null;
    return databaseFactory
        .deleteDatabase(join(await getDatabasesPath(), _databaseName));
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print(oldVersion);
    print(newVersion);
    for (int i = 0; i <= newVersion; i++) {
      if(i==9){
         

      }
      if (i == 8) {
        String sorgu = """
    CREATE TABLE IF NOT EXISTS TBLSTOKDEPOSB (
      KOD TEXT,
      DEPOADI TEXT,
      BAKIYE DECIMAL
    )""";
        db.execute(sorgu);
      db.execute("""CREATE TABLE IF NOT EXISTS TBLFISEKPARAM(
      FISID INTEGER,  
      ID INTEGER,
      DEGER TEXT,
      ACIKLAMA TEXT,
      TIP INTEGER,
      ZORUNLU TEXT,
      VERITIP TEXT 
    )""");
      }
      if (i == 7) {
        db.execute("ALTER TABLE TBLTAHSILATHAR ADD COLUMN ALTHESAP TEXT");
      db.execute("""CREATE TABLE IF NOT EXISTS TBLONDALIKSB (
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
      }
      if (i == 8) {
        print("88888");
      }
    }
    if (oldVersion < newVersion) {
      //    db.execute("ALTER TABLE TBLCARIALTHESAPSB ADD COLUMN  INTEGER;");

      if (newVersion == 7) {
    
      }
      // db.execute("ALTER TABLE tabEmployee ADD COLUMN newCol TEXT;");
    }
  }

  Future<void> tabloOlustur(Database db, int version) async {
    try {
      String Sorgu = """
    CREATE TABLE TBLSTOKSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOD TEXT NOT NULL,
      ADI TEXT NOT NULL,
      STOKTIP TEXT,
      SATDOVIZ TEXT,
      ALDOVIZ TEXT ,
      SATIS_KDV DECIMAL ,
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
      LISTEDOVIZ TEXT )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }

    try {
      String Sorgu = """
    CREATE TABLE TBLCARISB (
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
      )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }

    try {
      String Sorgu = """
    CREATE TABLE TBLTAHSILATSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      TIP INTEGER,
      ISLEMTIPI TEXT,
      UUID TEXT,
      SUBEID INTEGER,
      CARIKOD TEXT ,
      CARIADI TEXT,
      GENELTOPLAM DECIMAL,
      PLASIYERKOD TEXT,
      TARIH DATETIME ,
      BELGENO TEXT,
      DURUM BOOLEAN,
      AKTARILDIMI BOOLEAN
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }

    try {
      String Sorgu = """
    CREATE TABLE TBLTAHSILATHAR (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      TAHSILATID TEXT NOT NULL,
      UUID TEXT NOT NULL,
      TIP INTEGER,
      KASAKOD TEXT,
      KUR DECIMAL,
      ALTHESAP TEXT,
      DOVIZID INTEGER,
      TUTAR DECIMAL,
      TAKSIT INTEGER,
      DOVIZ TEXT,
      CEKSERINO TEXT ,
      YERI TEXT,
      VADETARIHI TEXT,
      ASIL TEXT ,
      ACIKLAMA TEXT,
      BELGENO TEXT,
      SOZLESMEID INTEGER,
      AKTARILDIMI BOOLEAN
     )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLFISSB (
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	  UUID TEXT ,
	  ISLEMTIPI TEXT,
    EFATURAMI TEXT,
    EARSIVMI TEXT,
    TIP INTEGER,
    SUBEID INTEGER,
    DEPOID INTEGER,
    GIDENDEPOID INTEGER,
    GIDENSUBEID INTEGER,
	  PLASIYERKOD  TEXT ,
    CARIKOD TEXT ,
    CARIADI TEXT,
	  ALTHESAPID INTEGER,
    ALTHESAP TEXT,
    BELGENO TEXT,
	  FATURANO TEXT,
    SERINO TEXT ,
    TARIH DATETIME ,
    ACIKLAMA1 TEXT ,
    ACIKLAMA2 TEXT ,
    ACIKLAMA3 TEXT ,
    ACIKLAMA4 TEXT ,
    ACIKLAMA5 TEXT ,
    VADEGUNU TEXT ,
    VADETARIHI DATETIME ,
	  TESLIMTARIHI DATETIME,
    SAAT TEXT,
    KDVDAHIL TEXT ,    
    DOVIZ TEXT ,
	  DOVIZID INTEGER,
    KUR DECIMAL,
    ISK1 DECIMAL,
    ISK2 DECIMAL,
    TOPLAM DECIMAL,
    INDIRIM_TOPLAMI DECIMAL, 
    ARA_TOPLAM DECIMAL,
    KDVTUTARI DECIMAL,
    GENELTOPLAM DECIMAL,
	  ONAY TEXT,
    DURUM BOOLEAN,
    AKTARILDIMI BOOLEAN
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }

    try {
      String Sorgu = """
    CREATE TABLE TBLFISHAR (
    ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    FIS_ID INTEGER,
    UUID TEXT,
    MIKTAR INTEGER,
    BRUTFIYAT DECIMAL,
    ISKONTO DECIMAL,
    KDVDAHILNETFIYAT DECIMAL,
    KDVORANI DECIMAL,
	  KDVTUTAR DECIMAL,     
    ISK DECIMAL,
	  ISK2 DECIMAL,
    NETFIYAT DECIMAL ,
    BRUTTOPLAMFIYAT DECIMAL,
    NETTOPLAM DECIMAL,
    ISKONTOTOPLAM DECIMAL,
    KDVDAHILNETTOPLAM DECIMAL,
    KDVTOPLAM DECIMAL,
    STOKKOD TEXT,
    STOKADI TEXT,
	  BIRIM TEXT,
	  BIRIMID INTEGER,
	  DOVIZADI TEXT,
	  DOVIZID INTEGER,
	  KUR DECIMAL, 
	  ACIKLAMA1 TEXT,
	  TARIH DATETIME
          )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLCARIALTHESAPSB (
      KOD TEXT ,
      ALTHESAP TEXT,
      DOVIZID INTEGER,
      VARSAYILAN TEXT
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }

    //
    try {
      String Sorgu = """
      CREATE TABLE TBLSAYIMSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      TARIH DATETIME,
      SUBEID INTEGER ,
      DEPOID INTEGER ,
      PLASIYERKOD TEXT,
      ACIKLAMA TEXT,
      DURUM BOOLEAN ,
      ONAY TEXT,
      AKTARILDIMI BOOLEAN,
      UUID TEXT
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLSAYIMHAR (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      SAYIMID INTEGER ,
      STOKKOD TEXT ,
      STOKADI TEXT ,
      BIRIM TEXT ,
      BIRIMID INTEGER,
      MIKTAR INTEGER ,
      ACIKLAMA TEXT,
      RAF TEXT,
      UUID TEXT 
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLSUBEDEPOSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      SUBEID INTEGER ,
      DEPOID INTEGER ,
      SUBEADI TEXT,
      DEPOADI TEXT
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLSTOKKOSULSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOSULID INTEGER,
      GRUPKODU TEXT,
      FIYAT DECIMAL,
      ISK1 DECIMAL,
      ISK2 DECIMAL,
      ISK3 DECIMAL,
      ISK4 DECIMAL,
      ISK5 DECIMAL,
      ISK6 DECIMAL,
      SABITFIYAT DECIMAL
      )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLCARIKOSULSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      CARIKOD TEXT,
      GRUPKODU TEXT,
      FIYAT DECIMAL,
      ISK1 DECIMAL,
      ISK2 DECIMAL,
      ISK3 DECIMAL,
      ISK4 DECIMAL,
      ISK5 DECIMAL,
      ISK6 DECIMAL,
      SABITFIYAT DECIMAL
      )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLCARISTOKKOSULSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      STOKKOD TEXT,
      CARIKOD TEXT,
      FIYAT DECIMAL,
      ISK1 DECIMAL,
      ISK2 DECIMAL,
      SABITFIYAT DECIMAL
      )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLKURSB (
    ID INTEGER ,
	  ACIKLAMA TEXT ,
	  KUR DECIMAL,
    ANABIRIM TEXT

    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLLOGSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      FISID INTEGER,
      TABLOADI TEXT,
      UUID TEXT,
      CARIADI TEXT,
      HATAACIKLAMA TEXT
      
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLOLCUBIRIMSB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ACIKLAMA TEXT
      
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL
      
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE TBLRAFSB (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        RAF TEXT
      
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE  TBLDAHAFAZLABARKODSB (
      KOD TEXT,
      BARKOD TEXT,
      ACIKLAMA TEXT,
      CARPAN DECIMAL,
      SIRA INTEGER,
      REZERVMIKTAR DECIMAL
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE  TBLPLASIYERBANKASB (
      ID INTEGER,
      BANKAKODU TEXT,
      BANKAADI TEXT
     
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE  TBLPLASIYERBANKASOZLESMESB (
      ID INTEGER,
      BANKAID INTEGER,
      ADI TEXT,
      TIP INTEGER
     
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE  TBLSATISTIPSB (
      ID INTEGER,
      TIP TEXT,
      FIYATTIP TEXT,
      ISK1 TEXT,
      ISK2 TEXT   
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }

    //
    try {
      String Sorgu = """
    CREATE TABLE  TBLSTOKFIYATLISTESISB (
      ID INTEGER,
      ADI TEXT  
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String Sorgu = """
    CREATE TABLE  TBLSTOKFIYATLISTESIHARSB (
      USTID INTEGER,
      STOKKOD TEXT,
      DOVIZID INTEGER,
      FIYAT DECIMAL,
      ISK1 DECIMAL,
      KDV_DAHIL TEXT   
    )""";
      await db.execute(Sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      String sorgu = """
    CREATE TABLE TBLONDALIKSB (
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
    )""";
      await db.execute(sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
   
    try {
      String sorgu = """
    CREATE TABLE TBLSTOKDEPOSB (
      KOD TEXT,
      DEPOADI TEXT,
      BAKIYE DECIMAL
    )""";
      await db.execute(sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
    
      try {
      String sorgu = """
    CREATE TABLE TBLFISEKPARAM(
      FISID INTEGER,  
      ID INTEGER,
      DEGER TEXT,
      ACIKLAMA TEXT,
      TIP INTEGER,
      ZORUNLU TEXT,
      VERITIP TEXT 
    )""";
      await db.execute(sorgu);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future initDatabase() async {
    return _initDatabase();
  }
}


/*
ID INTEGER PRIMARY KEY AUTOINCREMENT,
      FISID INTEGER --,
      STOKKOD TEXT,
      STOKADI TEXT,
      KDVORANI DECIMAL,
	  [KDVTUTAR] [decimal](18, 4) NULL,
      MIKTAR INTEGER,
      FIYAT DECIMAL,
      ISK DECIMAL,
	  [ISK2] [decimal](18, 4) NULL,
      NETFIYAT DECIMAL ,
      BRUTFIYAT DECIMAL ---,
	  [BIRIM] [varchar](50) NULL,
	  [BIRIMID] [int] NULL,
	  [DOVIZADI] [varchar](50) NULL,
	  [DOVIZID] [int] NULL,
	  [KUR] [decimal](18, 4) NULL, 
	  [ACIKLAMA1] [varchar](150) NULL,
	  [TARIH] [datetime] NULL,
*/