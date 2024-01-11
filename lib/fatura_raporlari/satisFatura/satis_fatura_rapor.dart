import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/cari_raporlari/pdf/cari_rapor_pdf_onizleme.dart';
import 'package:dukkan_cepte/fatura_raporlari/faturalar_pdf_onizleme.dart';
import 'package:dukkan_cepte/fatura_raporlari/satisFatura/satis_fatura_rapor_detay.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';

import '../../stok_kart/Spinkit.dart';
import '../../widget/cari.dart';
import '../../widget/customAlertDialog.dart';
import '../../widget/modeller/sharedPreferences.dart';

class satis_fatura_rapor_page extends StatefulWidget {
  final List<List<dynamic>> gelenBakiyeRapor;
  final List<bool> gelenFiltre;
  final Cari? cariKart;
  //final String titletemp;
  const satis_fatura_rapor_page(
      {super.key,
      required this.gelenBakiyeRapor,
      required this.gelenFiltre,
      required this.cariKart});

  @override
  State<satis_fatura_rapor_page> createState() =>
      _satis_fatura_rapor_pageState();
}

class _satis_fatura_rapor_pageState extends State<satis_fatura_rapor_page> {
  BaseService bs = BaseService();
  List<String> bakiyeRaporSatirlar = [];
  List<DataColumn> bakiyeRaporKolonlar = [];
  List<String> aramaliBakiyeRaporSatirlar = [];
  List<String> kolonIsimleri = [];
  List<DataColumn> filtreliBakiyeRaporKolonlar = [];

  List<DataRow> satirOlustur({
    required List<DataColumn> gelenDurumKolonlar,
    required List<String> gelenDurumSatirlar,
  }) {
    int genelcolsayisi = widget.gelenBakiyeRapor[1].length;
    int fark = widget.gelenBakiyeRapor[1].length - gelenDurumKolonlar.length;
    int enSonEklenen = 0;
    List<DataRow> donecek = [];
    for (int i = 0; i < gelenDurumSatirlar.length / genelcolsayisi; i++) {
      List<DataCell> donecekDataCell = [];

      int deneme = 0;
      for (DataColumn element in widget.gelenBakiyeRapor[1]) {
        if (element.label is Text) {
          String labelText = (element.label as Text).data ?? '';
          for (DataColumn element1 in gelenDurumKolonlar) {
            String labelText1 = (element1.label as Text).data ?? '';
            if (labelText == labelText1) {
              DataCell newValue = DataCell(Text(
                gelenDurumSatirlar[enSonEklenen],
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: deneme == 0 ? Colors.transparent : Colors.black),
              ));

              donecekDataCell.add(newValue);
            }
          }
        }
        enSonEklenen++;
        deneme++;
      }

      DataRow dataRowWithInkWell = DataRow(
        cells: donecekDataCell,
        onLongPress: () async {
          String fatID = (donecekDataCell[0].child as Text).data!;
          print("Satıra tıklandı: ${(donecekDataCell[0].child as Text).data}");
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingSpinner(
                color: Colors.black,
                message: "Satış Fatura Detayları Hazırlanıyor...",
              );
            },
          );

          List<bool> cek =
              await SharedPrefsHelper.filtreCek("satisFaturaRaporuDetayFiltre");
          List<List<dynamic>> gelen = await bs.getirFaturaDetayRapor(
              sirket: Ctanim.sirket!,
              faturaID: (donecekDataCell[0].child as Text).data!);

          if (gelen[0].length == 1 && gelen[1].length == 0) {
            await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  align: TextAlign.left,
                  title: gelen[0][0] == "Veri Bulunamadı"
                      ? "Kayıtlı Belge Yok"
                      : "Hata",
                  message: gelen[0][0] == "Veri Bulunamadı"
                      ? 'İstenilen Belge Mevcut Değil'
                      : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                          gelen[0][0],
                  onPres: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  buttonText: 'Geri',
                );
              },
            );
          } else {
            // gelenlerden colon kaldırıldıysa veya eklendiyse favorileri temizle
            if (gelen[1].length != cek.length) {
              cek.clear();
              for (var i = 0; i < gelen[1].length; i++) {
                cek.add(true);
              }
            }
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => satis_fatura_detay_rapor_page(
                      gelenFiltre: cek,
                      gelenBakiyeRapor: gelen,
                      carikart: widget.cariKart,
                      faturaID: fatID,
                    )),
              ),
            );
          }
        },
      );

      donecek.add(dataRowWithInkWell);
    }

    return donecek;
  }

  List<List<String>> satirOlusturforPDF(
      {required List<DataColumn> gelenDurumKolonlar,
      required List<String> gelenDurumSatirlar}) {
    int genelcolsayisi = widget.gelenBakiyeRapor[1].length;
    int fark = widget.gelenBakiyeRapor[1].length - gelenDurumKolonlar.length;
    int enSonEklenen = 0;
    List<List<String>> donecek = [];
    for (int i = 0; i < gelenDurumSatirlar.length / genelcolsayisi; i++) {
      List<String> donecekDataCell = [];

      for (DataColumn element in widget.gelenBakiyeRapor[1]) {
        if (element.label is Text) {
          String labelText = (element.label as Text).data ?? '';
          for (DataColumn element1 in gelenDurumKolonlar) {
            String labelText1 = (element1.label as Text).data ?? '';
            if (labelText == labelText1) {
              donecekDataCell.add(gelenDurumSatirlar[enSonEklenen]);
            }
          }
        }
        enSonEklenen++;
      }

      donecek.add(donecekDataCell);
    }

    return donecek;
  }

  bool veriVarmi = false;

  List<bool> secilenKolonlar = [];

  List<bool> secilenKolonlarIlk = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secilenKolonlar.addAll(widget.gelenFiltre);
    for (int i = 0;
        i < widget.gelenBakiyeRapor[0].length;
        i = i + widget.gelenBakiyeRapor[1].length) {
      for (int j = 0; j < widget.gelenBakiyeRapor[1].length; j++) {
        bakiyeRaporSatirlar.add(widget.gelenBakiyeRapor[0][i + j]);
      }
    }
    for (DataColumn element in widget.gelenBakiyeRapor[1]) {
      bakiyeRaporKolonlar.add(element);
      secilenKolonlarIlk.add(true);
      if (element.label is Text) {
        String labelText = (element.label as Text).data ?? '';
        kolonIsimleri.add(labelText);
      } else {
        kolonIsimleri.add('');
      }
    }

    if (secilenKolonlar.isEmpty) {
      filtreliBakiyeRaporKolonlar.addAll(bakiyeRaporKolonlar);
      secilenKolonlar.addAll(secilenKolonlarIlk);
    } else {
      for (int i = 0; i < secilenKolonlar.length; i++) {
        if (secilenKolonlar[i] == true) {
          filtreliBakiyeRaporKolonlar
              .add(DataColumn(label: Text(kolonIsimleri[i])));
        }
      }
    }

    // filtreliBakiyeRaporKolonlar.addAll(bakiyeRaporKolonlar);

    aramaliBakiyeRaporSatirlar.addAll(bakiyeRaporSatirlar);
  }

  bool ustfiltre = false;
  String aramaTerimi = '';
  String basTar = "";
  String bitTar = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Icon(Icons.picture_as_pdf),
        onPressed: () {
          List<String> sj = [];
          for (var element in filtreliBakiyeRaporKolonlar) {
            sj.add((element.label as Text).data ?? '');
          }
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => faturalarPdfOnizleme(
                      baslik: "Satış Faturası Listesi",
                      kolonlar: sj,
                      satirlar: satirOlusturforPDF(
                          gelenDurumKolonlar: filtreliBakiyeRaporKolonlar,
                          gelenDurumSatirlar: aramaliBakiyeRaporSatirlar),
                      caraiKart: widget.cariKart,
                      faturaID: "-",
                    )),
          );
        },
      ),
      appBar: MyAppBar(
        height: 50,
        title: 'Satış Fatura Raporu',
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          String date = await Ctanim.pickDate(context);
                          if (date == "") return;
                          setState(() {
                            basTar = date;
                            print(basTar);
                          });
                        },
                        child: Text(
                            basTar != "" ? basTar : "Başlangıç Tarihi Seçiniz"),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          String date = await Ctanim.pickDate(context);
                          if (date == "") return;
                          setState(() async {
                            bitTar = date;
                            print(bitTar);
                            print("bitti ara");

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return LoadingSpinner(
                                  color: Colors.black,
                                  message:
                                      "Satış Fatura Raporu Hazırlanıyor...",
                                );
                              },
                            );

                            List<bool> cek = await SharedPrefsHelper.filtreCek(
                                "raporSatisFatura");
                            List<List<dynamic>> gelen =
                                await bs.getirSatisFaturaRapor(
                              sirket: Ctanim.sirket!,
                              cariKodu: widget.cariKart!.KOD!,
                              basTar: basTar,
                              bitTar: bitTar,
                            );

                            if (gelen[0].length == 1 && gelen[1].length == 0) {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: gelen[0][0] == "Veri Bulunamadı"
                                        ? 'Kayıtlı Belge Yok'
                                        : "Hata",
                                    message: gelen[0][0] == "Veri Bulunamadı"
                                        ? 'İstenilen Belge Mevcut Değil'
                                        : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                            gelen[0][0],
                                    onPres: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Geri',
                                  );
                                },
                              );
                            } else {
                              // gelenlerden colon kaldırıldıysa veya eklendiyse favorileri temizle
                              if (gelen[1].length != cek.length) {
                                cek.clear();
                                for (var i = 0; i < gelen[1].length; i++) {
                                  cek.add(true);
                                }
                              }
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        satis_fatura_rapor_page(
                                          gelenFiltre: cek,
                                          gelenBakiyeRapor: gelen,
                                          cariKart: widget.cariKart,
                                        )),
                              );
                            }
                          });
                        },
                        child: Text(
                            bitTar != "" ? bitTar : "Bitiş Tarihi Seçiniz"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Aranacak kelime(Kod/Cari Adı)",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      iconColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        aramaTerimi = value;
                        if (aramaTerimi != "") {
                          aramaliBakiyeRaporSatirlar.clear();
                          for (int i = 0;
                              i < bakiyeRaporSatirlar.length;
                              i = i + bakiyeRaporKolonlar.length) {
                            if (bakiyeRaporSatirlar[i + 1]
                                .toLowerCase()
                                .contains(aramaTerimi.toLowerCase())) {
                              int kacDefaArtacak = 0;
                              while (
                                  kacDefaArtacak < bakiyeRaporKolonlar.length) {
                                aramaliBakiyeRaporSatirlar.add(
                                    bakiyeRaporSatirlar[i + kacDefaArtacak]);
                                kacDefaArtacak++;
                              }
                            } else if (bakiyeRaporSatirlar[i + 6]
                                .contains(aramaTerimi)) {
                              int kacDefaArtacak = 0;
                              while (
                                  kacDefaArtacak < bakiyeRaporKolonlar.length) {
                                aramaliBakiyeRaporSatirlar.add(
                                    bakiyeRaporSatirlar[i + kacDefaArtacak]);
                                kacDefaArtacak++;
                              }
                            }
                          }
                        } else {
                          aramaliBakiyeRaporSatirlar.clear();
                          aramaliBakiyeRaporSatirlar
                              .addAll(bakiyeRaporSatirlar);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        ustfiltre = !ustfiltre;
                      });
                    },
                    icon:
                        Image.asset("images/slider.png", height: 60, width: 60),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "Fatura Detayını Görmek İçin Faturaya Uzun Basınız",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ustfiltre == true
              ? Container(
                  height: MediaQuery.of(context).size.height * .4,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: kolonIsimleri.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(kolonIsimleri[index]),
                              value: secilenKolonlar[index],
                              onChanged: (newValue) {
                                setState(() {
                                  secilenKolonlar[index] = newValue ?? false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            filtreliBakiyeRaporKolonlar.clear();
                            for (int i = 0; i < secilenKolonlar.length; i++) {
                              if (secilenKolonlar[i] == true) {
                                filtreliBakiyeRaporKolonlar.add(
                                    DataColumn(label: Text(kolonIsimleri[i])));
                              }
                            }

                            setState(() {});
                            await SharedPrefsHelper.filtreKaydet(
                                secilenKolonlar, "raporSatisFatura");
                            ustfiltre = false;
                            setState(() {});
                          },
                          child: Text("Filtreyi Uygula"))
                    ],
                  ))
              : Container(),
          Ctanim.dataTableOlustur(
              satirOlustur(
                  gelenDurumKolonlar: filtreliBakiyeRaporKolonlar,
                  gelenDurumSatirlar: aramaliBakiyeRaporSatirlar),
              filtreliBakiyeRaporKolonlar)
        ],
      ),
    );
  }
} 

/*
 */