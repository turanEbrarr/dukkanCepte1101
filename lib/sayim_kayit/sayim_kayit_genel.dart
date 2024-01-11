import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dukkan_cepte/Depo%20Transfer/subeDepoModel.dart';
import 'package:dukkan_cepte/controllers/depoController.dart';
import '../Depo Transfer/depo.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../webservis/base.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/main_page.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/veriler/listeler.dart';
import '../controllers/fisController.dart';

class sayim_kayit_son_bakis extends StatefulWidget {
  const sayim_kayit_son_bakis({super.key});

  @override
  State<sayim_kayit_son_bakis> createState() => _sayim_kayit_son_bakisState();
}

class _sayim_kayit_son_bakisState extends State<sayim_kayit_son_bakis> {
  String? selectedNereden;
  String? selectedNereye;
  int? selectedNeredenID = -1;
  int? selectedNereyeID = -1;
  BaseService bs = BaseService();

  Color favIconColor = Colors.black;

  //FisController fisEx = Get.find();
  SayimController fisEx = Get.find();
  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  List<SubeDepoModel> depolar = [];
  // Map<String, int> tempdepolar = {};
  List<SubeDepoModel> subeler = [];
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
      if (listeler.listSubeDepoModel[i].SUBEID == fisEx.sayim!.value.SUBEID) {
        selectedNereden = listeler.listSubeDepoModel[i].SUBEADI;
      }
      if (listeler.listSubeDepoModel[i].DEPOID == fisEx.sayim!.value.DEPOID) {
        selectedNereye = listeler.listSubeDepoModel[i].DEPOADI;
      }
      //depolar[element.DEPOADI!] = element.DEPOID!;
      if (!subeler
          .map((sube) => sube.SUBEADI ?? "")
          .toList()
          .contains(listeler.listSubeDepoModel[i].SUBEADI)) {
        subeler.add(listeler.listSubeDepoModel[i]);
      }
      if (!depolar
          .map((depo) => depo.DEPOADI ?? "")
          .toList()
          .contains(listeler.listSubeDepoModel[i].DEPOADI)) {
        depolar.add(listeler.listSubeDepoModel[i]);
      }
    }
  }

  int flag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () async {
          if (fisEx.sayim!.value.sayimStokListesi.length != 0) {
            if (Ctanim.kullanici!.ISLEMAKTARILSIN == "H") {
              fisEx.sayim!.value.DURUM = true;
              await Sayim.empty().sayimEkle(
                sayim: fisEx.sayim!.value,
              );
              // fisEx.sayim!.value = Sayim.empty();

              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      align: TextAlign.center,
                      title: 'Kayıt Başarılı',
                      message: 'Sayım Kaydedildi.',
                      onPres: () async {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      buttonText: 'Tamam',
                    );
                  });
            } else {
              fisEx.sayim!.value.DURUM = true;
              fisEx.sayim!.value.AKTARILDIMI = true;
              await Sayim.empty().sayimEkle(
                sayim: fisEx.sayim!.value,
              );
              int tempID = fisEx.sayim!.value.ID!;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingSpinner(
                    color: Colors.black,
                    message:
                        "Online Aktarım Aktif. Sayım Merkeze Gönderiliyor..",
                  );
                },
              );
              await fisEx.listGidecekTekDepoGetir(sayimID: tempID);

              Map<String, dynamic> jsonListesi =
                  fisEx.list_gidecek_Depo[0].toJson2();

              setState(() {});
              SHataModel gelenHata = await bs.ekleSayim(
                  jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
              if (gelenHata.Hata == "true") {
                fisEx.sayim!.value.DURUM = false;
                fisEx.sayim!.value.AKTARILDIMI = false;
                LogModel logModel = LogModel(
                  TABLOADI: "TBLSAYIMSB",
                  FISID: fisEx.list_gidecek_Depo[0].ID,
                  HATAACIKLAMA: gelenHata.HataMesaj,
                  UUID: fisEx.list_gidecek_Depo[0].UUID,
                  CARIADI: fisEx.list_gidecek_Depo[0].ACIKLAMA,
                );

                await VeriIslemleri().logKayitEkle(logModel);
                print("GÖNDERİM HATASI");

                // Hata diyalogunu göstermek için yeni methodu çağırıyoruz.
                await Ctanim.showHataDialog(
                    context, gelenHata.HataMesaj.toString(),
                    ikinciGeriOlsunMu: true);
              } else {
                //fisEx.sayim!.value = Sayim.empty();
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
                        align: TextAlign.left,
                        title: 'Başarılı',
                        message: 'Sayım merkeze başarıyla gönderildi.',
                        onPres: () async {
                          Navigator.pop(context);
                        },
                        buttonText: 'Tamam',
                      );
                    });
                setState(() {});
                fisEx.list_gidecek_Depo.clear();

                print("ONLİNE AKRARIM AKTİF EDİLECEK");
              }
            }
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.center,
                    title: 'Hata',
                    message: 'Sayımın Kalem Listesi Boş Olamaz',
                    onPres: () async {
                      Navigator.pop(context);

                      setState(() {});
                    },
                    buttonText: 'Geri',
                  );
                });
          }
        },
        label: Text("Sayımı Kaydet"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: buildDropdown('Şube', selectedNereden,
                  subeler.map((sube) => sube.SUBEADI ?? "").toList(),
                  (String? value) {
                flag = 1;
                if (flag == 1) {
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
                fisEx.sayim!.value.SUBEID = selectedNeredenID!;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: buildDropdown('Depo', selectedNereye,
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
                fisEx.sayim!.value.DEPOID = selectedNereyeID;
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    void Function(String?) onChanged,
  ) {
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
}
