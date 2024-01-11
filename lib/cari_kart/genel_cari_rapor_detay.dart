import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/cari_raporlari/pdf/cari_rapor_pdf_onizleme.dart';
import 'package:dukkan_cepte/fatura_raporlari/faturalar_pdf_onizleme.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';

import '../../widget/cari.dart';
import '../../widget/modeller/sharedPreferences.dart';

class genel_cari_rapor_detay extends StatefulWidget {
  final List<List<dynamic>> gelenBakiyeRapor;
  final List<bool> gelenFiltre;
  final String? faturaID;
  final Cari? carikart;

  //final String titletemp;
  const genel_cari_rapor_detay(
      {super.key,
      required this.gelenBakiyeRapor,
      required this.gelenFiltre,
      required this.faturaID,
      required this.carikart});

  @override
  State<genel_cari_rapor_detay> createState() => _genel_cari_rapor_detayState();
}

class _genel_cari_rapor_detayState extends State<genel_cari_rapor_detay> {
  List<String> bakiyeRaporSatirlar = [];
  List<DataColumn> bakiyeRaporKolonlar = [];
  List<String> aramaliBakiyeRaporSatirlar = [];
  List<String> kolonIsimleri = [];
  List<DataColumn> filtreliBakiyeRaporKolonlar = [];

  List<DataRow> satirOlustur(
      {required List<DataColumn> gelenDurumKolonlar,
      required List<String> gelenDurumSatirlar}) {
    int genelcolsayisi = widget.gelenBakiyeRapor[1].length;
    int fark = widget.gelenBakiyeRapor[1].length - gelenDurumKolonlar.length;
    int enSonEklenen = 0;
    List<DataRow> donecek = [];
    for (int i = 0; i < gelenDurumSatirlar.length / genelcolsayisi; i++) {
      List<DataCell> donecekDataCell = [];

      for (DataColumn element in widget.gelenBakiyeRapor[1]) {
        if (element.label is Text) {
          String labelText = (element.label as Text).data ?? '';
          for (DataColumn element1 in gelenDurumKolonlar) {
            String labelText1 = (element1.label as Text).data ?? '';
            if (labelText == labelText1) {
              DataCell newValue = DataCell(Text(
                gelenDurumSatirlar[enSonEklenen],
                style: TextStyle(fontWeight: FontWeight.w400),
              ));
              donecekDataCell.add(newValue);
            }
          }
        }
        enSonEklenen++;
      }

      /*
      for (int j = 0; j < gelenDurumKolonlar.length; j++) {
        DataCell newValue = DataCell(Text(
          gelenDurumSatirlar[enSonEklenen],
          style: TextStyle(fontWeight: FontWeight.w400),
        ));
        donecekDataCell.add(newValue);
     
      }*/

      donecek.add(DataRow(cells: donecekDataCell));
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

          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => faturalarPdfOnizleme(
                      kolonlar: sj,
                      satirlar: satirOlusturforPDF(
                          gelenDurumKolonlar: filtreliBakiyeRaporKolonlar,
                          gelenDurumSatirlar: aramaliBakiyeRaporSatirlar),
                      caraiKart: widget.carikart,
                      faturaID: widget.faturaID,
                      baslik: 'Satış Faturası Detay',
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
                            if (bakiyeRaporSatirlar[i]
                                .toLowerCase()
                                .contains(aramaTerimi.toLowerCase())) {
                              int kacDefaArtacak = 0;
                              while (
                                  kacDefaArtacak < bakiyeRaporKolonlar.length) {
                                aramaliBakiyeRaporSatirlar.add(
                                    bakiyeRaporSatirlar[i + kacDefaArtacak]);
                                kacDefaArtacak++;
                              }
                            } else if (bakiyeRaporSatirlar[i + 1]
                                .toLowerCase()
                                .contains(aramaTerimi.toLowerCase())) {
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
                                secilenKolonlar,
                                "satisFaturaRaporuDetayFiltre");
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