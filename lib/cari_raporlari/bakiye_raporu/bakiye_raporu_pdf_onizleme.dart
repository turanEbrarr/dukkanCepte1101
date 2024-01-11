import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';

import 'package:printing/printing.dart';

import 'bakiye_raporu_make_pdf.dart';

class bakiyeRaporuPdfOnizleme extends StatefulWidget {
  List<List<String>>? satirlar;
  List<String>? kolonlar;

  bakiyeRaporuPdfOnizleme(
      {required this.satirlar, required this.kolonlar,});

  @override
  State<bakiyeRaporuPdfOnizleme> createState() =>
      _bakiyeRaporuPdfOnizlemeState();
}

class _bakiyeRaporuPdfOnizlemeState extends State<bakiyeRaporuPdfOnizleme> {
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
        primaryColor:
            const Color.fromARGB(255, 80, 79, 79), // Ana rengi siyah yapar
        // Vurgu rengini gri yapar (isteğe bağlı)
        // Diğer tema özelliklerini istediğiniz gibi ayarlayabilirsiniz
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Önizleme'),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        ),
        body: PdfPreview(
          build: (context) => bakiye_raporu_make_pdf(
              imagePath: _imageData!,
              kolon: widget.kolonlar!,
              satir: widget.satirlar!),
        ),
      ),
    );
  }
}
