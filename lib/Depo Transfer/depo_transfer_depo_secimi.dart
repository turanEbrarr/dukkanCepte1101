import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/fisController.dart';
import '../faturaFis/fis.dart';
import '../widget/appbar.dart';
import '../widget/ctanim.dart';
import 'depo_transfer_tab_page.dart';
import '../Depo Transfer/subeDepoModel.dart';

class depo_transfer_depo_secimi extends StatefulWidget {
  const depo_transfer_depo_secimi({Key? key});

  @override
  State<depo_transfer_depo_secimi> createState() =>
      _depo_transfer_depo_secimiState();
}

class _depo_transfer_depo_secimiState extends State<depo_transfer_depo_secimi> {
  String? selectedNeredenSube;
  String? selectedNeredenDepo;

  int? selectedNeredenSubeID = -1;
  int? selectedNeredenDepoID = -1;

  String? selectedNereyeSube;
  String? selectedNereyeDepo;

  int? selectedNereyeSubeID = -1;
  int? selectedNereyeDepoID = -1;

  String aciklama = "";
  var uuid = Uuid();
  Color favIconColor = Colors.black;
  FisController fisEx = Get.find();
  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  List<SubeDepoModel> neredenDepolar = [];
  List<SubeDepoModel> nereyeDepolar = [];
  // Map<String, int> tempdepolar = {};
  List<SubeDepoModel> subeler = [];
  List<SubeDepoModel> gidecekSubeler = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
      if (!gidecekSubeler
          .map((sube) => sube.SUBEADI ?? "")
          .toList()
          .contains(listeler.listSubeDepoModel[i].SUBEADI)) {
        gidecekSubeler.add(listeler.listSubeDepoModel[i]);
      }
      //depolar[element.DEPOADI!] = element.DEPOID!;
      if (!subeler
              .map((sube) => sube.SUBEADI ?? "")
              .toList()
              .contains(listeler.listSubeDepoModel[i].SUBEADI) ) {
        subeler.add(listeler.listSubeDepoModel[i]);
      }
      selectedNeredenSube = subeler.first.SUBEADI;
      selectedNeredenSubeID = subeler.first.SUBEID;
    }
    for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
      if (listeler.listSubeDepoModel[i].SUBEADI == selectedNeredenSube) {
        if (!neredenDepolar
            .map((depo) => depo.DEPOADI ?? "")
            .toList()
            .contains(listeler.listSubeDepoModel[i].DEPOADI)) {
          neredenDepolar.add(listeler.listSubeDepoModel[i]);
        }
      }
    }
    selectedNeredenDepo = neredenDepolar.first.DEPOADI ?? "";
    selectedNeredenDepoID = neredenDepolar.first.DEPOID ?? -1;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // fisEx.fis!.value.CARIKOD = "100";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Depo Seçimi"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDropdown(
                  'Gönderici Şube',
                  selectedNeredenSube,
                  subeler.map((sube) => sube.SUBEADI ?? "").toList(),
                  (String? val) {},
                  degismeKapali: true),
              SizedBox(height: 10),
              buildDropdown('Gönderici Depo', selectedNeredenDepo,
                  neredenDepolar.map((depo) => depo.DEPOADI ?? "").toList(),
                  (String? value) {
                for (var element in neredenDepolar) {
                  if (element.DEPOADI == value) {
                    selectedNeredenDepoID = element.DEPOID;
                  }
                }
                setState(() {
                  selectedNeredenDepo = value;
                });
              }),
              SizedBox(height: 10),
              Icon(Icons.arrow_circle_down_rounded),
              SizedBox(height: 10),
              buildDropdown('Alıcı Şube', selectedNereyeSube,
                  gidecekSubeler.map((sube) => sube.SUBEADI ?? "").toList(),
                  (String? value) {
                nereyeDepolar.clear();
                for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
                  if (listeler.listSubeDepoModel[i].SUBEADI == value) {
                    if (!nereyeDepolar
                            .map((depo) => depo.DEPOADI ?? "")
                            .toList()
                            .contains(listeler.listSubeDepoModel[i].DEPOADI) ) {
                      nereyeDepolar.add(listeler.listSubeDepoModel[i]);
                    }
                  }
                }
                for (var element in subeler) {
                  if (element.SUBEADI == value) {
                    selectedNereyeSubeID = element.SUBEID;
                  }
                }

                setState(() {
                  selectedNereyeSube = value;
                  selectedNereyeDepo =
                      null; // üsttekiine göre alttakini değiştirmek istersen yapacağın bu!
                });
              }),
              SizedBox(height: 10),
              buildDropdown('Alıcı Depo', selectedNereyeDepo,
                  nereyeDepolar.map((depo) => depo.DEPOADI ?? "").toList(),
                  (String? value) {
                for (var element in nereyeDepolar) {
                  if (element.DEPOADI == value) {
                    selectedNereyeDepoID = element.DEPOID;
                  }
                }
                setState(() {
                  selectedNereyeDepo = value;
                });
              }),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      aciklama = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Açıklama",
                    hintText: "Açıklama Giriniz",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () {
                  if (selectedNeredenDepoID != selectedNereyeDepoID) {
                    if (selectedNereyeDepoID != -1 &&
                        selectedNereyeSubeID != -1 &&
                        selectedNeredenDepoID != -1 &&
                        selectedNeredenSubeID != -1) {
                      String dovizAdi = "";
                      int dovizID = 0;
                      double dovizKur = 0.0;
                      for (var element in listeler.listKur) {
                        if (element.ANABIRIM == "E") {
                          dovizAdi = element.ACIKLAMA!;
                          dovizID = element.ID!;
                          dovizKur = element.KUR!;
                        }
                      }

                      fisEx.fis?.value = Fis.empty();
                      fisEx.fis?.value.ACIKLAMA1 = aciklama;
                      fisEx.fis?.value.ISLEMTIPI = "0";
                      fisEx.fis?.value.VADEGUNU = "0";
                      fisEx.fis!.value.GIDENDEPOID =
                          selectedNereyeDepoID; // gidecek depo
                      fisEx.fis!.value.GIDENSUBEID = selectedNereyeSubeID!;
                      fisEx.fis!.value.UUID = uuid.v1().toString();
                      fisEx.fis!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
                      fisEx.fis!.value.DOVIZID = dovizID;
                      fisEx.fis!.value.DOVIZ = dovizAdi;
                      fisEx.fis!.value.KUR = dovizKur;
                      fisEx.fis!.value.ONAY = "E";
                      
                      fisEx.fis!.value.DEPOID = int.parse(selectedNeredenDepoID
                          .toString()); // ana depo // nereden alko
                      fisEx.fis!.value.SUBEID =
                       1;
                      Get.to(() => depo_transfer_tab_page(
                            belgeTipi: 'Depo_Transfer',
                            fis_id: fisEx.fis!.value.ID!,
                          ));
                    } else {
                      showAlertDialog(context,
                          "Depo Transfer İşleminde Şube ve Depo Seçimi Zorunludur!");
                    }
                  } else {
                    showAlertDialog(context,
                        "Depo Transfer İşleminde Giden ve Gelen Depo Aynı Olamaz");
                  }
                },
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String? selectedValue, List<String> items,
      void Function(String?) onChanged,
      {bool degismeKapali = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: degismeKapali == false ? onChanged : null,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
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
}
