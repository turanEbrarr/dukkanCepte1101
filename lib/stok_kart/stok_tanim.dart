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

  bool etiketIcin = false;
  int? ID;
  String? KOD;
  String? ADI;
  String? TIP;
  String? MARKA;
  double? SFIYAT1;
  double? SFIYAT2;
  double? SFIYAT3;
  double? SFIYAT4;
  double? SFIYAT5;
  double? SATISISK;
  String? OLCUBIRIM1;
  String? OLCUBIRIM2;
  double? AFIYAT1;
  double? ALISISK;
  int? OLCUBR1;
  int? OLCUBR2;
  double? BIRIMADET1;
  double? BIRIMADET2;
  String? BARKOD1;
  String? BARKOD2;
  String? ACIKLAMA;
  double? BARKODCARPAN1;
  double? BARKODCARPAN2;
  int? BAKIYE;
  String? SATDOVIZ;

  guncelDeger? guncelDegerler = guncelDeger();

  StokKart({this.ID,
      this.KOD,
      this.ADI,
      this.TIP,
      this.MARKA,
      this.SFIYAT1,
      this.SFIYAT2,
      this.SFIYAT3,
      this.SFIYAT4,
      this.SFIYAT5,
      this.SATISISK,
        this.OLCUBIRIM1,
  this. OLCUBIRIM2,
      this.SATDOVIZ,
      this.AFIYAT1,
      this.ALISISK,
      this.BAKIYE,
      this.OLCUBR1,
      this.OLCUBR2,
      this.BIRIMADET1,
      this.BIRIMADET2,
      this.BARKOD1,
      this.BARKOD2,
      this.ACIKLAMA,
      this.BARKODCARPAN1,
      this.BARKODCARPAN2,
      this.guncelDegerler,
  });

  StokKart.fromJson(Map<String, dynamic> json) {
    ID =int.parse(json['ID'].toString());
    KOD = json['KOD'];
    ADI = json['ADI'];
    TIP = json['TIP'];
    SATDOVIZ = json['SATDOVIZ'];
    MARKA = json['MARKA'];
    BAKIYE = int.parse(json['BAKIYE'].toString());
    OLCUBIRIM1 = json['OLCUBIRIM1'];
    OLCUBIRIM2 = json['OLCUBIRIM2'];
    SFIYAT1 =  double.parse(json['SFIYAT1'].toString());
    SFIYAT2 =  double.parse(json['SFIYAT2'].toString());
    SFIYAT3 = double.parse(json['SFIYAT3'].toString());
    SFIYAT4 =  double.parse(json['SFIYAT4'].toString());
    SFIYAT5 =  double.parse(json['SFIYAT5'].toString());
    SATISISK = double.parse(json['SATISISK'].toString());
    AFIYAT1 = double.parse(json['AFIYAT1'].toString());
    ALISISK = double.parse(json['ALISISK'].toString());
    OLCUBR1 = int.parse(json['OLCUBR1'].toString());
    OLCUBR2 = int.parse(json['OLCUBR2'].toString());
    BIRIMADET1 =double.parse(json['BIRIMADET1'].toString());
    BIRIMADET2 = double.parse(json['BIRIMADET2'].toString());
    BARKOD1 = json['BARKOD1'];
    BARKOD2 = json['BARKOD2'];
    ACIKLAMA = json['ACIKLAMA'];
    BARKODCARPAN1 = double.parse(json['BARKODCARPAN1'].toString());
    BARKODCARPAN2 =double.parse(json['BARKODCARPAN2'].toString());
    guncelDegerler = guncelDeger();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
   data['ID'] = ID;
    data['KOD'] = KOD;
    data['ADI'] = ADI;
    data['TIP'] = TIP;
    data['BAKIYE'] = BAKIYE;
    data['MARKA'] = MARKA;
    data['SATDOVIZ'] = SATDOVIZ;
    data['SFIYAT1'] = SFIYAT1;
    data['SFIYAT2'] = SFIYAT2;
    data['SFIYAT3'] = SFIYAT3;
    data['OLCUBIRIM1'] = OLCUBIRIM1;
    data['OLCUBIRIM2'] = OLCUBIRIM2;
    data['SFIYAT4'] = SFIYAT4;
    data['SFIYAT5'] = SFIYAT5;
    data['SATISISK'] = SATISISK;
    data['AFIYAT1'] = AFIYAT1;
    data['ALISISK'] = ALISISK;
    data['OLCUBR1'] = OLCUBR1;
    data['OLCUBR2'] = OLCUBR2;
    data['BIRIMADET1'] = BIRIMADET1;
    data['BIRIMADET2'] = BIRIMADET2;
    data['BARKOD1'] = BARKOD1;
    data['BARKOD2'] = BARKOD2;
    data['ACIKLAMA'] = ACIKLAMA;
    data['BARKODCARPAN1'] = BARKODCARPAN1;
    data['BARKODCARPAN2'] = BARKODCARPAN2;
    return data;
  }
}
