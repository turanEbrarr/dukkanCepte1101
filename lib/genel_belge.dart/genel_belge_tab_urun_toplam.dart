//import 'dart:js_util';

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dukkan_cepte/faturaFis/fisEkParam.dart';
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/webservis/kurModel.dart';
import 'package:dukkan_cepte/widget/cariAltHesap.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/customAlertDialog.dart';
import 'package:dukkan_cepte/widget/main_page.dart';
import 'package:dukkan_cepte/widget/modeller/logModel.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import '../controllers/fisController.dart';
import '../faturaFis/fis.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import 'genel_belge_pdf_onizleme.dart';

class genel_belge_tab_urun_toplam extends StatefulWidget {
  const genel_belge_tab_urun_toplam({
    super.key,
    required this.belgeTipi,
  });
  final String belgeTipi;
  @override
  State<genel_belge_tab_urun_toplam> createState() =>
      _genel_belge_tab_urun_toplamState();
}

class _genel_belge_tab_urun_toplamState
    extends State<genel_belge_tab_urun_toplam> {
  BaseService bs = BaseService();
  bool tamamaBastiMi = false;
  int vadeGunuFlag = 0;
  late DateTime vade_tarihi;
  late DateTime soz_tarihi = DateTime.now();
  bool? ischecked = false;
  final FisController fisEx = Get.find();
  List<String> para_birim = [];
  List<double> para_kur = [];
  String? seciliParaBirimi = "";
  String localBelgeTipi = "";
  bool gen1Bas = false;
  bool gen2Bas = false;
  TextEditingController vadeGunuController = TextEditingController();
  TextEditingController genelIskonto1Controller = TextEditingController();
  TextEditingController genelIskonto2Controller = TextEditingController();
  TextEditingController kurController = TextEditingController();
  TextEditingController aciklama1Controller = TextEditingController();
  TextEditingController aciklama2Controller = TextEditingController();
  TextEditingController aciklama3Controller = TextEditingController();
  TextEditingController aciklama4Controller = TextEditingController();
  TextEditingController aciklama5Controller = TextEditingController();
  TextEditingController aciklama6Controller = TextEditingController();
  TextEditingController depoController = TextEditingController();
  TextEditingController subeController = TextEditingController();

  //TextEditingController ozelKod1Controller = TextEditingController();
  //TextEditingController ozelKod2Controller = TextEditingController();

  /*InputDecoration decoration = const InputDecoration(
   contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
  labelStyle: TextStyle(fontSize: 12),
);*/
  List<IslemTipi> islemTipiList = [
    IslemTipi(ADI: "Normal", ID: 0),
    IslemTipi(ADI: "Açık", ID: 1)
  ];

  Widget takvimWidgetOlustur(FisEkParam ff) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * .8,
      child: Container(
        color: Color.fromARGB(255, 30, 38, 45),
        child: ElevatedButton(
          onPressed: () async {
            String date = await Ctanim.pickDate(context);
            if (date == "") return;
            fisEx.fis!.value.listFisEkParam
                .removeWhere((item) => item.ID == ff.ID);
            setState(() {
              ff.FISID = fisEx.fis!.value.ID;
              ff.DEGER = date.toString();
              fisEx.fis!.value.listFisEkParam.add(ff);
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 30, 38, 45),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            ff.ZORUNLU == "True" ? ff.ACIKLAMA! + "(Zorunlu)" : ff.ACIKLAMA!,
          ),
        ),
      ),
    );
  }

  Widget stringWidgetOlustur(FisEkParam ff) {
    TextEditingController textEditingController = TextEditingController();
    for (var element in fisEx.fis!.value.listFisEkParam) {
      if (ff.ID == element.ID) {
        ff = element;
        textEditingController.text = element.DEGER!;
      }
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * .8,
      child: TextFormField(
        controller: textEditingController,
        cursorColor: Color.fromARGB(255, 30, 38, 45),
        onChanged: (value) async {
          if (value != "") {
            try {
              fisEx.fis!.value.listFisEkParam
                  .removeWhere((item) => item.ID == ff.ID);
            } catch (e) {
              print(e);
            }
            // boşsas kabul etme veri tabaından sil
            ff.FISID = fisEx.fis!.value.ID;
            ff.DEGER = value.toString();
            fisEx.fis!.value.listFisEkParam.add(ff);
            print("STRİNG İÇERİK:" + ff.DEGER!);
          } else {
            try {
              fisEx.fis!.value.listFisEkParam
                  .removeWhere((item) => item.ID == ff.ID);
            } catch (e) {
              print(e);
            }
          }
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
              color: Color.fromARGB(255, 30, 38, 45),
              onPressed: () async {
                textEditingController.text = "";
                fisEx.fis!.value.listFisEkParam
                    .removeWhere((item) => item.ID == ff.ID);
              },
              icon: Icon(Icons.clear)),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: Color.fromARGB(255, 30, 38, 45))),
          hintText:
              ff.ZORUNLU == "True" ? ff.ACIKLAMA! + "(Zorunlu)" : ff.ACIKLAMA!,
        ),
      ),
    );
  }

  Widget decimalWidgetOlustur(FisEkParam ff) {
    TextEditingController textEditingController = TextEditingController();
    for (var element in fisEx.fis!.value.listFisEkParam) {
      if (ff.ID == element.ID) {
        ff = element;
        textEditingController.text = element.DEGER!;
      }
    }
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * .8,
        child: TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            fisEx.fis!.value.listFisEkParam
                .removeWhere((item) => item.ID == ff.ID);
            ff.FISID = fisEx.fis!.value.ID;
            ff.DEGER = value.toString();
            fisEx.fis!.value.listFisEkParam.add(ff);
            print("decimal İÇERİK:" + ff.DEGER!);
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Color.fromARGB(255, 30, 38, 45),
                onPressed: () {
                  textEditingController.text = "";
                  fisEx.fis!.value.listFisEkParam
                      .removeWhere((item) => item.ID == ff.ID);
                  //  belgeNo.text = "";
                },
                icon: Icon(Icons.clear)),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 30, 38, 45))),
            hintText: ff.ZORUNLU == "True"
                ? ff.ACIKLAMA! + "(Zorunlu)"
                : ff.ACIKLAMA!,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            //  FilteringTextInputFormatter.digitsOnly,
          ],
        ));
  }

  //eskide kaldı yukarıya göre güncelle
  Widget boolWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * .8,
      child: CheckboxListTile(
        title: Text(data["degiskenAdi"]),
        value: data["value"],
        onChanged: (newValue) {
          setState(() {
            data["value"] = newValue ?? false;
            data["obje"].SQL = newValue.toString();
          });
        },
      ),
    );
  }

  //eskide kaldı yukarıya göre güncelle
  Widget intWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * 0.07,
        child: TextField(
          controller: data["controller"],
          onChanged: (value) {
            data["obje"].SQL = value.toString();
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Color.fromARGB(255, 30, 38, 45),
                onPressed: () {
                  //  belgeNo.text = "";
                },
                icon: Icon(Icons.clear)),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 30, 38, 45))),
            hintText: data["degiskenAdi"],
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ));
  }

  List<Widget> widgetList = [];
  List<Map<String, dynamic>> params = [];

  hesapla({DateTime? fisTarihi, DateTime? vadeTarihi, int? vadeGunu}) {
    if (fisTarihi != null) {
      vadeGunu = 0;
      vadeGunuController.text = vadeGunu.toString();
      vadeTarihi = vade_tarihi;
      vade_tarihi = DateTime.now();
      fisEx.fis!.value.VADETARIHI =
          DateFormat('yyyy-MM-dd').format(vade_tarihi);
    } else if (vadeGunu != null) {
      vadeGunu = vadeGunu;
      vade_tarihi = fisEx.fis_tarihi.add(Duration(days: vadeGunu));
      fisEx.fis!.value.VADEGUNU = vadeGunu.toString();
      fisEx.fis!.value.VADETARIHI =
          DateFormat('yyyy-MM-dd').format(vade_tarihi);
    } else if (vadeTarihi != null) {
      final gunFark = vadeTarihi.difference(fisEx.fis_tarihi).inDays;
      vadeGunuController.text = gunFark.toString();
      fisEx.fis!.value.VADETARIHI =
          DateFormat('yyyy-MM-dd').format(vade_tarihi);
      fisEx.fis!.value.VADEGUNU = vadeGunuController.text;
    } else {
      AlertDialog(title: Text("Lütfen doğru parametreleri girin."));
    }
  }

  IslemTipi? seciliFaturaTip;
  List<CariAltHesap> altHesaplar = [];
  CariAltHesap? selectedAltHesap;
  KurModel? altHesaptanGelen;
  bool KDVDAHIL = false;
  Color KDVDahil = Colors.black;
  String? seciliFaturaTipYeni;
  List<String> faturaTipList = ["Normal", "İade"];
  CariAltHesap? varsayilanAltHesap;
  @override
  void initState() {
    super.initState();
    print("CARİ ADI:" + fisEx.fis!.value.cariKart.ADI!);
    print("FİŞ STOK SAYISI: " +
        fisEx.fis!.value.fisStokListesi.length.toString());
    print("DETAY PARAMETRE DURUMU: ");
    for (var element in fisEx.fis!.value.listFisEkParam) {
      print(element.ACIKLAMA! + " : " + element.DEGER!);
    }

    seciliFaturaTip = fisEx.fis!.value.ISLEMTIPI == null ||
            fisEx.fis!.value.ISLEMTIPI == ""
        ? islemTipiList.first
        : islemTipiList.firstWhere(
            (element) => element.ID == int.parse(fisEx.fis!.value.ISLEMTIPI!));

    seciliFaturaTipYeni = faturaTipList.first;

    String? cariKod = fisEx.fis!.value.CARIKOD;
    //ALT HESAP GUNCELLEMESI PUSHLANMADI
    altHesaplar.clear();
    for (var element in listeler.listCariAltHesap) {
      if (element.KOD == cariKod) {
        altHesaplar.add(element);
        if (element.VARSAYILAN == "E") {
          varsayilanAltHesap = element;
        }
      }
    }
    if (altHesaplar.isNotEmpty) {
      if (varsayilanAltHesap == null) {
        varsayilanAltHesap = altHesaplar.first;
      }
      selectedAltHesap = varsayilanAltHesap;
      fisEx.fis!.value.ALTHESAP = varsayilanAltHesap!.ALTHESAP;
      for (var element in listeler.listKur) {
        if (element.ID == varsayilanAltHesap!.DOVIZID) {
          setState(() {
            altHesaptanGelen = element;
            kurController.text = altHesaptanGelen!.KUR.toString();
          });
        }
      }

      fisEx.fis!.value.DOVIZ = altHesaptanGelen!.ACIKLAMA;
      fisEx.fis!.value.KUR = altHesaptanGelen!.KUR;
      fisEx.fis!.value.DOVIZID = altHesaptanGelen!.ID;
      if (true) {
        fisEx.fis!.value.ISK1 = 0.0;
        genelIskonto1Controller.text =
            "0.0";
        gen1Bas = true;
      }

      Ctanim.genelToplamHesapla(fisEx);
    }

  
    if (Ctanim.KDVDahilMiDinamik == true) {
      KDVDahil = Colors.green;
    } else {
      KDVDahil = Colors.red;
    }
    setState(() {});
    Ctanim.genelToplamHesapla(fisEx);
    fisEx.fis_tarihi = DateTime.parse(fisEx.fis!.value.TARIH!);
    vade_tarihi = DateTime.parse(fisEx.fis!.value.VADETARIHI!);
    String? vadeGunu =
        fisEx.fis?.value.VADEGUNU == "" ? "0" : fisEx.fis?.value.VADEGUNU!;
    vadeGunuController.text = vadeGunu!;

    for (var element in listeler.listKur) {
      para_birim.add(element.ACIKLAMA!);
      para_kur.add(element.KUR!);
    }

    seciliParaBirimi = fisEx.fis!.value.DOVIZ;
    kurController.text = fisEx.fis!.value.KUR.toString();
    for (var element in listeler.listSubeDepoModel) {
      if (Ctanim.kullanici!.YERELDEPOID == element.DEPOID.toString()) {
        depoController.text = element.DEPOADI!;
      }
      if (Ctanim.kullanici!.YERELSUBEID == element.SUBEID.toString()) {
        subeController.text = element.SUBEADI!;
      }
      if (depoController.text == "") {
        depoController.text = "Uygun Depo Yok";
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //fisEx.fis!.value.TESLIMTARIHI = soz_tarihi.toString();

    fisEx.fis!.value.ALTHESAPID = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Fatura Düzenlemeleri",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0, left: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Alt Hesap Seçimi :",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .80,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CariAltHesap>(
                        value: selectedAltHesap,
                        items: altHesaplar.map((CariAltHesap banka) {
                          return DropdownMenuItem<CariAltHesap>(
                            value: banka,
                            child: Text(
                              banka.ALTHESAP ?? "",
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (CariAltHesap? selected) {
                          setState(() {
                            selectedAltHesap = selected;
                          });
                          fisEx.fis!.value.ALTHESAP = selected!.ALTHESAP;
                          for (var element in listeler.listKur) {
                            if (element.ID == selected.DOVIZID) {
                              setState(() {
                                altHesaptanGelen = element;
                                kurController.text =
                                    altHesaptanGelen!.KUR.toString();
                              });
                            }
                          }
                          fisEx.fis!.value.DOVIZ = altHesaptanGelen!.ACIKLAMA;
                          fisEx.fis!.value.KUR = altHesaptanGelen!.KUR;
                          fisEx.fis!.value.DOVIZID = altHesaptanGelen!.ID;
                          Ctanim.genelToplamHesapla(fisEx);
                        },
                      ),
                    ),
                    /* DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAltHesap,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAltHesap = newValue!;
                              fisEx.fis!.value.ALTHESAP = selectedAltHesap;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text("NORMAL"),
                            ),
                            ...altHesaplar.map((String altHesap) {
                              return DropdownMenuItem<String>(
                                value: altHesap,
                                child: Text(altHesap),
                              );
                            }).toList(),
                          ],
                        ),
                      )
                      */
                  ),
                ),
                widget.belgeTipi == "Satis_Fatura"
                    ? Divider(
                        thickness: 1,
                      )
                    : Container(),
                widget.belgeTipi == "Satis_Fatura"
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 0, left: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "İşlem Tipi :",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : Container(),
            
                    Container(
                        width: MediaQuery.of(context).size.width * .80,
                        height: MediaQuery.of(context).size.height / 15,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<IslemTipi>(
                              value: seciliFaturaTip,
                              items: islemTipiList.map((IslemTipi banka) {
                                return DropdownMenuItem<IslemTipi>(
                                  value: banka,
                                  child: Text(
                                    banka.ADI ?? "",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (IslemTipi? selected) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        pdfSimgesi: false,
                                        align: TextAlign.left,
                                        title: 'İşlem Onayı',
                                        message:
                                            'İşlem tipi değiştirildiğinde belgenin seri numarası değişecektir. Onaylıyor musunuz?',
                                        onPres: () async {
                                          setState(() {
                                            seciliFaturaTip = selected;
                                          });
                                          fisEx.fis!.value.ISLEMTIPI =
                                              seciliFaturaTip!.ID.toString();

                                          Navigator.pop(context);
                                        },
                                        secondButtonText: "İptal",
                                        onSecondPress: () {
                                          Navigator.pop(context);
                                        },
                                        buttonText: 'Onay',
                                      );
                                    });
                              },
                            ),
                          ),
                          /* DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAltHesap,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAltHesap = newValue!;
                              fisEx.fis!.value.ALTHESAP = selectedAltHesap;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text("NORMAL"),
                            ),
                            ...altHesaplar.map((String altHesap) {
                              return DropdownMenuItem<String>(
                                value: altHesap,
                                child: Text(altHesap),
                              );
                            }).toList(),
                          ],
                        ),
                      )
                      */
                        ),
                      ),
                
                widget.belgeTipi == "Alis_Fatura"
                    ? Column(
                        children: [
                          Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 0, left: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Fatura Tipi :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .80,
                            height: MediaQuery.of(context).size.height / 15,
                            child: Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: seciliFaturaTipYeni,
                                  items: faturaTipList.map((String banka) {
                                    return DropdownMenuItem<String>(
                                      value: banka,
                                      child: Text(
                                        banka,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selected) {
                                    if (selected == "İade") {
                                      localBelgeTipi = "Alis_Fatura_Iade";
                                      fisEx.fis!.value.TIP = 17;
                                      Ctanim.faturaTipiDegisi = true;
                                      Ctanim.yeniFaturaTipi =
                                          localBelgeTipi; // iade
                                      setState(() {
                                        seciliFaturaTipYeni = selected!;
                                      });
                                    } else if (selected == "Normal") {
                                      localBelgeTipi = "Alis_Fatura";
                                      fisEx.fis!.value.TIP = 3;
                                      Ctanim.faturaTipiDegisi = true;
                                      Ctanim.yeniFaturaTipi =
                                          localBelgeTipi; // normal
                                      setState(() {
                                        seciliFaturaTipYeni = selected!;
                                      });
                                    }
                                  },
                                ),
                              ),
                              /* DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAltHesap,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAltHesap = newValue!;
                              fisEx.fis!.value.ALTHESAP = selectedAltHesap;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text("NORMAL"),
                            ),
                            ...altHesaplar.map((String altHesap) {
                              return DropdownMenuItem<String>(
                                value: altHesap,
                                child: Text(altHesap),
                              );
                            }).toList(),
                          ],
                        ),
                      )
                      */
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Row(
                            children: [
                              Text("Döviz Tipi : "),
                              Text(altHesaptanGelen!.ACIKLAMA == null ||
                                      altHesaptanGelen!.ACIKLAMA == ""
                                  ? "HATA"
                                  : altHesaptanGelen!.ACIKLAMA.toString())

/*
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: seciliParaBirimi,
                                    items: para_birim
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (e) {
                                      double tempKur = 0.0;
                                      int tempID = 0;
                                      print(e);
                                      setState(() {
                                        for (int i = 0;
                                            i < listeler.listKur.length;
                                            i++) {
                                          if (e ==
                                              listeler.listKur[i].ACIKLAMA) {
                                            kurController.text = listeler
                                                .listKur[i].KUR
                                                .toString();
                                            tempKur = listeler.listKur[i].KUR!;
                                            tempID = listeler.listKur[i].ID!;
                                          }
                                        }
                                        seciliParaBirimi = e;
                                      });
                                      fisEx.fis!.value.DOVIZ = seciliParaBirimi;
                                      fisEx.fis!.value.KUR = tempKur;
                                      fisEx.fis!.value.DOVIZID = tempID;
                                      Ctanim.genelToplamHesapla(fisEx);
                                    }),
                              ),
                              */
                            ],
                          )),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 247, 245, 245),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: kurController,
                            cursorColor: Color.fromARGB(255, 60, 59, 59),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'))
                            ],
                            decoration: InputDecoration(
                                label: Text(
                                  "Kur Giriniz:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 60, 59, 59),
                                      fontSize: 15),
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            CheckboxListTile(
              title: Text(
                "KDV DAHİL",
                style: TextStyle(color: KDVDahil),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: KDVDAHIL,
              onChanged: (value) {
                setState(() {
                  KDVDAHIL = value!;
                  Ctanim.KDVDahilMiDinamik = KDVDAHIL;
                  if (value == true) {
                    KDVDahil = Colors.green;
                  } else {
                    KDVDahil = Colors.red;
                  }
                  setState(() {});
                  Ctanim.genelToplamHesapla(fisEx, KDVtipDegisti: true);
                });
              },
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 80,
                  padding: EdgeInsets.all(
                      8.0), // İstediğiniz padding değerini belirleyin
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 245, 245),
                    // Kenarlık rengini ve kalınlığını ayarlayın
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
                  ),
                  child:  TextFormField(
                          controller: genelIskonto1Controller,
                          onTap: () {
                            setState(() {
                              gen1Bas = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value == "") {
                                fisEx.fis!.value.ISK1 = 0.0;
                                Ctanim.genelToplamHesapla(fisEx);
                                setState(() {});
                              }
                              fisEx.fis!.value.ISK1 =
                                  Ctanim.noktadanSonraAlinacak(double.parse(
                                      genelIskonto1Controller.text));
                              Ctanim.genelToplamHesapla(fisEx);
                            });
                          },
                          cursorColor: Color.fromARGB(255, 60, 59, 59),
                          decoration: InputDecoration(
                              label: Text(
                                fisEx.fis!.value.ISK1 == 0.0
                                    ? "Genel İskonto1 Giriniz : "
                                    : gen1Bas == true
                                        ? "Yapılan Birinci İskonto Tutarı: " +
                                            "%" +
                                            fisEx.fis!.value.ISK1.toString()
                                        : fisEx.fis!.value.ISK1.toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 60, 59, 59),
                                    fontSize: 15),
                              ),
                              border: InputBorder.none),
                        )
                     ),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 80,
                  padding: EdgeInsets.all(
                      8.0), // İstediğiniz padding değerini belirleyin
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 245, 245),
                    // Kenarlık rengini ve kalınlığını ayarlayın
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
                  ),
                  child: 
                   TextFormField(
                          controller: genelIskonto2Controller,
                          onTap: () {
                            setState(() {
                              gen2Bas = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value == "") {
                                fisEx.fis!.value.ISK2 = 0.0;
                                Ctanim.genelToplamHesapla(fisEx);
                                setState(() {});
                              }
                              fisEx.fis!.value.ISK2 =
                                  Ctanim.noktadanSonraAlinacak(double.parse(
                                      genelIskonto2Controller.text));
                              Ctanim.genelToplamHesapla(fisEx);
                            });
                          },
                          cursorColor: Color.fromARGB(255, 60, 59, 59),
                          decoration: InputDecoration(
                              label: Text(
                                fisEx.fis!.value.ISK1 == 0.0
                                    ? "Genel İskonto2 Giriniz : "
                                    : gen2Bas == true
                                        ? "Yapılan İkinci İskonto Tutarı: " +
                                            "%" +
                                            fisEx.fis!.value.ISK2.toString()
                                        : fisEx.fis!.value.ISK2.toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 60, 59, 59),
                                    fontSize: 15),
                              ),
                              border: InputBorder.none),
                        )
                      ),
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            "ÜRÜN TOPLAMI      :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            Ctanim.donusturMusteri(
                                fisEx.fis!.value.TOPLAM!.toString()),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("İNDİRİM TOPLAMI : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.INDIRIM_TOPLAMI!.toString()),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("ARA TOPLAMI        :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.ARA_TOPLAM!.toString()),
                              textAlign: TextAlign.end),
                        ), //araToplam.toString()
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("KDV TUTARI            :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.KDVTUTARI!.toString()),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("GENEL TOPLAMI    :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.GENELTOPLAM!.toString()),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("DÖVİZ TOPLAMI     :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ), // DEĞER EKLENECEK LİSTEDEN
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Fatura Detayları",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            /*
              
            */
            Container(
              width: MediaQuery.of(context).size.width * .90,
              height: MediaQuery.of(context).size.height / 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: TextFormField(
                      controller: subeController,
                      readOnly: true,
                      cursorColor: Color.fromARGB(255, 60, 59, 59),
                      decoration: InputDecoration(
                          label: Text(
                            "Şube:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 60, 59, 59),
                                fontSize: 15),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  VerticalDivider(
                    thickness: 1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: TextFormField(
                      controller: depoController,
                      readOnly: true,
                      cursorColor: Color.fromARGB(255, 60, 59, 59),
                      decoration: InputDecoration(
                          label: Text(
                            "Depo:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 60, 59, 59),
                                fontSize: 15),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * .8,
                      child: Text(
                          listeler.listFisEkParam
                                  .any((param) => param.ZORUNLU == "True")
                              ? "Detay Bilgiler (Zorunlu parametreler mevcut.)"
                              : "Detay Bilgiler (Zorunlu parametreler mevcut değil.)",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                IconButton(
                    onPressed: () async {
                      if (listeler.listFisEkParam.isNotEmpty) {
                        widgetList.clear();

                        for (var element in listeler.listFisEkParam) {
                          if (element.VERITIP == "datetime") {
                            widgetList.add(takvimWidgetOlustur(element));
                          } else if (element.VERITIP == "karakter") {
                            widgetList.add(stringWidgetOlustur(element));
                          } else if (element.VERITIP == "decimal") {
                            widgetList.add(decimalWidgetOlustur(element));
                          }
                          if (element.ZORUNLU == "True") {
                            widgetList.insert(0, widgetList.removeLast());
                          }
                        }
                        if (widgetList.isNotEmpty) {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width * .7,
                                  height:
                                      MediaQuery.of(context).size.height * .8,
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0))),
                                    insetPadding: EdgeInsets.zero,
                                    title: Text(
                                      "   Fatura Detay",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .7,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .8,
                                      child: SingleChildScrollView(
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        clipBehavior: Clip.hardEdge,
                                        child: Column(
                                          
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .7,
                                              child: ListView.builder(
                                                itemCount: widgetList.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      widgetList[index],
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .05,),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .05,
                                                width: 400,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Kaydet ve Çık")),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios_outlined))
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 100,
                      child: Text("FİŞ TARİHİ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                ),
                ElevatedButton(
                  child:
                      Text(DateFormat("yyyy-MM-dd").format(fisEx.fis_tarihi)),
                  onPressed: () async {
                    DateTime? date = await pickDate();

                    if (date == null) {
                      return;
                    } else if (date.isBefore(DateTime.now())) {
                      date = DateTime.now();

                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            align: TextAlign.left,
                            title: 'Hata',
                            message: 'Geçmiş Tarihli Belgeye İşlem Yapılamaz',
                            onPres: () {
                              Navigator.pop(context);
                            },
                            buttonText: 'Geri',
                          );
                        },
                      );
                    }
                    setState(() {
                      fisEx.fis_tarihi = date!;

                      fisEx.fis!.value.TARIH =
                          DateFormat('yyyy-MM-dd').format(fisEx.fis_tarihi);
                      hesapla(fisTarihi: fisEx.fis_tarihi);
                    });
                  },
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 100,
                      child: Text("VADE TARİHİ ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                ),
                ElevatedButton(
                    child:
                        Text("${DateFormat("yyyy-MM-dd").format(vade_tarihi)}"),
                    onPressed: () async {
                      DateTime? date = await pickDate();
                      if (date == null) {
                        return;
                      } else if (date.isBefore(DateTime.now())) {
                        date = DateTime.now();

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: 'Hata',
                              message: 'Geçmiş Tarihli Belgeye İşlem Yapılamaz',
                              onPres: () {
                                Navigator.pop(context);
                              },
                              buttonText: 'Geri',
                            );
                          },
                        );
                      }
                      setState(() {
                        vade_tarihi = date!;
                        vadeGunuFlag = 1;
                        hesapla(vadeTarihi: vade_tarihi);
                        /*      
                           vadeGunuController.text=vadeGunuHEsapla(vade_tarihi, fisEx.fis_tarihi);
                           fisEx.fis!.value.VADETARIHI = DateFormat('yyyy-MM-dd').format(vade_tarihi);
                           fisEx.fis!.value.VADEGUNU=vadeGunuController.text;
                        */
                      });
                    }),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 65,
                  padding: EdgeInsets.all(
                      8.0), // İstediğiniz padding değerini belirleyin
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 245, 245),
                    // Kenarlık rengini ve kalınlığını ayarlayın
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: vadeGunuController,
                    onChanged: (value) {
                      fisEx.fis!.value.VADEGUNU = vadeGunuController.text;
                      vadeGunuFlag = 1;
                      setState(() {
                        hesapla(vadeGunu: int.parse(vadeGunuController.text));
                      });
                    },
                    cursorColor: Color.fromARGB(255, 60, 59, 59),
                    decoration: InputDecoration(
                        label: Text(
                          "Vade Günü Giriniz",
                          style: TextStyle(
                              color: Color.fromARGB(255, 60, 59, 59),
                              fontSize: 15),
                        ),
                        border: InputBorder.none),
                  )),
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 100,
                      child: Text("SEVK/TES. TARİHİ ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                ),
                ElevatedButton(
                    child:
                        Text("${DateFormat("yyyy-MM-dd").format(soz_tarihi)}"),
                    onPressed: () async {
                      DateTime? date = await pickDate();
                      if (date == null) {
                        return;
                      } else if (date.isBefore(DateTime.now())) {
                        date = DateTime.now();

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: 'Hata',
                              message: 'Geçmiş Tarihli Belgeye İşlem Yapılamaz',
                              onPres: () {
                                Navigator.pop(context);
                              },
                              buttonText: 'Geri',
                            );
                          },
                        );
                      }
                      setState(() {
                        soz_tarihi = date!;
                        // String son = soz_tarihi.year.toString() +
                        "-" +
                            soz_tarihi.month.toString() +
                            "-" +
                            soz_tarihi.day.toString();
                        fisEx.fis!.value.TESLIMTARIHI =
                            DateFormat('yyyy-MM-dd').format(soz_tarihi);
                        /*  
                        hesapla(vadeTarihi: soz_tarihi);
                         vadeGunuController.text=vadeGunuHEsapla(vade_tarihi, fisEx.fis_tarihi);
                           fisEx.fis!.value.VADETARIHI = DateFormat('yyyy-MM-dd').format(vade_tarihi);
                           fisEx.fis!.value.VADEGUNU=vadeGunuController.text;
                        */
                      });
                    }),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Açıklama Ve Özel Kodlar",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Satir(labelText: "AÇIKLAMA 1"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 2"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 3"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 4"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 5"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "ÖZEL KOD 1"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "ÖZEL KOD 2"),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () async {
          if (fisEx.fis!.value.fisStokListesi.length != 0) {
            Fis fiss = fisEx.fis!.value;
         

            if (Ctanim.kullanici!.ISLEMAKTARILSIN == "E") {
              fisEx.fis!.value.DURUM = true;
              final now = DateTime.now();
              final formatter = DateFormat('HH:mm');
              String saat = formatter.format(now);
             
              if (localBelgeTipi.isEmpty) {
                await Fis.empty().fisEkle(
                    fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
              } else {
                await Fis.empty()
                    .fisEkle(fis: fisEx.fis!.value, belgeTipi: localBelgeTipi);
              }

              fisEx.fis!.value = Fis.empty();
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      secondButtonText: "Tamam",
                      onSecondPress: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      pdfSimgesi: true,
                      align: TextAlign.center,
                      title: 'Kayıt Başarılı',
                      message:
                          'Fatura Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                      onPres: () async {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => PdfOnizleme(
                                    m: fiss,
                                    fastReporttanMiGelsin: false,
                                  )),
                        );
                      },
                      buttonText: 'Pdf\'i\ Gör',
                    );
                  });
            } else {
              final now = DateTime.now();
              final formatter = DateFormat('HH:mm');
              String saat = formatter.format(now);
          
              fisEx.fis!.value.DURUM = true;
              fisEx.fis!.value.AKTARILDIMI = true;
              String varsaYeniBelgeTuru = "";
              if (localBelgeTipi.isEmpty) {
                await Fis.empty().fisEkle(
                    fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
                varsaYeniBelgeTuru = widget.belgeTipi;
              } else {
                await Fis.empty()
                    .fisEkle(fis: fisEx.fis!.value, belgeTipi: localBelgeTipi);
                varsaYeniBelgeTuru = localBelgeTipi;
              }
              int tempID = fisEx.fis!.value.ID!;
              if (Fis.zorunluEkParametrelerDoluMu(
                      fisEx.fis!.value!.listFisEkParam) ==
                  true) {
                // await fisEx.listFisGetir(belgeTip: widget.belgeTipi);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LoadingSpinner(
                      color: Colors.black,
                      message: widget.belgeTipi != "Perakende_Satis"
                          ? "Online Aktarım Aktif. Belge Merkeze Gönderiliyor.."
                          : "Online Aktarım Aktif. Fiş Merkeze Gönderiliyor..",
                    );
                  },
                );
                await fisEx.listGidecekTekFisGetir(
                    belgeTip: varsaYeniBelgeTuru, fisID: tempID);

               Map<String, dynamic> jsonListesi =
                    fisEx.list_fis_gidecek[0].toJson2();

                setState(() {});
                SHataModel gelenHata = await bs.ekleFatura(
                    jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
                if (gelenHata.Hata == "true") {
                  fisEx.fis!.value.DURUM = false;
                  fisEx.fis!.value.AKTARILDIMI = false;
                  LogModel logModel = LogModel(
                    TABLOADI: "TBLFISSB",
                    FISID: fisEx.list_fis_gidecek[0].ID,
                    HATAACIKLAMA: gelenHata.HataMesaj,
                    UUID: fisEx.list_fis_gidecek[0].UUID,
                    CARIADI: fisEx.list_fis_gidecek[0].CARIADI,
                  );

                  await VeriIslemleri().logKayitEkle(logModel);
                  print("GÖNDERİM HATASI");
                  await Ctanim.showHataDialog(
                      context, gelenHata.HataMesaj.toString(),
                      ikinciGeriOlsunMu: true);
                } else {
                  fisEx.fis!.value = Fis.empty();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );

                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          pdfSimgesi: true,
                          secondButtonText: "Geri",
                          onSecondPress: () {
                            Navigator.pop(context);
                          },
                          align: TextAlign.left,
                          title: 'Başarılı',
                          message: widget.belgeTipi != "Perakende_Satis"
                              ? 'Belge merkeze başarıyla gönderildi. PDF dosyasını görmek ister misiniz ?'
                              : 'Fiş merkeze başarıyla gönderildi. PDF dosyasını görmek ister misiniz ?',
                          onPres: () async {
                            /*
                           Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          pdfForFasr())));
                                          */

                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PdfOnizleme(
                                        m: fiss,
                                        fastReporttanMiGelsin: true,
                                      )),
                            );
                          },
                          buttonText: 'Pdf\'i\ Gör',
                        );
                      });
                  setState(() {});
                  fisEx.list_fis_gidecek.clear();

                  print("ONLİNE AKRARIM AKTİF EDİLECEK");
                }
              } else {
                fisEx.fis!.value.DURUM = false;
                fisEx.fis!.value.AKTARILDIMI = false;
                showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        align: TextAlign.center,
                        title: 'Hata',
                        message: 'Faturaya ait detay bilgileri eksik.',
                        onPres: () async {
                          Navigator.pop(context);

                          setState(() {});
                        },
                        buttonText: 'Geri',
                      );
                    });
              }
            }
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.center,
                    title: 'Hata',
                    message: 'Faturanın Kalem Listesi Boş Olamaz',
                    onPres: () async {
                      Navigator.pop(context);

                      setState(() {});
                    },
                    buttonText: 'Geri',
                  );
                });
          }
        },
        label: Text("Belgeyi Kaydet"),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      locale: const Locale('tr', 'TR'),
      context: context,
      initialDate: fisEx.fis_tarihi,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}

class IslemTipi {
  int? ID;
  String? ADI;
  IslemTipi({required this.ADI, required this.ID});
}

class Satir extends StatelessWidget {
  const Satir({
    super.key,
    required this.labelText,
  });
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 70,
          padding:
              EdgeInsets.all(8.0), // İstediğiniz padding değerini belirleyin
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 245, 245),
            // Kenarlık rengini ve kalınlığını ayarlayın
            borderRadius: BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
          ),
          child: TextFormField(
            cursorColor: Color.fromARGB(255, 60, 59, 59),
            decoration: InputDecoration(
                label: Text(
                  labelText,
                  style: TextStyle(
                      color: Color.fromARGB(255, 60, 59, 59), fontSize: 15),
                ),
                border: InputBorder.none),
          )),
    );
  }
}
