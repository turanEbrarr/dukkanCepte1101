import 'package:flutter/material.dart';
import '../../faturaFis/fisHareket.dart';
import '../../faturaFis/fis.dart';
import '../appbar.dart';
import '../ctanim.dart';
import '../../genel_belge.dart/genel_belge_pdf_onizleme.dart';
import '../../Depo Transfer/depo_transfer_pdf_onizleme.dart';
import '../../Depo Transfer/depo.dart';

class kaydedilmisSayimlarDetay extends StatelessWidget {
  kaydedilmisSayimlarDetay({required this.fis});
  final Sayim fis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Detay"),
      /*
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.picture_as_pdf),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => DepoTransferPdfOnizleme(m: fis)),
          );
        },
      ),
      */
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
  final Sayim fis;

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
                        child: Text("Plasiyer:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ))),
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
                    child: Text(fis.PLASIYERKOD.toString(),
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
                    DataColumn(label: Text('Ürün Açıklaması')),
                    DataColumn(label: Text('Miktar')),
                    DataColumn(label: Text('Birim')),
                  ],
                  rows: fis.sayimStokListesi
                      .map(
                        (fisHareket) => DataRow(
                          cells: [
                            DataCell(Text("BARKOD :" +
                                fisHareket.STOKKOD.toString() +
                                "\n" +
                                "ÜRÜN ADI :" +
                                fisHareket.STOKADI.toString())),
                            DataCell(Text(fisHareket.MIKTAR.toString())),
                            DataCell(Text(fisHareket.BIRIM.toString())),
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
