import 'package:flutter/material.dart';
import '../../faturaFis/fisHareket.dart';
import '../../faturaFis/fis.dart';
import '../appbar.dart';
import '../ctanim.dart';
import '../../genel_belge.dart/genel_belge_pdf_onizleme.dart';
import '../../Depo Transfer/depo_transfer_pdf_onizleme.dart';

class gonderilmisBelgelerDetay extends StatelessWidget {
  gonderilmisBelgelerDetay({required this.fis});
  final Fis fis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Detay"),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.picture_as_pdf),
        onPressed: () {
          if (Ctanim().MapFisTipTers[fis.TIP].toString() != "Depo Transfer") {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PdfOnizleme(m: fis,fastReporttanMiGelsin: true,)));
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      DepoTransferPdfOnizleme(m: fis)),
            );
          }
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
  final Fis fis;

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
                    Ctanim().MapFisTipTers[fis.TIP].toString() !=
                            "Depo Transfer"
                        ? SizedBox(
                            height: 20,
                            child: Text("Cari Kodu:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                )))
                        : Container(),
                    Ctanim().MapFisTipTers[fis.TIP].toString() !=
                            "Depo Transfer"
                        ? SizedBox(
                            height: 60,
                            child: Text("Cari Adı:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                )))
                        : Container(),
                          SizedBox(
                        height: 20,
                      
                        child: Text("Belge Numarası:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ))),
                    SizedBox(
                        height: 20,
                        child: Text("Belge Tipi:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ))),
                    Ctanim().MapFisTipTers[fis.TIP].toString() !=
                            "Depo Transfer"
                        ? SizedBox(
                            height: 20,
                            child: Text("Cari Bakiye:",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                )))
                        : Container(),
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
                Ctanim().MapFisTipTers[fis.TIP].toString() != "Depo Transfer"
                    ? SizedBox(
                        height: 20,
                        child: Text(fis.CARIKOD.toString(),
                            style: TextStyle(
                              fontSize: 13,
                            )))
                    : Container(),
                Ctanim().MapFisTipTers[fis.TIP].toString() != "Depo Transfer"
                    ? SizedBox(
                        height: 60,
                        child: SizedBox(
                          width: 200,
                          child: Text(fis.CARIADI.toString(),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ),
                      )
                    : Container(),
                     SizedBox(
                    height: 20,
                    child: Text(fis.BELGENO.toString(),
                        style: TextStyle(
                          fontSize: 13,
                        ))),

                SizedBox(
                    height: 20,
                    child: Text(Ctanim().MapFisTipTers[fis.TIP].toString(),
                        style: TextStyle(
                          fontSize: 13,
                        ))),
                Ctanim().MapFisTipTers[fis.TIP].toString() != "Depo Transfer"
                    ? SizedBox(
                        height: 20,
                        child: Text(
                            Ctanim.donusturMusteri(
                                fis.cariKart.BAKIYE.toString()),
                            style: TextStyle(
                              fontSize: 13,
                            )))
                    : Container(),
              ]),
            ]),
            SizedBox(
              height: 40,
            ),
            Ctanim().MapFisTipTers[fis.TIP].toString() != "Depo Transfer"
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateColor.resolveWith((states) {
                          return Color.fromARGB(255, 224, 241, 255);
                        }),
                        dataRowColor: MaterialStateColor.resolveWith((states) {
                          return getNextRowColor();
                        }),
                        dataRowHeight: 80,
                        columns: [
                          DataColumn(label: Text('Ürün Açıklaması')),
                          DataColumn(label: Text('Fiyat')),
                          DataColumn(label: Text('Isk')),
                          DataColumn(label: Text('N.Fiyat')),
                          DataColumn(label: Text('Miktar')),
                          DataColumn(label: Text('Toplam')),
                        ],
                        rows: fis.fisStokListesi
                            .map(
                              (fisHareket) => DataRow(
                                cells: [
                                  DataCell(Text("BARKOD :" +
                                      fisHareket.STOKKOD.toString() +
                                      "\n" +
                                      "ÜRÜN ADI :" +
                                      fisHareket.STOKADI.toString() +
                                      "\n" +
                                      "KDV :" +
                                      fisHareket.KDVORANI.toString())),
                                  DataCell(
                                      Text(fisHareket.NETFIYAT.toString())),
                                  DataCell(Text(fisHareket.ISK.toString())),
                                  DataCell(Text(
                                      fisHareket.ISKONTOTOPLAM.toString())),
                                  DataCell(Text(fisHareket.MIKTAR.toString())),
                                  DataCell(Text(
                                      fisHareket.KDVDAHILNETTOPLAM.toString())),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateColor.resolveWith((states) {
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
                        rows: fis.fisStokListesi
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
            Ctanim().MapFisTipTers[fis.TIP].toString() != "Depo Transfer"
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 8, right: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ürün Toplamı:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "İndirim Toplamı:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Ara Toplam:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "KDV Tutarı:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Genel Toplam:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    Ctanim.donusturMusteri(
                                            fis.TOPLAM!.toString()) +
                                        " ₺",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Ctanim.donusturMusteri(
                                            fis.INDIRIM_TOPLAMI!.toString()) +
                                        " ₺",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Ctanim.donusturMusteri(
                                            fis.ARA_TOPLAM!.toString()) +
                                        " ₺",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Ctanim.donusturMusteri(
                                            fis.KDVTUTARI!.toString()) +
                                        " ₺",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Ctanim.donusturMusteri(
                                            fis.GENELTOPLAM!.toString()) +
                                        " ₺",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ])
                          ],
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
