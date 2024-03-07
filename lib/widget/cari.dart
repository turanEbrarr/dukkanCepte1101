/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import '../widget/cariAltHesap.dart';

class Cari {
  int? ID;
  String? KOD;
  String? ADI;
  String? PLASIYERKODU;
  String? ADRES;
  String? IL;
  String? ILCE;
  String? TEL;
  String? EMAIL;
  double? BAKIYE;
  int? AKTIF;
  String? VERGIDAIRESI;
  String? VERGINO;
  List<CariAltHesap> cariAltHesaplar = [];

  Cari(
      {this.ID,
       this.KOD,
      this.ADI,
      this.PLASIYERKODU,
      this.ADRES,
      this.IL,
      this.ILCE,
      this. VERGIDAIRESI,
      this. VERGINO,
      this.TEL,
      this.EMAIL,
      this.BAKIYE,
      this.AKTIF});

  Cari.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
       KOD = json['KOD'];
    ADI = json['ADI'];
    PLASIYERKODU = json['PLASIYERKODU'];
    ADRES = json['ADRES'];
    IL = json['IL'];
    ILCE = json['ILCE'];
    TEL = json['TEL'];
    VERGIDAIRESI = json['VERGIDAIRESI'];
    VERGINO = json['VERGINO'];
  EMAIL = json['EMAIL'];
    AKTIF = json['AKTIF'];
    BAKIYE = double.parse(json['BAKIYE'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
data['KOD'] = this.KOD;
    data['ADI'] = this.ADI;
    data['PLASIYERKODU'] = this.PLASIYERKODU;
    data['ADRES'] = this.ADRES;
    data['IL'] = this.IL;
    data['ILCE'] = this.ILCE;
    data['VERGIDAIRESI'] = this.VERGIDAIRESI;
    data['VERGINO'] = this.VERGINO;
    data['TEL'] = this.TEL;
    data['EMAIL'] = this.EMAIL;
    data['BAKIYE'] = this.BAKIYE;
    data['AKTIF'] = this.AKTIF;
    data['BAKIYE'] = BAKIYE;
    return data;
  }
}
