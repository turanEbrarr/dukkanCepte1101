import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import '../faturaFis/fis.dart';


class stokKartPdfOnizleme extends StatefulWidget {
  final Uint8List pdfData;

  const stokKartPdfOnizleme(
      {Key? key, required this.pdfData, })
      : super(key: key);

  @override
  State<stokKartPdfOnizleme> createState() => _stokKartPdfOnizlemeState();
}

class _stokKartPdfOnizlemeState extends State<stokKartPdfOnizleme> {

 



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primaryColor: const Color.fromARGB(255, 80, 79, 79),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Önizleme'),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        body: PdfPreview(
          build: (context) {
         
              return widget.pdfData;
            
          },
        ),
      ),
    );
  }
}
