/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

class guncelDeger {
  double? fiyat = 0.0;
  double? iskonto = 0.0;
  double? netfiyat = 0.0;
  String? seciliFiyati = "";
  String? guncelBarkod = "";
  bool? fiyatDegistirMi = true;
  double? carpan = 1.0;

  guncelDeger(
      [this.fiyat = 0.0,
      this.iskonto = 0.0,
      this.netfiyat = 0.0,
      this.seciliFiyati = "",
      this.guncelBarkod = "",
      this.fiyatDegistirMi = false,
      this.carpan = 0.0]);
double hesaplaNetFiyat() {
    double _iskonto =  double.parse((fiyat! * (iskonto! / 100)).toStringAsFixed(2));
    return netfiyat =double.parse((fiyat! -_iskonto).toStringAsFixed(2));
        //double.parse((fiyat! * ((1 - (iskonto! / 100)))).toStringAsFixed(2));
  }
}

class StokKart {
  int? ID;
  bool etiketIcin = false;
  String? KOD;
  String? ADI;
  String? SATDOVIZ;
  String? STOKTIP;
  String? ALDOVIZ;
  double? SATIS_KDV;
  double? ALIS_KDV;
  double? SFIYAT1;
  double? SFIYAT2;
  double? SFIYAT3;
  double? SFIYAT4;
  double? SFIYAT5;
  double? AFIYAT1;
  double? AFIYAT2;
  double? AFIYAT3;
  double? AFIYAT4;
  double? AFIYAT5;
  String? OLCUBIRIM1;
  String? OLCUBIRIM2;
  String? BIRIMADET1;
  String? OLCUBIRIM3;
  String? BIRIMADET2;
  String? RAPORKOD1;
  String? RAPORKOD1ADI;
  String? RAPORKOD2;
  String? RAPORKOD2ADI;
  String? RAPORKOD3;
  String? RAPORKOD3ADI;
  String? RAPORKOD4;
  String? RAPORKOD4ADI;
  String? RAPORKOD5;
  String? RAPORKOD5ADI;
  String? RAPORKOD6;
  String? RAPORKOD6ADI;
  String? RAPORKOD7;
  String? RAPORKOD7ADI;
  String? RAPORKOD8;
  String? RAPORKOD8ADI;
  String? RAPORKOD9;
  String? RAPORKOD9ADI;
  String? RAPORKOD10;
  String? RAPORKOD10ADI;
  String? URETICI_KODU;
  String? URETICIBARKOD;
  String? RAF;
  String? GRUP_KODU;
  String? GRUP_ADI;
  String? ACIKLAMA;
  String? ACIKLAMA1;
  String? ACIKLAMA2;
  String? ACIKLAMA3;
  String? ACIKLAMA4;
  String? ACIKLAMA5;
  String? ACIKLAMA6;
  String? ACIKLAMA7;
  String? ACIKLAMA8;
  String? ACIKLAMA9;
  String? ACIKLAMA10;
  String? SACIKLAMA1;
  String? SACIKLAMA2;
  String? SACIKLAMA3;
  String? SACIKLAMA4;
  String? SACIKLAMA5;
  String? SACIKLAMA6;
  String? SACIKLAMA7;
  String? SACIKLAMA8;
  String? SACIKLAMA9;
  String? SACIKLAMA10;
  String? KOSULGRUP_KODU;
  String? KOSULALISGRUP_KODU;
  String? MARKA;
  String? AKTIF;
  String? TIP;
  double? B2CFIYAT;
  String? B2CDOVIZ;
  String? BARKOD1;
  String? BARKOD2;
  String? BARKOD3;
  String? BARKOD4;
  String? BARKOD5;
  String? BARKOD6;
  double? BARKODCARPAN1;
  double? BARKODCARPAN2;
  double? BARKODCARPAN3;
  double? BARKODCARPAN4;
  double? BARKODCARPAN5;
  double? BARKODCARPAN6;
  String? BARKOD1BIRIMADI;
  String? BARKOD2BIRIMADI;
  String? BARKOD3BIRIMADI;
  String? BARKOD4BIRIMADI;
  String? BARKOD5BIRIMADI;
  String? BARKOD6BIRIMADI;
  String? DAHAFAZLABARKOD;
  double? BIRIM_AGIRLIK;
  double? EN;
  double? BOY;
  double? YUKSEKLIK;
  double? SATISISK;
  double? ALISISK;
  double? B2BFIYAT;
  String? B2BDOVIZ;
  double? LISTEFIYAT;
  String? LISTEDOVIZ;
  int? OLCUBR1;
  int? OLCUBR2;
  int? OLCUBR3;
  int? OLCUBR4;
  int? OLCUBR5;
  int? OLCUBR6;
  double? BARKODFIYAT1;
  double? BARKODFIYAT2;
  double? BARKODFIYAT3;
  double? BARKODFIYAT4;
  double? BARKODFIYAT5;
  double? BARKODFIYAT6;
  double? BARKODISK1;
  double? BARKODISK2;
  double? BARKODISK3;
  double? BARKODISK4;
  double? BARKODISK5;
  double? BARKODISK6;
  double? BAKIYE;

  guncelDeger? guncelDegerler = guncelDeger();

  StokKart({
    this.ID = 0,
    this.KOD = "",
    this.ADI = "",
    this.SATDOVIZ = "",
    this.ALDOVIZ = "",
    this.STOKTIP = "",
    this.SATIS_KDV = 0.0,
    this.ALIS_KDV = 0.0,
    this.SFIYAT1 = 0.0,
    this.SFIYAT2 = 0.0,
    this.SFIYAT3 = 0.0,
    this.SFIYAT4 = 0.0,
    this.SFIYAT5 = 0.0,
    this.AFIYAT1 = 0.0,
    this.AFIYAT2 = 0.0,
    this.AFIYAT3 = 0.0,
    this.AFIYAT4 = 0.0,
    this.AFIYAT5 = 0.0,
    this.OLCUBIRIM1 = "",
    this.OLCUBIRIM2 = "",
    this.BIRIMADET1 = "0.0",
    this.OLCUBIRIM3 = "",
    this.BIRIMADET2 = "0.0",
    this.RAPORKOD1 = "",
    this.RAPORKOD1ADI = "",
    this.RAPORKOD2 = "",
    this.RAPORKOD2ADI = "",
    this.RAPORKOD3 = "",
    this.RAPORKOD3ADI = "",
    this.RAPORKOD4 = "",
    this.RAPORKOD4ADI = "",
    this.RAPORKOD5 = "",
    this.RAPORKOD5ADI = "",
    this.RAPORKOD6 = "",
    this.RAPORKOD6ADI = "",
    this.RAPORKOD7 = "",
    this.RAPORKOD7ADI = "",
    this.RAPORKOD8 = "",
    this.RAPORKOD8ADI = "",
    this.RAPORKOD9 = "",
    this.RAPORKOD9ADI = "",
    this.RAPORKOD10 = "",
    this.RAPORKOD10ADI = "",
    this.URETICI_KODU = "",
    this.URETICIBARKOD = "",
    this.RAF = "",
    this.GRUP_KODU = "",
    this.GRUP_ADI = "",
    this.ACIKLAMA = "",
    this.ACIKLAMA1 = "",
    this.ACIKLAMA2 = "",
    this.ACIKLAMA3 = "",
    this.ACIKLAMA4 = "",
    this.ACIKLAMA5 = "",
    this.ACIKLAMA6 = "",
    this.ACIKLAMA7 = "",
    this.ACIKLAMA8 = "",
    this.ACIKLAMA9 = "",
    this.ACIKLAMA10 = "",
    this.SACIKLAMA1 = "0.0",
    this.SACIKLAMA2 = "0.0",
    this.SACIKLAMA3 = "0.0",
    this.SACIKLAMA4 = "0.0",
    this.SACIKLAMA5 = "0.0",
    this.SACIKLAMA6 = "0.0",
    this.SACIKLAMA7 = "0.0",
    this.SACIKLAMA8 = "0.0",
    this.SACIKLAMA9 = "0.0",
    this.SACIKLAMA10 = "0.0",
    this.KOSULGRUP_KODU = "",
    this.KOSULALISGRUP_KODU = "",
    this.MARKA = "",
    this.AKTIF = "",
    this.TIP = "",
    this.B2CFIYAT = 0.0,
    this.B2CDOVIZ = "",
    this.BARKOD1 = "",
    this.BARKOD2 = "",
    this.BARKOD3 = "",
    this.BARKOD4 = "",
    this.BARKOD5 = "",
    this.BARKOD6 = "",
    this.BARKODCARPAN1 = 0.0,
    this.BARKODCARPAN2 = 0.0,
    this.BARKODCARPAN3 = 0.0,
    this.BARKODCARPAN4 = 0.0,
    this.BARKODCARPAN5 = 0.0,
    this.BARKODCARPAN6 = 0.0,
    this.BARKOD1BIRIMADI = "",
    this.BARKOD2BIRIMADI = "",
    this.BARKOD3BIRIMADI = "",
    this.BARKOD4BIRIMADI = "",
    this.BARKOD5BIRIMADI = "",
    this.BARKOD6BIRIMADI = "",
    this.DAHAFAZLABARKOD = "",
    this.BIRIM_AGIRLIK = 0.0,
    this.EN = 0.0,
    this.BOY = 0.0,
    this.YUKSEKLIK = 0.0,
    this.SATISISK = 0.0,
    this.ALISISK = 0.0,
    this.B2BFIYAT = 0.0,
    this.B2BDOVIZ = "",
    this.LISTEFIYAT = 0.0,
    this.LISTEDOVIZ = "",
    this.OLCUBR1 = 0,
    this.OLCUBR2 = 0,
    this.OLCUBR3 = 0,
    this.OLCUBR4 = 0,
    this.OLCUBR5 = 0,
    this.OLCUBR6 = 0,
    this.BARKODFIYAT1 = 0.0,
    this.BARKODFIYAT2 = 0.0,
    this.BARKODFIYAT3 = 0.0,
    this.BARKODFIYAT4 = 0.0,
    this.BARKODFIYAT5 = 0.0,
    this.BARKODFIYAT6 = 0.0,
    this.BARKODISK1 = 0.0,
    this.BARKODISK2 = 0.0,
    this.BARKODISK3 = 0.0,
    this.BARKODISK4 = 0.0,
    this.BARKODISK5 = 0.0,
    this.BARKODISK6 = 0.0,
    this.BAKIYE = 0.0,
    this.guncelDegerler,
  });

  StokKart.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    KOD = json['KOD'];
    ADI = json['ADI'];
    SATDOVIZ = json['SATDOVIZ'];
    STOKTIP = json["STOKTIP"];
    ALDOVIZ = json['ALDOVIZ'];
    SATIS_KDV = double.parse(json['SATIS_KDV'].toString());
    ALIS_KDV = double.parse(json['ALIS_KDV'].toString());
    SFIYAT1 = double.parse(json['SFIYAT1'].toString());
    SFIYAT2 = double.parse(json['SFIYAT2'].toString());
    SFIYAT3 = double.parse(json['SFIYAT3'].toString());
    SFIYAT4 = double.parse(json['SFIYAT4'].toString());
    SFIYAT5 = double.parse(json['SFIYAT5'].toString());
    AFIYAT1 = double.parse(json['AFIYAT1'].toString());
    AFIYAT2 = double.parse(json['AFIYAT2'].toString());
    AFIYAT3 = double.parse(json['AFIYAT3'].toString());
    AFIYAT4 = double.parse(json['AFIYAT4'].toString());
    AFIYAT5 = double.parse(json['AFIYAT5'].toString());
    OLCUBIRIM1 = json['OLCUBIRIM1'];
    OLCUBIRIM2 = json['OLCUBIRIM2'];
    BIRIMADET1 = json['BIRIMADET1'];
    OLCUBIRIM3 = json['OLCUBIRIM3'];
    BIRIMADET2 = json['BIRIMADET2'];
    RAPORKOD1 = json['RAPORKOD1'];
    RAPORKOD1ADI = json['RAPORKOD1ADI'];
    RAPORKOD2 = json['RAPORKOD2'];
    RAPORKOD2ADI = json['RAPORKOD2ADI'];
    RAPORKOD3 = json['RAPORKOD3'];
    RAPORKOD3ADI = json['RAPORKOD3ADI'];
    RAPORKOD4 = json['RAPORKOD4'];
    RAPORKOD4ADI = json['RAPORKOD4ADI'];
    RAPORKOD5 = json['RAPORKOD5'];
    RAPORKOD5ADI = json['RAPORKOD5ADI'];
    RAPORKOD6 = json['RAPORKOD6'];
    RAPORKOD6ADI = json['RAPORKOD6ADI'];
    RAPORKOD7 = json['RAPORKOD7'];
    RAPORKOD7ADI = json['RAPORKOD7ADI'];
    RAPORKOD8 = json['RAPORKOD8'];
    RAPORKOD8ADI = json['RAPORKOD8ADI'];
    RAPORKOD9 = json['RAPORKOD9'];
    RAPORKOD9ADI = json['RAPORKOD9ADI'];
    RAPORKOD10 = json['RAPORKOD10'];
    RAPORKOD10ADI = json['RAPORKOD10ADI'];
    URETICI_KODU = json['URETICI_KODU'];
    URETICIBARKOD = json['URETICIBARKOD'];
    RAF = json['RAF'];
    GRUP_KODU = json['GRUP_KODU'];
    GRUP_ADI = json['GRUP_ADI'];
    ACIKLAMA = json['ACIKLAMA'];
    ACIKLAMA1 = json['ACIKLAMA1'];
    ACIKLAMA2 = json['ACIKLAMA2'];
    ACIKLAMA3 = json['ACIKLAMA3'];
    ACIKLAMA4 = json['ACIKLAMA4'];
    ACIKLAMA5 = json['ACIKLAMA5'];
    ACIKLAMA6 = json['ACIKLAMA6'];
    ACIKLAMA7 = json['ACIKLAMA7'];
    ACIKLAMA8 = json['ACIKLAMA8'];
    ACIKLAMA9 = json['ACIKLAMA9'];
    ACIKLAMA10 = json['ACIKLAMA10'];
    SACIKLAMA1 = json['SACIKLAMA1'];
    SACIKLAMA2 = json['SACIKLAMA2'];
    SACIKLAMA3 = json['SACIKLAMA3'];
    SACIKLAMA4 = json['SACIKLAMA4'];
    SACIKLAMA5 = json['SACIKLAMA5'];
    SACIKLAMA6 = json['SACIKLAMA6'];
    SACIKLAMA7 = json['SACIKLAMA7'];
    SACIKLAMA8 = json['SACIKLAMA8'];
    SACIKLAMA9 = json['SACIKLAMA9'];
    SACIKLAMA10 = json['SACIKLAMA10'];
    KOSULGRUP_KODU = json['KOSULGRUP_KODU'];
    KOSULALISGRUP_KODU = json['KOSULALISGRUP_KODU'];
    MARKA = json['MARKA'];
    AKTIF = json['AKTIF'];
    TIP = json['TIP'];
    B2CFIYAT = double.parse(json['B2CFIYAT'].toString());
    B2CDOVIZ = json['B2CDOVIZ'];
    BARKOD1 = json['BARKOD1'];
    BARKOD2 = json['BARKOD2'];
    BARKOD3 = json['BARKOD3'];
    BARKOD4 = json['BARKOD4'];
    BARKOD5 = json['BARKOD5'];
    BARKOD6 = json['BARKOD6'];
    BARKODCARPAN1 = double.parse(json['BARKODCARPAN1'].toString());
    BARKODCARPAN2 = double.parse(json['BARKODCARPAN2'].toString());
    BARKODCARPAN3 = double.parse(json['BARKODCARPAN3'].toString());
    BARKODCARPAN4 = double.parse(json['BARKODCARPAN4'].toString());
    BARKODCARPAN5 = double.parse(json['BARKODCARPAN5'].toString());
    BARKODCARPAN6 = double.parse(json['BARKODCARPAN6'].toString());
    BARKOD1BIRIMADI = json['BARKOD1BIRIMADI'];
    BARKOD2BIRIMADI = json['BARKOD2BIRIMADI'];
    BARKOD3BIRIMADI = json['BARKOD3BIRIMADI'];
    BARKOD4BIRIMADI = json['BARKOD4BIRIMADI'];
    BARKOD5BIRIMADI = json['BARKOD5BIRIMADI'];
    BARKOD6BIRIMADI = json['BARKOD6BIRIMADI'];
    DAHAFAZLABARKOD = json['DAHAFAZLABARKOD'];
    BIRIM_AGIRLIK = double.parse(json['BIRIM_AGIRLIK'].toString());
    EN = double.parse(json['EN'].toString());
    BOY = double.parse(json['BOY'].toString());
    YUKSEKLIK = double.parse(json['YUKSEKLIK'].toString());
    SATISISK = double.parse(json['SATISISK'].toString());
    ALISISK = double.parse(json['ALISISK'].toString());
    B2BFIYAT = double.parse(json['B2BFIYAT'].toString());
    B2BDOVIZ = json['B2BDOVIZ'];
    LISTEFIYAT = double.parse(json['LISTEFIYAT'].toString());
    LISTEDOVIZ = json['LISTEDOVIZ'];

    OLCUBR1 = int.parse(json['OLCUBR1'].toString());
    OLCUBR2 = int.parse(json['OLCUBR2'].toString());
    OLCUBR3 = int.parse(json['OLCUBR3'].toString());
    OLCUBR4 = int.parse(json['OLCUBR4'].toString());
    OLCUBR5 = int.parse(json['OLCUBR5'].toString());
    OLCUBR6 = int.parse(json['OLCUBR6'].toString());
    BARKODFIYAT1 = double.parse(json['BARKODFIYAT1'].toString());
    BARKODFIYAT2 = double.parse(json['BARKODFIYAT2'].toString());
    BARKODFIYAT3 = double.parse(json['BARKODFIYAT3'].toString());
    BARKODFIYAT4 = double.parse(json['BARKODFIYAT4'].toString());
    BARKODFIYAT5 = double.parse(json['BARKODFIYAT5'].toString());
    BARKODFIYAT6 = double.parse(json['BARKODFIYAT6'].toString());

    BARKODISK1 = double.parse(json['BARKODISK1'].toString());
    BARKODISK2 = double.parse(json['BARKODISK2'].toString());
    BARKODISK3 = double.parse(json['BARKODISK3'].toString());
    BARKODISK4 = double.parse(json['BARKODISK4'].toString());
    BARKODISK5 = double.parse(json['BARKODISK5'].toString());
    BARKODISK6 = double.parse(json['BARKODISK6'].toString());
    
BAKIYE = double.parse(json['BAKIYE'].toString());
    guncelDegerler = guncelDeger();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['KOD'] = KOD;
    data['ADI'] = ADI;
    data['SATDOVIZ'] = SATDOVIZ;
    data['ALDOVIZ'] = ALDOVIZ;
    data['STOKTIP'] = STOKTIP;
    data['SATIS_KDV'] = SATIS_KDV;
    data['ALIS_KDV'] = ALIS_KDV;
    data['SFIYAT1'] = SFIYAT1;
    data['SFIYAT2'] = SFIYAT2;
    data['SFIYAT3'] = SFIYAT3;
    data['SFIYAT4'] = SFIYAT4;
    data['SFIYAT5'] = SFIYAT5;
    data['AFIYAT1'] = AFIYAT1;
    data['AFIYAT2'] = AFIYAT2;
    data['AFIYAT3'] = AFIYAT3;
    data['AFIYAT4'] = AFIYAT4;
    data['AFIYAT5'] = AFIYAT5;
    data['OLCUBIRIM1'] = OLCUBIRIM1;
    data['OLCUBIRIM2'] = OLCUBIRIM2;
    data['BIRIMADET1'] = BIRIMADET1;
    data['OLCUBIRIM3'] = OLCUBIRIM3;
    data['BIRIMADET2'] = BIRIMADET2;
    data['RAPORKOD1'] = RAPORKOD1;
    data['RAPORKOD1ADI'] = RAPORKOD1ADI;
    data['RAPORKOD2'] = RAPORKOD2;
    data['RAPORKOD2ADI'] = RAPORKOD2ADI;
    data['RAPORKOD3'] = RAPORKOD3;
    data['RAPORKOD3ADI'] = RAPORKOD3ADI;
    data['RAPORKOD4'] = RAPORKOD4;
    data['RAPORKOD4ADI'] = RAPORKOD4ADI;
    data['RAPORKOD5'] = RAPORKOD5;
    data['RAPORKOD5ADI'] = RAPORKOD5ADI;
    data['RAPORKOD6'] = RAPORKOD6;
    data['RAPORKOD6ADI'] = RAPORKOD6ADI;
    data['RAPORKOD7'] = RAPORKOD7;
    data['RAPORKOD7ADI'] = RAPORKOD7ADI;
    data['RAPORKOD8'] = RAPORKOD8;
    data['RAPORKOD8ADI'] = RAPORKOD8ADI;
    data['RAPORKOD9'] = RAPORKOD9;
    data['RAPORKOD9ADI'] = RAPORKOD9ADI;
    data['RAPORKOD10'] = RAPORKOD10;
    data['RAPORKOD10ADI'] = RAPORKOD10ADI;
    data['URETICI_KODU'] = URETICI_KODU;
    data['URETICIBARKOD'] = URETICIBARKOD;
    data['RAF'] = RAF;
    data['GRUP_KODU'] = GRUP_KODU;
    data['GRUP_ADI'] = GRUP_ADI;
    data['ACIKLAMA'] = ACIKLAMA;
    data['ACIKLAMA1'] = ACIKLAMA1;
    data['ACIKLAMA2'] = ACIKLAMA2;
    data['ACIKLAMA3'] = ACIKLAMA3;
    data['ACIKLAMA4'] = ACIKLAMA4;
    data['ACIKLAMA5'] = ACIKLAMA5;
    data['ACIKLAMA6'] = ACIKLAMA6;
    data['ACIKLAMA7'] = ACIKLAMA7;
    data['ACIKLAMA8'] = ACIKLAMA8;
    data['ACIKLAMA9'] = ACIKLAMA9;
    data['ACIKLAMA10'] = ACIKLAMA10;
    data['SACIKLAMA1'] = SACIKLAMA1;
    data['SACIKLAMA2'] = SACIKLAMA2;
    data['SACIKLAMA3'] = SACIKLAMA3;
    data['SACIKLAMA4'] = SACIKLAMA4;
    data['SACIKLAMA5'] = SACIKLAMA5;
    data['SACIKLAMA6'] = SACIKLAMA6;
    data['SACIKLAMA7'] = SACIKLAMA7;
    data['SACIKLAMA8'] = SACIKLAMA8;
    data['SACIKLAMA9'] = SACIKLAMA9;
    data['SACIKLAMA10'] = SACIKLAMA10;
    data['KOSULGRUP_KODU'] = KOSULGRUP_KODU;
    data['KOSULALISGRUP_KODU'] = KOSULALISGRUP_KODU;
    data['MARKA'] = MARKA;
    data['AKTIF'] = AKTIF;
    data['TIP'] = TIP;
    data['B2CFIYAT'] = B2CFIYAT;
    data['B2CDOVIZ'] = B2CDOVIZ;
    data['BARKOD1'] = BARKOD1;
    data['BARKOD2'] = BARKOD2;
    data['BARKOD3'] = BARKOD3;
    data['BARKOD4'] = BARKOD4;
    data['BARKOD5'] = BARKOD5;
    data['BARKOD6'] = BARKOD6;
    data['BARKODCARPAN1'] = BARKODCARPAN1;
    data['BARKODCARPAN2'] = BARKODCARPAN2;
    data['BARKODCARPAN3'] = BARKODCARPAN3;
    data['BARKODCARPAN4'] = BARKODCARPAN4;
    data['BARKODCARPAN5'] = BARKODCARPAN5;
    data['BARKODCARPAN6'] = BARKODCARPAN6;
    data['BARKOD1BIRIMADI'] = BARKOD1BIRIMADI;
    data['BARKOD2BIRIMADI'] = BARKOD2BIRIMADI;
    data['BARKOD3BIRIMADI'] = BARKOD3BIRIMADI;
    data['BARKOD4BIRIMADI'] = BARKOD4BIRIMADI;
    data['BARKOD5BIRIMADI'] = BARKOD5BIRIMADI;
    data['BARKOD6BIRIMADI'] = BARKOD6BIRIMADI;
    data['DAHAFAZLABARKOD'] = DAHAFAZLABARKOD;
    data['BIRIM_AGIRLIK'] = BIRIM_AGIRLIK;
    data['EN'] = EN;
    data['BOY'] = BOY;
    data['YUKSEKLIK'] = YUKSEKLIK;
    data['SATISISK'] = SATISISK;
    data['ALISISK'] = ALISISK;
    data['B2BFIYAT'] = B2BFIYAT;
    data['B2BDOVIZ'] = B2BDOVIZ;
    data['LISTEFIYAT'] = LISTEFIYAT;
    data['LISTEDOVIZ'] = LISTEDOVIZ;

    data['OLCUBR1'] = OLCUBR1;
    data['OLCUBR2'] = OLCUBR2;
    data['OLCUBR3'] = OLCUBR3;
    data['OLCUBR4'] = OLCUBR4;
    data['OLCUBR5'] = OLCUBR5;
    data['OLCUBR6'] = OLCUBR6;
    data['BARKODFIYAT1'] = BARKODFIYAT1;
    data['BARKODFIYAT2'] = BARKODFIYAT2;
    data['BARKODFIYAT3'] = BARKODFIYAT3;
    data['BARKODFIYAT4'] = BARKODFIYAT4;
    data['BARKODFIYAT5'] = BARKODFIYAT5;
    data['BARKODFIYAT6'] = BARKODFIYAT6;
    
    data['BARKODISK1'] = BARKODISK1;
    data['BARKODISK2'] = BARKODISK2;
    data['BARKODISK3'] = BARKODISK3;
    data['BARKODISK4'] = BARKODISK4;
    data['BARKODISK5'] = BARKODISK5;
    data['BARKODISK6'] = BARKODISK6;
    data['BAKIYE'] = BAKIYE;
    return data;
  }
}
