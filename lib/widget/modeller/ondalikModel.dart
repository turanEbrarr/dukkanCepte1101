class OndalikModel {
  int? SUBEID;
  
  int? FIYAT;
  int? MIKTAR;
  int? KUR;
  int? DOVFIYAT;
  int? TUTAR;
  int? DOVTUTAR;

  int? ALISFIYAT;
  int? ALISMIKTAR;
  int? ALISKUR;
  int? ALISDOVFIYAT;
  int? ALISTUTAR;
  int? ALISDOVTUTAR;

  int? PERFIYAT;
  int? PERMIKTAR;
  int? PERKUR;
  int? PERDOVFIYAT;
  int? PERTUTAR;
  int? PERDOVTUTAR;

  OndalikModel.empty()
      : this(
          SUBEID: 1,
          FIYAT: 1,
          MIKTAR: 1,
          KUR: 1,
          DOVFIYAT: 1,
          TUTAR: 1,
          DOVTUTAR: 1,
          ALISFIYAT: 1,
          ALISMIKTAR: 1,
          ALISKUR: 1,
          ALISDOVFIYAT: 1,
          ALISTUTAR: 1,
          ALISDOVTUTAR: 1,
          PERFIYAT: 1,
          PERMIKTAR: 1,
          PERKUR: 1,
          PERDOVFIYAT: 1,
          PERTUTAR: 1,
          PERDOVTUTAR: 1,
       
        );
  OndalikModel({
    this.SUBEID,
    this.FIYAT,
    this.MIKTAR,
    this.KUR,
    this.DOVFIYAT,
    this.TUTAR,
    this.DOVTUTAR,
    this.ALISFIYAT,
    this.ALISMIKTAR,
    this.ALISKUR,
    this.ALISDOVFIYAT,
    this.ALISTUTAR,
    this.ALISDOVTUTAR,
    this.PERFIYAT,
    this.PERMIKTAR,
    this.PERKUR,
    this.PERDOVFIYAT,
    this.PERTUTAR,
    this.PERDOVTUTAR,
  });

  factory OndalikModel.fromJson(Map<String, dynamic> json) {
    return OndalikModel(
      SUBEID: int.parse(json['SUBEID'].toString()),
      FIYAT: int.parse(json['FIYAT'].toString()),
      MIKTAR: int.parse(json['MIKTAR'].toString()),
      KUR: int.parse(json['KUR'].toString()),
      DOVFIYAT: int.parse(json['DOVFIYAT'].toString()),
      TUTAR: int.parse(json['TUTAR'].toString()),
      DOVTUTAR: int.parse(json['DOVTUTAR'].toString()),
      ALISFIYAT: int.parse(json['ALISFIYAT'].toString()),
      ALISMIKTAR: int.parse(json['ALISMIKTAR'].toString()),
      ALISKUR: int.parse(json['ALISKUR'].toString()),
      ALISDOVFIYAT: int.parse(json['ALISDOVFIYAT'].toString()),
      ALISTUTAR: int.parse(json['ALISTUTAR'].toString()),
      ALISDOVTUTAR: int.parse(json['ALISDOVTUTAR'].toString()),
      PERFIYAT: int.parse(json['PERFIYAT'].toString()),
      PERMIKTAR: int.parse(json['PERMIKTAR'].toString()),
      PERKUR: int.parse(json['PERKUR'].toString()),
      PERDOVFIYAT: int.parse(json['PERDOVFIYAT'].toString()),
      PERTUTAR: int.parse(json['PERTUTAR'].toString()),
      PERDOVTUTAR: int.parse(json['PERDOVTUTAR'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['SUBEID'] = this.SUBEID;
    data['FIYAT'] = this.FIYAT;
    data['MIKTAR'] = this.MIKTAR;
    data['KUR'] = this.KUR;
    data['DOVFIYAT'] = this.DOVFIYAT;
    data['TUTAR'] = this.TUTAR;
    data['DOVTUTAR'] = this.DOVTUTAR;
    data['ALISFIYAT'] = this.ALISFIYAT;
    data['ALISMIKTAR'] = this.ALISMIKTAR;
    data['ALISKUR'] = this.ALISKUR;
    data['ALISDOVFIYAT'] = this.ALISDOVFIYAT;
    data['ALISTUTAR'] = this.ALISTUTAR;
    data['ALISDOVTUTAR'] = this.ALISDOVTUTAR;
    data['PERFIYAT'] = this.PERFIYAT;
    data['PERMIKTAR'] = this.PERMIKTAR;
    data['PERKUR'] = this.PERKUR;
    data['PERDOVFIYAT'] = this.PERDOVFIYAT;
    data['PERTUTAR'] = this.PERTUTAR;
    data['PERDOVTUTAR'] = this.PERDOVTUTAR;
    return data;
  }
}
