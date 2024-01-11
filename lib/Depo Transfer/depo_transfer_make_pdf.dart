
import 'dart:typed_data';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import '../faturaFis/fis.dart';
import '../widget/ctanim.dart';

Future<Uint8List> depo_transfer_make_pdf(Fis m, Uint8List imagePath) async {
  final image = pw.MemoryImage(imagePath);
  final fontData = await rootBundle.load("images/fonts/Roboto-Regular.ttf");
  final ttfFont = pw.Font.ttf(fontData);

  final boldfontData = await rootBundle.load("images/fonts/Roboto-Bold.ttf");
  final boldttfFont = pw.Font.ttf(boldfontData);

  final pdf = pw.Document();

  int ilkSayfa = 0;
  bool ikinciGozuksun = false;

  if (m.fisStokListesi.length <= 8) {
    ilkSayfa = m.fisStokListesi.length;
    ikinciGozuksun = false;
  } else {
    ilkSayfa = 8;
    ikinciGozuksun = true;
  }
  String gidenDepo = "";
  String gidenSube = "";
  for (var element in listeler.listSubeDepoModel) {
    if (m.GIDENDEPOID == element.DEPOID) {
      gidenDepo = element.DEPOADI!;
    }
    if (m.GIDENSUBEID == element.SUBEID) {
      gidenSube = element.SUBEADI!;
    }
  }

  // İlk sayfada üst bilgiler ve tablo başlıkları

  List<Widget> glen = [];
  int i = 0;
  while (i < m.fisStokListesi.length) {
    glen.add(pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        i == 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: pw.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        child: pw.Column(
                          children: [
                            SizedBox(
                                height: 20,
                                child: Text("İşlem Tarihi:",
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                                height: 20,
                                child: Text("Plasiyer Kodu:",
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                                height: 20,
                                child: Text("Belge Tipi:",
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                                height: 20,
                                child: Text("Giden Şube:",
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                                height: 20,
                                child: Text("Giden Depo:",
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                          ],
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                        ),
                      ),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 20,
                                child: Text(m.TARIH.toString(),
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                              height: 20,
                              child: SizedBox(
                                width: 200,
                                child: Text(m.PLASIYERKOD.toString(),
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont)),
                              ),
                            ),
                            SizedBox(
                                height: 20,
                                child: Text(
                                    Ctanim().MapFisTipTers[m.TIP].toString(),
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                                height: 20,
                                child: Text(gidenSube,
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                            SizedBox(
                                height: 20,
                                child: Text(gidenDepo,
                                    style: pw.TextStyle(
                                        fontSize: 15,
                                        fontWeight: pw.FontWeight.bold,
                                        font: boldttfFont))),
                          ]),
                      Spacer(),
                      pw.Image(image, width: 150, height: 100),
                      Container(height: 40),
                    ]))
            : Container(),
        i == 0
            ? pw.Table.fromTextArray(
                headers: ['Ürün Açıklaması', 'Miktar', 'Birim'],
                data: buildTableRows(m, start: i, end: i + 1),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                },
                cellStyle: pw.TextStyle(
                  font: ttfFont,
                  fontSize: 10,
                ),
                headerStyle: pw.TextStyle(
                  font: boldttfFont,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                border: pw.TableBorder.all(color: PdfColors.black),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                columnWidths: {
                  0: pw.FractionColumnWidth(
                      0.4), // 1. sütun için tablonun genişliğinin yüzde 40'ı
                  1: pw.FractionColumnWidth(
                      0.15), // 2. sütun için tablonun genişliğinin yüzde 10'u
                  2: pw.FractionColumnWidth(
                      0.1), // 3. sütun için tablonun genişliğinin yüzde 10'u
                  // 6. sütun için tablonun genişliğinin yüzde 20'si
                },
                headerHeight: 40)
            : pw.Table.fromTextArray(
                data: buildTableRows(m, start: i, end: i + 1),
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                },
                border: pw.TableBorder.all(color: PdfColors.black),
                columnWidths: {
                  0: pw.FractionColumnWidth(
                      0.4), // 1. sütun için tablonun genişliğinin yüzde 40'ı
                  1: pw.FractionColumnWidth(
                      0.15), // 2. sütun için tablonun genişliğinin yüzde 10'u
                  2: pw.FractionColumnWidth(
                      0.1), // 3. sütun için tablonun genişliğinin yüzde 10'u
                  // 6. sütun için tablonun genişliğinin yüzde 20'si
                },
              ),
      ],
    ));
    i++;
  }

  // Diğer sayfalarda sadece tablo

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttfFont)),
      build: (context) {
        return glen;
      },
    ),
  );

  return pdf.save();
}

List<List<String>> buildTableRows(Fis m, {int start = 0, int end = 0}) {
  List<List<String>> rows = [];

  for (var j = start; j < end; j++) {
    List<String> row = [
      "BARKOD : ${m.fisStokListesi[j].STOKKOD}\n"
          "ADI: ${m.fisStokListesi[j].STOKADI}\n"
          "KDV: ${m.fisStokListesi[j].KDVORANI}",
      "${m.fisStokListesi[j].MIKTAR.toString()}",
      "${m.fisStokListesi[j].BIRIM.toString()}",
    ];
    rows.add(row);
  }

  return rows;
}

List<List<String>> buildTableRowsUst(Fis m, {int start = 0, int end = 0}) {
  List<List<String>> rows = [];

  List<String> row = [
    "İşlem Tarihi",
    m.TARIH.toString(),
  ];
  rows.add(row);

  return rows;
}


/*
  pw.Text(
            "Ürün Toplamı:\t${Ctanim.donusturMusteri(m.TOPLAM!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "İndirim Toplamı:\t${Ctanim.donusturMusteri(m.INDIRIM_TOPLAMI!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "Ara Toplam:\t${Ctanim.donusturMusteri(m.ARA_TOPLAM!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "KDV Tutarı:\t${Ctanim.donusturMusteri(m.KDVTUTARI!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "Genel Toplam:\t${Ctanim.donusturMusteri(m.GENELTOPLAM!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
*/