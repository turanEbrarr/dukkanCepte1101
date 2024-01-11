 class FisEkParam{
  int? FISID=0;
  int? ID= 0;
  String? ACIKLAMA = "";
  String? DEGER = "";
  int? TIP = 0;
  String? ZORUNLU = "";
  String? VERITIP = "";

  FisEkParam(
      {
      required this.FISID,  
      required this.ID,
      required this.ACIKLAMA,
      required this.DEGER,
      required this.TIP,
      required this.ZORUNLU,
      required this.VERITIP});


    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FISID'] = FISID;
    data['ID'] = ID;
    data['ACIKLAMA'] = ACIKLAMA;
    data['DEGER'] = DEGER;
    data['TIP'] = TIP;
    data['ZORUNLU'] = ZORUNLU;
    data['VERITIP'] = VERITIP;

    return data;
  }

  FisEkParam.fromJson(Map<String, dynamic> json) {
 
    ID = int.parse(json['ID'].toString());
    ACIKLAMA = json['ACIKLAMA'].toString();
    try{
      DEGER = json['DEGER'].toString();
      FISID = int.parse(json['FISID'].toString());

    }catch(e){
     
    }
   
    TIP = int.parse(json['TIP'].toString());
    ZORUNLU = json['ZORUNLU'].toString();
    VERITIP = json['VERITIP'].toString();
  }


 }