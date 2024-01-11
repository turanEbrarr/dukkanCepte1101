import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilatHaraket.dart';
import 'package:dukkan_cepte/widget/cariAltHesap.dart';
import 'package:uuid/uuid.dart';

import '../controllers/tahsilatController.dart';
import '../webservis/kurModel.dart';
import '../widget/ctanim.dart';
import '../widget/veriler/listeler.dart';

class cek_senet extends StatefulWidget {
  const cek_senet({super.key, required this.uid});
  final String uid;

  @override
  State<cek_senet> createState() => _cek_senetState();
}

class _cek_senetState extends State<cek_senet> {
  TextEditingController asilSahibi = new TextEditingController();
  TextEditingController seriNo = new TextEditingController();
  TextEditingController tutar = new TextEditingController();
  TextEditingController vadeTarihi = new TextEditingController();
  TextEditingController kurController= new TextEditingController();

  final TahsilatController tahsilatEx = Get.find();
  List<String> evrak_tipi = ["ÇEK", "SENET"];
  List<KurModel> doviz = [];
  DateTime dateTime = DateTime.now();

  String? s_evrak_tipi = "ÇEK";
  KurModel? s_doviz;
  int deger = 1;
  var uuid = Uuid();
  List<CariAltHesap> althesaplar = [];
  CariAltHesap? seciliAltHesap;
  CariAltHesap? varsayilanAltHesap;

  String donusturDouble(String inText) {
    String donecekTemp = inText;
    if (donecekTemp.contains(",")) {
      String donecek = donecekTemp.replaceAll(",", ".");
      return donecek;
    } else {
      return donecekTemp;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt = DateTime.now();
    vadeTarihi.text = '${dt.year}-${dt.month}-${dt.day}';
      althesaplar.clear();
    for (var element in listeler.listCariAltHesap) {
      if (element.KOD == tahsilatEx.tahsilat!.value.CARIKOD){
        althesaplar.add(element);
        if(element.VARSAYILAN=="E"){
          varsayilanAltHesap=element;
        }
      }
    }
    if(varsayilanAltHesap != null){
      seciliAltHesap = varsayilanAltHesap;
    }else{
      seciliAltHesap = CariAltHesap(KOD: "-1", ALTHESAP: "HATA", DOVIZID: 1, VARSAYILAN: "H");
      kurController.text = "VARSAYILAN ALTHESAP BULUNAMADI İŞLEM YAPILAMAZ";
    }
      if(althesaplar.isEmpty){
      varsayilanAltHesap = CariAltHesap(KOD: "0", ALTHESAP: "HATA", DOVIZID: 1, VARSAYILAN: "H");
      s_doviz = listeler.listKur.first;
      kurController.text = s_doviz!.KUR.toString();
    }else{
         for (var element in listeler.listKur) {
      doviz.add(element);
      if (element.ID == varsayilanAltHesap!.DOVIZID) {
        s_doviz = element;
        kurController.text = s_doviz!.KUR.toString();
      }
    }

    }
 
  }

  bool asilSahibiBosMu = true;
  bool seriNoBosMu = true;
  bool tutarBosMu = true;
  bool vadeTarihiBosMu = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text("EVRAK TİPİ :",
                              style: TextStyle(fontWeight: FontWeight.w500))),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .6,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: s_evrak_tipi,
                              items: evrak_tipi
                                  .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        e,
                                      )))
                                  .toList(),
                              onChanged: ((e) => setState(() {
                                    s_evrak_tipi = e;
                                  }))),
                        ),
                      ),
                    ],
                  ),
                     Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text("ALTHESAP :",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CariAltHesap>(
                              value: seciliAltHesap,
                              items: althesaplar.map((CariAltHesap banka) {
                                return DropdownMenuItem<CariAltHesap>(
                                  value: banka,
                                  child: Text(
                                    banka.ALTHESAP ?? "-",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (CariAltHesap? selected) {
                                setState(() {
                                  seciliAltHesap = selected;
                                  for(var element in listeler.listKur){
                                    if(element.ID == seciliAltHesap!.DOVIZID){
                                      s_doviz = element;
                                      kurController.text = s_doviz!.KUR.toString();
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text("DÖVİZ :",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: 
                          Text("${s_doviz!.ACIKLAMA}"),
                          /*DropdownButtonHideUnderline(
                            child: DropdownButton<KurModel>(
                              value: s_doviz,
                              items: doviz.map((KurModel banka) {
                                return DropdownMenuItem<KurModel>(
                                  value: banka,
                                  child: Text(
                                    banka.ACIKLAMA ?? "",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (KurModel? selected) {
                                setState(() {
                                  s_doviz = selected;
                                });
                              },
                            ),
                          ),
                          */
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          
                          child: Text("KUR :",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                       SizedBox(
                        width: MediaQuery.of(context).size.width * .2,
                        height: MediaQuery.of(context).size.height * .05,
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
                                  "",
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ASIL/CİRO :",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  "ASIL",
                                  style: TextStyle(fontSize: 15),
                                ),
                                leading: Radio(
                                    value: 1,
                                    groupValue: deger,
                                    onChanged: (int? gelen) {
                                      setState(() {
                                        deger = gelen!;
                                      });
                                    }),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  "CİRO",
                                  style: TextStyle(fontSize: 15),
                                ),
                                leading: Radio(
                                    value: 2,
                                    groupValue: deger,
                                    onChanged: (int? gelen) {
                                      setState(() {
                                        deger = gelen!;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text("ASIL SAHİBİ :",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                asilSahibiBosMu = false;
                                setState(() {});
                              } else {
                                asilSahibiBosMu = true;
                                setState(() {});
                              }
                            },
                            controller: asilSahibi,
                            decoration: InputDecoration(
                                labelText: "Orn: ALİ SAHİN",
                                labelStyle: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text("SERİ NO :",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                seriNoBosMu = false;
                                setState(() {});
                              } else {
                                seriNoBosMu = true;
                                setState(() {});
                              }
                            },
                            controller: seriNo,
                            decoration: InputDecoration(
                                alignLabelWithHint: false,
                                labelText: "Orn:567348532",
                                labelStyle: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text("TUTAR :",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                tutarBosMu = false;
                                setState(() {});
                              } else {
                                tutarBosMu = true;
                                setState(() {});
                              }
                            },
                            controller: tutar,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: Text("VADE TARİHİ :",
                                style: TextStyle(fontWeight: FontWeight.w500))),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 66, 82, 97),
                            ),
                            child: Text(
                                '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
                            onPressed: () async {
                              final date = await pickDate();
                              if (date == null) return;
                              setState(() {
                                dateTime = date;
                                vadeTarihi.text =
                                    '${dateTime.year}/${dateTime.month}/${dateTime.day}';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: asilSahibiBosMu == false &&
                                seriNoBosMu == false &&
                                tutarBosMu == false
                            ? Colors.green
                            : Colors.red),
                    onPressed: () {
                      if (s_evrak_tipi == "ÇEK" &&
                          deger != 0 &&
                          asilSahibi.text != "" &&
                          seriNo.text != "" &&
                          tutar.text != "") {
                        tahsilatEx.tahsilataHareketEkle(
                          altHesap: seciliAltHesap!.ALTHESAP!,
                            dovizID: s_doviz!.ID!,
                            kasaKod: Ctanim.kullanici!.KASAKOD!,
                            ID: 22,
                            UID: widget.uid,
                            aciklama: "Acıklama yok",
                            asil: asilSahibi.text,
                            belgeNo: seriNo.text,
                            cekSeriNo: seriNo.text,
                            doviz: s_doviz!.ACIKLAMA!.toString(),
                            sozlesmeId: 0,
                            taksit: 1,
                            tip: 3,
                            tutar: double.parse(donusturDouble(tutar.text)),
                            vadeTarihi: vadeTarihi.text,
                            yeri: "Ankara",
                            kur: double.parse(donusturDouble(kurController.text)));
                        tahsilatEx.tahsilat!.value.GENELTOPLAM =
                            genelToplamHesapla();
                        Get.snackbar(
                          "Tahsilat Eklendi",
                          "${tutar.text} ${s_doviz!.ACIKLAMA} tutarında çek fişe eklendi",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(milliseconds: 1500),
                          backgroundColor: Color.fromARGB(255, 30, 38, 45),
                          colorText: Colors.white,
                        );
                        asilSahibi.text = "";
                        seriNo.text = "";
                        tutar.text = "";
                      } else if (s_evrak_tipi == "SENET" &&
                          deger != 0 &&
                          asilSahibi.text != "" &&
                          seriNo.text != "" &&
                          tutar.text != "") {
                        tahsilatEx.tahsilataHareketEkle(
                           altHesap: seciliAltHesap!.ALTHESAP!,
                            dovizID: s_doviz!.ID!,
                            kasaKod: Ctanim.kullanici!.KASAKOD!,
                            ID: 22,
                            UID: widget.uid,
                            aciklama: "Acıklama yok",
                            asil: asilSahibi.text,
                            belgeNo: seriNo.text,
                            cekSeriNo: seriNo.text,
                            doviz: s_doviz!.ACIKLAMA!.toString(),
                            sozlesmeId: 0,
                            taksit: 1,
                            tip: 4,
                            tutar: double.parse(donusturDouble(tutar.text)),
                            vadeTarihi: vadeTarihi.text,
                            yeri: "Ankara",
                            kur: double.parse(donusturDouble(kurController.text)));
                        tahsilatEx.tahsilat!.value.GENELTOPLAM =
                            genelToplamHesapla();
                        Get.snackbar(
                          "Tahsilat Eklendi",
                          "${tutar.text} ${s_doviz!.ACIKLAMA} tutarında senet fişe eklendi",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(milliseconds: 1500),
                          backgroundColor: Color.fromARGB(255, 30, 38, 45),
                          colorText: Colors.white,
                        );
                        asilSahibi.text = "";
                        seriNo.text = "";
                        tutar.text = "";
                      } else {
                        showAlertDialog(context,
                            "Çek-Senet Tahsilatında Bütün Alanların Doldurulması Zorunludur");
                      }
                      asilSahibiBosMu = true;
                      seriNoBosMu = true;
                      tutarBosMu = true;
                      setState(() {});
                    },
                    child: Text("Ödeme Listesine Ekle")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String mesaj) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hatalı İşlem!"),
      content: Text(mesaj),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<DateTime?> pickDate() => showDatePicker(
      locale: const Locale('tr', 'TR'),
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  double genelToplamHesapla() {
    double genelToplam = 0.0;
    for (var element in tahsilatEx.tahsilat!.value.tahsilatHareket) {
      genelToplam += element.TUTAR!;
    }
    return genelToplam;
  }
}
