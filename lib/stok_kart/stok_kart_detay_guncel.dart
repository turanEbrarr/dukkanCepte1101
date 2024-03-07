import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';
import 'package:dukkan_cepte/controllers/stokKartController.dart';
import 'package:dukkan_cepte/faturaFis/fisHareket.dart';
import 'package:dukkan_cepte/stok_kart/stokDepoMode.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:path/path.dart';
import 'package:quantity_input/quantity_input.dart';

import '../controllers/cariController.dart';
import '../faturaFis/fis.dart';
import '../widget/ctanim.dart';

class stok_kart_detay_guncel extends StatefulWidget {
  final StokKart stokKart;

  stok_kart_detay_guncel({
    super.key,
    required this.stokKart,
  });

  @override
  State<stok_kart_detay_guncel> createState() => _stok_kart_detay_guncelState();
}

class _stok_kart_detay_guncelState extends State<stok_kart_detay_guncel> {
  DateTime dateTime = DateTime.now();
  late double netfiyat;
  late double iskonto;
  late TextEditingController iskontoController;
  late TextEditingController adetController;
  late TextEditingController fiyatController;
  late String fiyat;
  late int miktar;
  late double selectedIskonto;
  DateTime now = DateTime.now();

  double hesaplaToplamTutar(
      TextEditingController adetController,
      TextEditingController fiyatController,
      TextEditingController iskontoController) {
    int adet = int.tryParse(adetController.text) ?? 0;
    double fiyat = double.tryParse(fiyatController.text) ?? 0.0;
    double iskonto = double.tryParse(iskontoController.text) ?? 0.0;
    return adet * (fiyat * (1 - iskonto / 100));
  }

  TextEditingController fiyatDegistir = new TextEditingController();
  String donusturDouble(String inText) {
    String donecekTemp = inText;
    if (donecekTemp.contains(",")) {
      String donecek = donecekTemp.replaceAll(",", ".");
      return donecek;
    } else {
      return donecekTemp;
    }
  }
  List<StokDepoModel> yerelList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yerelList= listeler.listStokDepo.where((element) => element.KOD == widget.stokKart.KOD).toList();
  }

  bool readOnly = true;
  Color enableDisableColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;

    double fontSize = 15.0 + (widget.stokKart.ADI!.length / 10);
    double textLenght = widget.stokKart.ADI!.length.toDouble() * 1.5;

    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      title: Row(
        children: [
          SizedBox(width: x * 0.64, child: const Text("Stok Detay")),
          Spacer(),
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            iconSize: x * .1,
          )
        ],
      ),
      content: Container(
        height: 700,
        width: MediaQuery.of(context).size.width * .9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: x * .01),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .30,
                  child: Container(
                      child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: x * .02, bottom: x * 0.05),
                        child: Text(
                          "Stok Bilgileri",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Kodu: "),
                          Text(widget.stokKart.KOD!),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Adı: "),
                            SizedBox(
                                height: textLenght ,
                                width: MediaQuery.of(context).size.width * .5,
                                child: SingleChildScrollView(
                                  child: Text(
                                    style: TextStyle(fontSize: fontSize - 4),
                                    widget.stokKart.ADI!,
                                    maxLines: 5,
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Marka: "),
                          Text(widget.stokKart.MARKA!),
                        ],
                      ),
                     
                      
                    ],
                  )),
                ),
              ),
                           Divider(
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: x * .02),
                child: Text(
                  "Bakiye Bilgisi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
           
              
           
             
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: x * .02),
                  child: Column(
                    children: [
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: x * .02),
                        child: Text(
                          "Fiyat Bilgileri",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      sutunTasarim(x,
                          ilkTittle: "Satış Fiyat 1",
                          ikinciTittle: "Satış Fiyat 2",
                          ilkGosterim: widget.stokKart.SFIYAT1.toString(),
                          ikinciGosterim: widget.stokKart.SFIYAT2.toString()),
                      sutunTasarim(x,
                          ilkTittle: "Satış Fiyat 3",
                          ikinciTittle: "Satış Fiyat 4",
                          ilkGosterim: widget.stokKart.SFIYAT3.toString(),
                          ikinciGosterim: widget.stokKart.SFIYAT4.toString()),
                      sutunTasarim(x,
                          ilkTittle: "Satış Fiyat 5",
                          ikinciTittle: Ctanim.kullanici!.ALISFIYATGORMESIN== "H" ? "Alış Fiyat 1" : "-",
                          ilkGosterim: widget.stokKart.SFIYAT5.toString(),
                          ikinciGosterim: widget.stokKart.AFIYAT1.toString()),
                    
                      sutunTasarim(x,
                          ilkTittle: "Satış İSK",
                          ikinciTittle: "Alış İSK",
                          ilkGosterim: widget.stokKart.SATISISK.toString(),
                          ikinciGosterim: widget.stokKart.ALISISK.toString()),
                    ],
                  ),
                ),
              ),
  Divider(
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: x * .02),
                child: Text(
                  "KDV Bilgileri",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: x * .02),
                child: Text(
                  "Barkodlar/Birimleri",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              
              
             
            
           
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: x * .1),
                child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Kapat"))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column sutunTasarim(double x,
      {required String ilkTittle, ilkGosterim, ikinciTittle, ikinciGosterim}) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: x * .03,
            left: x * .07,
          ),
          child: Container(
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: x * .3,
                  child: Text(
                    ilkTittle,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                    width: x * .05,
                    child: VerticalDivider(
                      color: Colors.blue,
                      thickness: 2,
                      indent: 10,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: x * .05),
                  child: SizedBox(
                      width: x * .25,
                      child:
                          Text(ikinciTittle, style: TextStyle(fontSize: 16))),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: x * .03,
            left: x * .07,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: x * .3, child: Text( ilkTittle != "-" ?  Ctanim.donusturMusteri(ilkGosterim):"-")),
              SizedBox(
                  width: x * .05,
                  child: Text(" ", style: TextStyle(fontSize: 17))),
              Padding(
                padding: EdgeInsets.only(left: x * .05),
                child: SizedBox(
                    width: x * .25,
                    child: Text( ikinciTittle != "-" ?  Ctanim.donusturMusteri(ikinciGosterim):"-")),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
