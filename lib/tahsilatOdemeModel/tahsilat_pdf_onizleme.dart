import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilat.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilat_make_pdf.dart';

import 'package:printing/printing.dart';
import '../faturaFis/fis.dart';

class TahsilatPdfOnizleme extends StatefulWidget {
  final Tahsilat m;
  final String belgeTipi;

  const TahsilatPdfOnizleme(
      {Key? key, required this.m, required this.belgeTipi})
      : super(key: key);

  @override
  State<TahsilatPdfOnizleme> createState() => _TahsilatPdfOnizlemeState();
}

class _TahsilatPdfOnizlemeState extends State<TahsilatPdfOnizleme> {
  Uint8List? _imageData;
  Future<void> _loadImage() async {
    // Veritabanından resmin yolunu alın
    String? imagePath = await VeriIslemleri().getFirstImage();
    if (imagePath != "") {
      // Resim yolu varsa, bu yolu Uint8List'e dönüştürün ve _imageData değişkenine atayın
      final File imageFile = File(imagePath!);
      final Uint8List imageData = await imageFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    } else {
      final ByteData assetData = await rootBundle.load('images/beyaz.jpg');
      _imageData = assetData.buffer.asUint8List();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Temayı karanlık (siyah) yapar
        primaryColor: const Color.fromARGB(255, 80, 79, 79),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Önizleme'),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        body: PdfPreview(
          build: (context) =>
              TahsilatMakePdf(widget.m, _imageData!, widget.belgeTipi),
        ),
      ),
    );
  }
}
