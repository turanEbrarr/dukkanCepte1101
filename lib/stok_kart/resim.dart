import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class resim extends StatefulWidget {
  const resim({super.key, required this.bytes, required this.stokKart});
  final Uint8List bytes;
  final StokKart stokKart;

  @override
  State<resim> createState() => _resimState();
}

class _resimState extends State<resim> {Future<void> shareImage(Uint8List imageBytes) async {
  final temp = await getTemporaryDirectory();
  final path = '${temp.path}/stokResim.png';
  File file = File(path);


  await file.writeAsBytes(imageBytes);

  // Resmi paylaş
  await Share.shareFiles([path], text: widget.stokKart.ADI);


  if (await file.exists()) {
    await file.delete();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        shareImage(widget.bytes);
      },
      child: Icon(Icons.share),
      ),
      appBar: MyAppBar(height: 50, title: "Stok Resmi"),
      body: Center(
          child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
        imageProvider: Image.memory(widget.bytes).image,
      )),
    );
  }
}
