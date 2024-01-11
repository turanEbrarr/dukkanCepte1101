import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/widget/String_tanim.dart';

class stok_kart_detay_tab1 extends StatelessWidget {
  const stok_kart_detay_tab1({super.key, required this.liststokkart1}); //
  final StokKart liststokkart1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blue, width: 1),
                  bottom: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
              child: Card(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kodu: ${liststokkart1.KOD}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Adı : ${liststokkart1.ADI
                          }",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Marka : ${liststokkart1.MARKA}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ]),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 3),
                child: Text("RESİM", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blue, width: 1),
                  bottom: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                      children: [
                        Icon(
                          Icons.photo,
                          size: 50,
                          color: Colors.amber,
                        ),
                        Spacer(),
                        Text("Resim Yükle"),
                      ],
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3),
                  child: Text("BARKOD", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.blue, width: 1),
                bottom: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Barkod1 : " + liststokkart1.BARKOD1.toString(),
                              style: TextStyle(fontSize: 14)),
                          Text("Barkod2 : " + liststokkart1.BARKOD2.toString(),
                              style: TextStyle(fontSize: 14)),
                          Text("Barkod3 : " + liststokkart1.BARKOD3.toString(),
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    /*  SizedBox(
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width /50,
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Barkod4 : " +
                                    liststokkart1.BARKOD4.toString(),
                                style: TextStyle(fontSize: 14)),
                            Text(
                                "Barkod5 : " +
                                    liststokkart1.BARKOD5.toString(),
                                style: TextStyle(fontSize: 14)),
                            Text(
                                "Barkod6 : " +
                                    liststokkart1.BARKOD6.toString(),
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 3),
                  child: Text(
                    "FİYAT",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.blue, width: 1),
                bottom: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ssFiyat1 +
                              ":    " +
                              liststokkart1.SFIYAT1.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssFiyat2 +
                              ":    " +
                              liststokkart1.SFIYAT2.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssFiyat3 +
                              ":    " +
                              liststokkart1.SFIYAT3.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssFiyat4 +
                              ":    " +
                              liststokkart1.SFIYAT4.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssFiyat5 +
                              ":    " +
                              liststokkart1.SFIYAT5.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                       
                        
                        
                      ],
                    ),
                  
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          saFiyat1 +
                              ":   " +
                              liststokkart1.SFIYAT1.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          saFiyat2 +
                              ":   " +
                              liststokkart1.SFIYAT2.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          saFiyat3 +
                              ":   " +
                              liststokkart1.SFIYAT3.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          saFiyat4 +
                              ":   " +
                              liststokkart1.SFIYAT4.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          saFiyat5 +
                              ":   " +
                              liststokkart1.AFIYAT5.toString().substring(0,3),
                          style: TextStyle(fontSize: 14),
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 4),
                  child: Text(
                    "AÇIKLAMALAR",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.blue, width: 1),
                bottom: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
            child: Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                          ssAciklama1 + ":    " + liststokkart1.SACIKLAMA1
                          .toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssAciklama3 + ":    " + liststokkart1.SACIKLAMA3.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssAciklama5 + ":    " + liststokkart1.SACIKLAMA5.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          sSatisIskonto +
                              ":            " +
                              liststokkart1.SATISISK
                              .toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  /*  SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width / 6.5,
                    ),*/
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      
                        Text(
                          ssAciklama2 + ":   " + liststokkart1.SACIKLAMA2.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          ssAciklama4 + ":   " + liststokkart1.SACIKLAMA4.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          sAlisIskonto +
                              ":             " +
                              liststokkart1.ALISISK.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
