
import 'dart:typed_data';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> cari_rapor_make_pdf(
    {required String baslik,
    required Uint8List imagePath,
    required List<List<String>> satir,
    required List<String> kolon}) async {
  final image = pw.MemoryImage(imagePath);
  final fontData = await rootBundle.load("images/fonts/Roboto-Regular.ttf");
  final ttfFont = pw.Font.ttf(fontData);

  final boldfontData = await rootBundle.load("images/fonts/Roboto-Bold.ttf");
  final boldttfFont = pw.Font.ttf(boldfontData);

  final pdf = pw.Document();




  // İlk sayfada üst bilgiler ve tablo başlıkları

  List<Widget> glen = [];
  int i = 0;
  while (i < satir.length) {
    glen.add(pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        i == 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(baslik,
                        style: TextStyle(font: boldttfFont, fontSize: 16)), pw.Image(image, width: 150, height: 100),]))
            : Container(),
        i == 0
            ? pw.Table.fromTextArray(
                headers: kolon,
                data: buildTableRows(satir, start: i, end: i + 1),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.centerRight,
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
                  0: pw.FractionColumnWidth(0.2),
                  1: pw.FractionColumnWidth(0.3),
                  2: pw.FractionColumnWidth(0.15),
                  3: pw.FractionColumnWidth(0.15),
                  4: pw.FractionColumnWidth(0.20),
                  5: pw.FractionColumnWidth(0.15),
                  6: pw.FractionColumnWidth(0.15),
                  7: pw.FractionColumnWidth(0.15),
                  8: pw.FractionColumnWidth(0.15),
                  9: pw.FractionColumnWidth(0.15),
                  10: pw.FractionColumnWidth(0.15),
                  11: pw.FractionColumnWidth(0.15),
                  12: pw.FractionColumnWidth(0.15),
                  13: pw.FractionColumnWidth(0.15),
                },
                headerHeight: 40)
            : pw.Table.fromTextArray(
                data: buildTableRows(satir, start: i, end: i + 1),
                border: pw.TableBorder.all(color: PdfColors.black),
                columnWidths: {
                  0: pw.FractionColumnWidth(0.2),
                  1: pw.FractionColumnWidth(0.3),
                  2: pw.FractionColumnWidth(0.15),
                  3: pw.FractionColumnWidth(0.15),
                  4: pw.FractionColumnWidth(0.20),
                  5: pw.FractionColumnWidth(0.15),
                  6: pw.FractionColumnWidth(0.15),
                  7: pw.FractionColumnWidth(0.15),
                  8: pw.FractionColumnWidth(0.15),
                  9: pw.FractionColumnWidth(0.15),
                  10: pw.FractionColumnWidth(0.15),
                  11: pw.FractionColumnWidth(0.15),
                  12: pw.FractionColumnWidth(0.15),
                  13: pw.FractionColumnWidth(0.15),
                },
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.centerRight,
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

List<List<String>> buildTableRows(List<List<String>> parca,
    {int start = 0, int end = 0}) {
  List<List<String>> rows = [];

  for (var j = start; j < end; j++) {
    rows.add(parca[start]);
  }

  return rows;
}
