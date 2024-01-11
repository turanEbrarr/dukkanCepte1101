import 'package:flutter/material.dart';



class fatura_islemler_page extends StatefulWidget {
  const fatura_islemler_page({super.key});

  @override
  State<fatura_islemler_page> createState() => _fatura_islemler_pageState();
}

class _fatura_islemler_pageState extends State<fatura_islemler_page> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text("Dükkan Cepte"),
              )
            ]
          )
          );
          }
  }
