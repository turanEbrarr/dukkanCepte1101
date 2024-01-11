import 'package:flutter/material.dart';
import '../../tahsilatOdemeModel/tahsilat.dart';
import '../../tahsilatOdemeModel/tahsilatHaraket.dart';
import '../../tahsilatOdemeModel/tahsilat_pdf_onizleme.dart';
import '../appbar.dart';
import '../ctanim.dart';
import '../../genel_belge.dart/genel_belge_pdf_onizleme.dart';

class kaydedilmisTahsilatOdemelerDetay extends StatelessWidget {
  kaydedilmisTahsilatOdemelerDetay({required this.fis});
  final Tahsilat fis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Detay"),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.picture_as_pdf),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TahsilatPdfOnizleme(
                      m: fis,
                      belgeTipi: Ctanim().MapIlslemTipTers[fis.TIP].toString(),
                    )),
          );
        },
      ),
      body: ListView(
        children: [FisHareketDataTable(fis: fis)],
      ),
    );
  }
}

List<Color> rowColors = [
  Color.fromARGB(255, 255, 255, 255),
  Color.fromARGB(255, 174, 179, 176),
];
int _currentColorIndex = 0;
Color getNextRowColor() {
  Color color = rowColors[_currentColorIndex];
  _currentColorIndex = (_currentColorIndex + 1) % rowColors.length;
  return color;
}

class FisHareketDataTable extends StatelessWidget {
  final Tahsilat fis;

  FisHareketDataTable({required this.fis});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                width: 90,
                child: Column(
                  children: [
                    SizedBox(
                        height: 20,
                        child: Text("İşlem Tarihi:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(
                        height: 20,
                        child: Text("Cari Kodu:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(
                        height: 60,
                        child: Text("Cari Adı:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(
                        height: 20,
                        child: Text("Belge Tipi:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(
                        height: 20,
                        child: Text("Cari Bakiye:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            )))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                    height: 20,
                    child: Text(fis.TARIH.toString(),
                        style: TextStyle(
                          fontSize: 13,
                        ))),
                SizedBox(
                    height: 20,
                    child: Text(fis.CARIKOD.toString(),
                        style: TextStyle(
                          fontSize: 13,
                        ))),
                SizedBox(
                  height: 60,
                  child: SizedBox(
                    width: 200,
                    child: Text(fis.CARIADI.toString(),
                        style: TextStyle(
                          fontSize: 13,
                        )),
                  ),
                ),
                SizedBox(
                    height: 20,
                    child: Text(Ctanim().MapIlslemTipTers[fis.TIP].toString(),
                        style: TextStyle(
                          fontSize: 13,
                        ))),
                SizedBox(
                    height: 20,
                    child: Text(
                        Ctanim.donusturMusteri(fis.cariKart.BAKIYE.toString()),
                        style: TextStyle(
                          fontSize: 13,
                        ))),
              ]),
            ]),
            SizedBox(
              height: 40,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) {
                    return Color.fromARGB(255, 224, 241, 255);
                  }),
                  dataRowColor: MaterialStateColor.resolveWith((states) {
                    return getNextRowColor();
                  }),
                  dataRowHeight: 80,
                  columns: [
                    DataColumn(label: Text('Tahsilat Tipi')),
                    DataColumn(label: Text('Tutar')),
                    DataColumn(label: Text('Vade Tar.')),
                    DataColumn(label: Text('Çek Seri No')),
                  ],
                  rows: fis.tahsilatHareket
                      .map(
                        (fisHareket) => DataRow(
                          cells: [
                            DataCell(Text(Ctanim()
                                .MapTahsilatOdemeTip[fisHareket.TIP]
                                .toString())),
                            DataCell(Text(fisHareket.TUTAR.toString())),
                            DataCell(Text(fisHareket.VADETARIHI.toString())),
                            DataCell(Text(fisHareket.CEKSERINO.toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
