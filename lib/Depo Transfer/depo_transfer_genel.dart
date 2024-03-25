import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dukkan_cepte/Depo%20Transfer/depo_transfer_pdf_onizleme.dart';
import 'package:dukkan_cepte/Depo%20Transfer/subeDepoModel.dart';
import '../faturaFis/fis.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../webservis/base.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/main_page.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import '../controllers/fisController.dart';

class depo_transfer_genel extends StatefulWidget {
  const depo_transfer_genel({super.key});

  @override
  State<depo_transfer_genel> createState() => _depo_transfer_genelState();
}

class _depo_transfer_genelState extends State<depo_transfer_genel> {
  BaseService bs = BaseService();
  String? selectedNereden;
  String? selectedNereye;
  int? selectedSubeID = -1;
  int? selectedDepoID = -1;

  Color favIconColor = Colors.black;
  FisController fisEx = Get.find();
  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  List<SubeDepoModel> depolar = [];
  // Map<String, int> tempdepolar = {};
  List<SubeDepoModel> subeler = [];
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < listeler.listSubeDepoModel.length; i++) {
      if (listeler.listSubeDepoModel[i].SUBEID ==
          fisEx.fis!.value.GIDENSUBEID) {
        selectedNereden = listeler.listSubeDepoModel[i].SUBEADI;
      }
      if (listeler.listSubeDepoModel[i].DEPOID ==
          fisEx.fis!.value.GIDENDEPOID) {
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
              .contains(listeler.listSubeDepoModel[i].DEPOADI) &&
          listeler.listSubeDepoModel[i].DEPOID !=
              int.parse(Ctanim.kullanici!.YERELDEPOID.toString())) {
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
          if (selectedNereye == null || selectedNereden == null) {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.center,
                    title: 'Hata',
                    message: 'Depo Seçimi Zorunludur.',
                    onPres: () async {
                      Navigator.pop(context);

                      setState(() {});
                    },
                    buttonText: 'Geri',
                  );
                });
          } else {
            if (fisEx.fis!.value.fisStokListesi.length != 0) {
              fisEx.fis!.value.BELGENO =
                  Ctanim.depolarArasiTransfer.toString();
              fisEx.fis!.value.BELGENO = Ctanim.depolarArasiTransfer.toString();
              Ctanim.depolarArasiTransfer = Ctanim.depolarArasiTransfer + 1;
              await SharedPrefsHelper.depoTransferNumKaydet(
                  Ctanim.depolarArasiTransfer);
              Fis fiss = fisEx.fis!.value;
              if (Ctanim.kullanici!.ISLEMAKTARILSIN == "E") {
                fisEx.fis!.value.DURUM = true;
             
                fisEx.fis!.value.KDVDAHIL = "H";
                await Fis.empty()
                    .fisEkle(fis: fisEx.fis!.value, belgeTipi: "Depo_Transfer");
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
                            'Transfer Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                        onPres: () async {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    DepoTransferPdfOnizleme(m: fiss)),
                          );
                        },
                        buttonText: 'Pdf\'i\ Gör',
                      );
                    });
              } else {
                fisEx.fis!.value.DURUM = true;
                fisEx.fis!.value.AKTARILDIMI = true;
            
                fisEx.fis!.value.KDVDAHIL = "H";
                await Fis.empty()
                    .fisEkle(fis: fisEx.fis!.value, belgeTipi: "Depo_Transfer");
                int tempID = fisEx.fis!.value.ID!;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LoadingSpinner(
                      color: Colors.black,
                      message:
                          "Online Aktarım Aktif. Transfer Merkeze Gönderiliyor..",
                    );
                  },
                );
                await fisEx.listGidecekTekFisGetir(
                    belgeTip: "Depo_Transfer", fisID: tempID);

                Map<String, dynamic> jsonListesi =
                    fisEx.list_fis_gidecek[0].toJson2();
                print(jsonListesi);

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

                  // Hata diyalogunu göstermek için yeni methodu çağırıyoruz.
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
                          message:
                              'Transfer merkeze başarıyla gönderildi. PDF dosyasını görmek ister misiniz ?',
                          onPres: () async {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DepoTransferPdfOnizleme(m: fiss)),
                            );
                          },
                          buttonText: 'Transferi Gör',
                        );
                      });
                  setState(() {});
                  fisEx.list_fis_gidecek.clear();
                }
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      align: TextAlign.center,
                      title: 'Hata',
                      message: 'Transferin Kalem Listesi Boş Olamaz',
                      onPres: () async {
                        Navigator.pop(context);

                        setState(() {});
                      },
                      buttonText: 'Geri',
                    );
                  });
            }
          }
        },
        label: Text("Transferi Kaydet"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: buildDropdown('Gönderilecek Şube', selectedNereden,
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
                              .contains(
                                  listeler.listSubeDepoModel[i].DEPOADI) &&
                          listeler.listSubeDepoModel[i].DEPOID !=
                              int.parse(
                                  Ctanim.kullanici!.YERELDEPOID.toString())) {
                        depolar.add(listeler.listSubeDepoModel[i]);
                      }
                    }
                  }
                }

                for (var element in subeler) {
                  if (element.SUBEADI == value) {
                    selectedSubeID = element.SUBEID;
                  }
                }

                setState(() {
                  selectedNereden = value;
                  selectedNereye =
                      null; // üsttekiine göre alttakini değiştirmek istersen yapacağın bu!
                });
                fisEx.fis!.value.GIDENSUBEID = selectedSubeID!;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: buildDropdown('Gönderilecek Depo', selectedNereye,
                  depolar.map((depo) => depo.DEPOADI ?? "").toList(),
                  (String? value) {
                for (var element in depolar) {
                  if (element.DEPOADI == value) {
                    selectedDepoID = element.DEPOID;
                  }
                }
                setState(() {
                  selectedNereye = value;
                });
                fisEx.fis!.value.GIDENDEPOID = selectedDepoID;
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
