import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:dukkan_cepte/Depo%20Transfer/depo.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_kayit_tab_page.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/depoController.dart';

import '../faturaFis/fis.dart';
import '../widget/appbar.dart';

import '../Depo Transfer/subeDepoModel.dart';

class sayim_kayit_depo_secimi extends StatefulWidget {
  const sayim_kayit_depo_secimi({Key? key});

  @override
  State<sayim_kayit_depo_secimi> createState() =>
      _sayim_kayit_depo_secimiState();
}

class _sayim_kayit_depo_secimiState extends State<sayim_kayit_depo_secimi> {
  Future<DateTime?> pickDate() => showDatePicker(
        //locale: const Locale('tr','TR'),
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
  String? aciklama;
  String? selectedNereden;
  String? selectedNereye;
  int? selectedNeredenID = -1;
  int? selectedNereyeID = -1;
  DateTime dateTime = DateTime.now();
  var uuid = Uuid();
  Color favIconColor = Colors.black;
  SayimController fisEx = Get.find();
  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  List<SubeDepoModel> depolar = [];
  // Map<String, int> tempdepolar = {};
  List<SubeDepoModel> subeler = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
           if(int.parse(Ctanim.kullanici!.YERELDEPOID!)==listeler.listSubeDepoModel[i].DEPOID){
        selectedNereye=listeler.listSubeDepoModel[i].DEPOADI;
        selectedNereyeID=listeler.listSubeDepoModel[i].DEPOID;
      }
      if(int.parse(Ctanim.kullanici!.YERELSUBEID!)==listeler.listSubeDepoModel[i].SUBEID){
        selectedNereden=listeler.listSubeDepoModel[i].SUBEADI;
        selectedNeredenID=listeler.listSubeDepoModel[i].SUBEID;

        if (!depolar
          .map((depo) => depo.DEPOADI ?? "")
          .toList()
          .contains(listeler.listSubeDepoModel[i].DEPOADI) && listeler.listSubeDepoModel[i].SUBEID==selectedNeredenID) {
        depolar.add(listeler.listSubeDepoModel[i]);
      }

      }
 
      if (!subeler
          .map((sube) => sube.SUBEADI ?? "")
          .toList()
          .contains(listeler.listSubeDepoModel[i].SUBEADI)) {
        subeler.add(listeler.listSubeDepoModel[i]);
      }
    }
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
      appBar: MyAppBar(height: 50, title: "Sayım Kayıt Fişi Detayları"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: buildDropdown('Şube', selectedNereden,
                  subeler.map((sube) => sube.SUBEADI ?? "").toList(),
                  (String? value) {
                depolar.clear();
                for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
                  if (listeler.listSubeDepoModel[i].SUBEADI == value) {
                    if (!depolar
                        .map((depo) => depo.DEPOADI ?? "")
                        .toList()
                        .contains(listeler.listSubeDepoModel[i].DEPOADI)) {
                      depolar.add(listeler.listSubeDepoModel[i]);
                    }
                  }
                }
                for (var element in subeler) {
                  if (element.SUBEADI == value) {
                    selectedNeredenID = element.SUBEID;
                  }
                }

                setState(() {
                  selectedNereden = value;
                  selectedNereye =
                      null; // üsttekiine göre alttakini değiştirmek istersen yapacağın bu!
                });
              }),
            ),
            SizedBox(height: 10),
            buildDropdown('Depo', selectedNereye,
                depolar.map((depo) => depo.DEPOADI ?? "").toList(),
                (String? value) {
              for (var element in depolar) {
                if (element.DEPOADI == value) {
                  selectedNereyeID = element.DEPOID;
                }
              }
              setState(() {
                selectedNereye = value;
              });
            }),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "Tarih Seçiniz: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        child: Text(
                          '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                        ),
                        onPressed: () async {
                          final date = await pickDate();
                          if (date == null) return;
                          setState(() {
                            dateTime = date;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                print(selectedNereden);

                if (selectedNeredenID != -1 && selectedNereyeID != -1) {
                 // fisEx.sayim?.value = Sayim.empty();

                  fisEx.sayim!.value.DEPOID = selectedNereyeID; // gidecek depo
                  fisEx.sayim!.value.SUBEID = selectedNeredenID!;
                  fisEx.sayim!.value.UUID = uuid.v1().toString();
                  fisEx.sayim!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;

                  fisEx.sayim!.value.ACIKLAMA = aciklama??"";
                  fisEx.sayim!.value.ONAY = "E";
                  fisEx.sayim!.value.TARIH =
                      DateFormat("yyyy-MM-dd").format(DateTime.now());
                  print(fisEx.sayim!.value.ID);

                  print(fisEx.sayim!.value.DEPOID);
                  print(fisEx.sayim!.value.SUBEID);
                  print(fisEx.sayim!.value.TARIH);
                  print(fisEx.sayim!.value.ACIKLAMA);
                  print(fisEx.sayim!.value.UUID);

                  Get.to(() => sayim_kayit_tab_page(
                        fis_id: fisEx.sayim!.value.ID!,
                      ));
                } else {
                  showAlertDialog(context,
                      "Depo Transfer İşleminde Şube ve Depo Seçimi Zorunludur!");
                }
              },
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(String label, String? selectedValue, List<String> items,
      void Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
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
