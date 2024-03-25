
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';
import 'package:dukkan_cepte/controllers/stokKartController.dart';
import 'package:dukkan_cepte/faturaFis/fisHareket.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/webservis/kurModel.dart';
import 'package:quantity_input/quantity_input.dart';
import '../widget/veriler/listeler.dart';
import '../controllers/cariController.dart';
import '../faturaFis/fis.dart';
import '../widget/ctanim.dart';

class genel_belge_stok_kart_guncellemeDialog extends StatefulWidget {
  final String stokAdi;
  final String stokKodu;
  final StokKart stokkart;

  final String cariKod;
  double fiyat;
  final double iskonto;
  final int miktar;
  final bool urunListedenMiGeldin;
  final String stokKartKurAdi;
  final String belgeTipi;

  genel_belge_stok_kart_guncellemeDialog(
      {super.key,
      required this.stokAdi,
      required this.stokKodu,
   
      required this.cariKod,
      required this.fiyat,
      required this.iskonto,
      required this.miktar,
      required this.stokkart,
      required this.urunListedenMiGeldin,
      required this.stokKartKurAdi, required this.belgeTipi});

  @override
  State<genel_belge_stok_kart_guncellemeDialog> createState() =>
      _genel_belge_stok_kart_guncellemeDialogState();
}

class _genel_belge_stok_kart_guncellemeDialogState
    extends State<genel_belge_stok_kart_guncellemeDialog> {
  TextEditingController aciklama = new TextEditingController();
  TextEditingController fiyatCont = new TextEditingController();
  TextEditingController dovizFiyatController = new TextEditingController();

  TextEditingController kurController = new TextEditingController();
  TextEditingController KDVOranController = new TextEditingController();

  TextEditingController isk1Controller = new TextEditingController();
  TextEditingController isk2Controller = new TextEditingController();
  List<String> birimler = [];
  List<String> fiyatListesi = [];
   double fiyatTutucuForIsk2 = -1;
  bool fiyatDegistirebilsin = true;
  String seciliFiyat = Ctanim.satisFiyatListesi.first;
  String? selectedItem = "";
  List<String> para_birim = [];
  String? seciliParaBirimi = "";
  DateTime dateTime = DateTime.now();
  late double netfiyat;
  late double iskonto;
  late TextEditingController iskontoController;
  late TextEditingController adetController;
  late TextEditingController fiyatController;
  late TextEditingController brutFiyatController;
  late String fiyat;

  late double selectedIskonto;
  DateTime now = DateTime.now();
  String? seciliDovizAdi;
  FocusNode _focusNode = FocusNode();

  final StokKartController stokKartEx = Get.find();
  final CariController cariEx = Get.find();
  final FisController fisEx = Get.find();

  void hesaplaDovizKurFiyat({required String degisenControllerAdiTamYaz}) {
    if (degisenControllerAdiTamYaz == "fiyatCont") {
      double temp =
          double.parse(brutFiyatController.text) / double.parse(kurController.text);
      dovizFiyatController.text =   Ctanim.noktadanSonraAlinacakParametreli(KdovizFiyat!, temp);
    } else if (degisenControllerAdiTamYaz == "kurController") {
      double temp =
          double.parse(fiyatCont.text) / double.parse(kurController.text);
      dovizFiyatController.text =  Ctanim.noktadanSonraAlinacakParametreli(KdovizFiyat!, temp);
      setState(() {});
    } else {
      double temp = double.parse(dovizFiyatController.text) *
          double.parse(kurController.text);
      brutFiyatController.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, temp);
    }
  }

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

  String geciciFiyatTut = "";
  KurModel? anaBirim;
  KurModel? stokKur;
    KUSURAT? Kfiyat;
  KUSURAT? Kmiktar;
  KUSURAT? Kkur;
  KUSURAT? KdovizFiyat;
  KUSURAT? Ktutar;
  KUSURAT? KdovTutar;
  @override
  void initState() {
    print(widget.cariKod);
    int tip = Ctanim().MapFisTip[widget.belgeTipi]??0;
    super.initState();
    seciliDovizAdi = widget.stokKartKurAdi;
    seciliParaBirimi = widget.stokKartKurAdi;
        if (tip == 3 ||
       tip == 12 ||
       tip == 17) {
      Kfiyat = KUSURAT.ALISFIYAT;
      Kmiktar = KUSURAT.ALISMIKTAR;
      Kkur = KUSURAT.ALISKUR;
      KdovizFiyat = KUSURAT.ALISDOVFIYAT;
      Ktutar = KUSURAT.ALISTUTAR;
      KdovTutar = KUSURAT.ALISDOVTUTAR;
    } else if (tip == 1 ||
        tip == 4 ||
       tip == 6) {
      Kfiyat = KUSURAT.PERFIYAT;
      Kmiktar = KUSURAT.PERMIKTAR;
      Kkur = KUSURAT.PERKUR;
      KdovizFiyat = KUSURAT.PERDOVFIYAT;
      Ktutar = KUSURAT.PERTUTAR;
      KdovTutar = KUSURAT.PERDOVTUTAR;
    } else {
      Kfiyat = KUSURAT.FIYAT;
      Kmiktar = KUSURAT.MIKTAR;
      Kkur = KUSURAT.KUR;
      KdovizFiyat = KUSURAT.DOVFIYAT;
      Ktutar = KUSURAT.TUTAR;
      KdovTutar = KUSURAT.DOVTUTAR;
    }
    if (widget.stokkart.OLCUBIRIM1 != "") {
      birimler.add(widget.stokkart.OLCUBIRIM1!);
      selectedItem = birimler[0];
    }
    if (widget.stokkart.OLCUBIRIM2 != "") {
      birimler.add(widget.stokkart.OLCUBIRIM2!);
    }
  

    readOnly = false;
    enableDisableColor = Colors.black;

    for (var element in listeler.listKur) {
      if (seciliParaBirimi == element.ACIKLAMA) {
        stokKur = element;
        kurController.text =  Ctanim.noktadanSonraAlinacakParametreli(Kkur!, element.KUR!);     
        if (element.ANABIRIM == "H") {
          geciciFiyatTut =
              (element.KUR! * widget.stokkart.guncelDegerler!.netfiyat!)
                  .toStringAsFixed(2);
          dovizFiyatController.text =  Ctanim.noktadanSonraAlinacakParametreli(KdovizFiyat!, widget.stokkart.guncelDegerler!.netfiyat!);
            
        } else {
          geciciFiyatTut =
              (element.KUR! * widget.stokkart.guncelDegerler!.netfiyat!)
                  .toStringAsFixed(2);
        }
      }

      para_birim.add(element.ACIKLAMA!);
      if (element.ANABIRIM == "E") {
        anaBirim = element;
        if (seciliParaBirimi == element.ACIKLAMA) {
          readOnly = true;
          enableDisableColor = Colors.grey;
          kurController.text = "1.0";
          dovizFiyatController.text = "0.0";
          setState(() {});
        }
      }
    }
    fiyatListesi.addAll(Ctanim.satisFiyatListesi);


    fiyatCont.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, widget.fiyat);  

    isk1Controller.text = Ctanim.donusturMusteri(widget.iskonto.toString());
    isk2Controller.text = "0,00";
    List<dynamic> donenList = stokKartEx.fiyatgetir(
        widget.stokkart,
        widget.cariKod,
        seciliFiyat,
       );

    fiyatController = TextEditingController(text: donenList[0].toString());
    brutFiyatController = widget.urunListedenMiGeldin==false? TextEditingController(text: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!,(widget.stokkart.guncelDegerler!.fiyat!*double.parse(kurController.text)))):
    TextEditingController(text: Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!,widget.fiyat));
    ;

    fiyatCont.text =  Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, double.tryParse(geciciFiyatTut)??0.0);

    seciliFiyat = donenList[2].toString();

    iskonto = double.parse(donenList[1].toString());
    fiyatDegistirebilsin = donenList[3];

    iskontoController = TextEditingController(text: iskonto.toString());
    adetController = TextEditingController();
    adetController.text = widget.miktar.toString();
    iskontoluFiyatHesapla();
    hesaplaDovizKurFiyat(degisenControllerAdiTamYaz: "fiyatCont");
  }

  @override
  void dispose() {
    fiyatController.dispose();
    iskontoController.dispose();
    super.dispose();
  }
 

  bool? readOnly;
  Color? enableDisableColor;
  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double fontSize = 16 + (widget.stokAdi.length / 5);
    double textLenght = widget.stokAdi.length.toDouble() * 2;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        insetPadding: EdgeInsets.all(10),
        title: SizedBox(
          width: x * .8,
          child: Row(
            children: [
              const Text("Stok Düzenleme"),
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
                alignment: Alignment.center,
              )
            ],
          ),
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
                    height: textLenght,
                    child: Container(
                      child: Text(
                        widget.stokAdi,
                        style: TextStyle(
                          fontSize: fontSize - 3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: x * .02),
                    child: Column(
                      children: [
                        Text(
                          "Miktar",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    int a = int.parse(adetController.text);
                                    if (a > 0) {
                                      a = a -
                                          int.parse(widget
                                              .stokkart.guncelDegerler!.carpan!
                                              .toString()
                                              .split(".")[0]);
                                      adetController.text = a.toString();
                                    }
                                  });
                                },
                                backgroundColor: Colors.red,
                                child: Icon(Icons.remove),
                              ),
                              SizedBox(
                                width: x * .3,
                                child: TextField(
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  controller: adetController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  int a = int.parse(adetController.text);
                                  a = a +
                                      int.parse(widget
                                          .stokkart.guncelDegerler!.carpan!
                                          .toString()
                                          .split(".")[0]);
                                  adetController.text = a.toString();
                                },
                                backgroundColor: Colors.green,
                                child: Icon(Icons.add),
                              ),
                            ]),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: x * .02),
                          child: Text(
                            "Fiyat Düzenlemeleri",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: x * .3,
                                      child: Text(
                                        "Fiyat Seç",
                                        style: TextStyle(fontSize: 17),
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
                                          child: Text("Birim",
                                              style: TextStyle(fontSize: 17))),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: x * .03,
                                left: x * .05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: x * .3,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: seciliFiyat,
                                          items: fiyatListesi
                                              .map((e) =>
                                                  DropdownMenuItem<String>(
                                                      value: e, child: Text(e)))
                                              .toList(),
                                          onChanged: fiyatDegistirebilsin ==
                                                  true
                                              ? (value) {
                                                  seciliFiyat = value!;
                                                  setState(() {
                                                    List<dynamic> donenListe =
                                                        stokKartEx.fiyatgetir(
                                                            widget.stokkart,
                                                            widget.cariKod
                                                                .toString(),
                                                            seciliFiyat,
                                                      );

                                                    if (widget.stokkart
                                                            .SATDOVIZ ==
                                                        anaBirim!.ACIKLAMA!) {
                                                      fiyatCont.text =
                                                         Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, donenListe[0]);

                                                      widget
                                                              .stokkart
                                                              .guncelDegerler!
                                                              .fiyat =
                                                          donenListe[0];
                                                      fiyatController.text =
                                                         Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, donenListe[0]);
                                                      fiyatCont.text =
                                                        Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, donenListe[0]);
                                                      widget
                                                              .stokkart
                                                              .guncelDegerler!
                                                              .netfiyat =
                                                          widget.stokkart
                                                              .guncelDegerler!
                                                              .hesaplaNetFiyat();
                                                      hesaplaDovizKurFiyat(
                                                          degisenControllerAdiTamYaz:
                                                              "fiyatCont");
                                                    } else {
                                                      KurModel? seciliKur;
                                                      for (var element
                                                          in listeler.listKur) {
                                                        if (seciliParaBirimi ==
                                                            element.ACIKLAMA) {
                                                          seciliKur = element;
                                                        }
                                                      }
                                                      double tempFiyat = 0.0;
                                                      double tempDovizFiyat =
                                                          0.0;
                                                      print(seciliKur!.KUR!
                                                          .toString());

                                                      tempFiyat = (double.tryParse(
                                                              donenListe[0]
                                                                  .toString())! *
                                                          stokKur!.KUR!);
                                                      if (seciliKur.ACIKLAMA !=
                                                          stokKur!.ACIKLAMA!) {
                                                        tempFiyat = tempFiyat /
                                                            seciliKur!.KUR!;
                                                      }

                                                      fiyatCont.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, tempFiyat);
                                                      dovizFiyatController
                                                              .text =
                                                          donenListe[0]
                                                              .toString();

                                                      widget
                                                          .stokkart
                                                          .guncelDegerler!
                                                          .fiyat = tempFiyat;
                                                      fiyatController.text =
                                                           Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, tempFiyat);
                                                      fiyatCont.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, tempFiyat);
                                                      widget
                                                              .stokkart
                                                              .guncelDegerler!
                                                              .netfiyat =
                                                          widget.stokkart
                                                              .guncelDegerler!
                                                              .hesaplaNetFiyat();
                                                      // hesaplaDovizKurFiyat(degisenControllerAdiTamYaz: "fiyatCont");
                                                    }

                                                    setState(() {});
                                                  });
                                                }
                                              : null),
                                    ),
                                  ),
                                  SizedBox(
                                      width: x * .05,
                                      child: Text(" ",
                                          style: TextStyle(fontSize: 17))),
                                  Padding(
                                    padding: EdgeInsets.only(left: x * .05),
                                    child: SizedBox(
                                      width: x * .25,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            value: selectedItem,
                                            items: birimler
                                                .map((e) =>
                                                    DropdownMenuItem<String>(
                                                        value: e,
                                                        child: Text(e)))
                                                .toList(),
                                            onChanged: (e) => setState(() {
                                                  selectedItem = e;
                                                })),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
                                    "Döviz",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                    width: x * 0.05,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 2,
                                      indent: 10,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: x * .05),
                                  child: SizedBox(
                                      width: x * .25,
                                      child: Text("Kur",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: enableDisableColor))),
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
                                width: x * .3,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: seciliParaBirimi,
                                      items: para_birim
                                          .map((e) => DropdownMenuItem<String>(
                                              value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (e) {
                                        seciliDovizAdi = e;
                                        String anaBirim = "";
                                        seciliParaBirimi = e!;
                                        for (var element in listeler.listKur) {
                                          if (element.ANABIRIM == "E") {
                                            anaBirim = element.ACIKLAMA!;
                                          }
                                        }

                                        if (e == anaBirim) {
                                          readOnly = true;
                                          enableDisableColor = Colors.grey;
                                          kurController.text = "1.0";
                                          dovizFiyatController.text = "0.0";
                                        } else {
                                          double kur = 0.0;
                                          for (var element
                                              in listeler.listKur) {
                                            if (e == element.ACIKLAMA) {
                                              kur = element.KUR!;
                                            }
                                          }
                                          readOnly = false;
                                          enableDisableColor = Colors.black;
                                          kurController.text =  Ctanim.noktadanSonraAlinacakParametreli(Kkur!, kur);       
                                          dovizFiyatController
                                              .text = (double.parse(
                                                      fiyatController.text) /
                                                  double.parse(
                                                      kurController.text))
                                              .toStringAsFixed(4);
                                          fiyatCont.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!,   ((double.tryParse(
                                                          dovizFiyatController
                                                              .text) ??
                                                      0.0) *
                                                  (double.parse(
                                                      kurController.text))));
                                          
                                    

                                          setState(() {});
                                        }
                                        // seçili fiyatı fonksiyondan al
                                        setState(() {});
                                      }),
                                ),
                              ),
                              SizedBox(
                                  width: x * .05,
                                  child: Text(" ",
                                      style: TextStyle(fontSize: 17))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .05),
                                child: SizedBox(
                                  width: x * .25,
                                  child: TextField(
                                    enabled:
                                        Ctanim.kullanici!.FIYATDEGISTIRILSIN ==
                                                "E"
                                            ? true
                                            : false,
                                    readOnly: readOnly!,
                                    onChanged: (value) {
                                      hesaplaDovizKurFiyat(
                                          degisenControllerAdiTamYaz:
                                              "kurController");
                                      setState(() {});
                                    },
                                    controller: kurController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*'))
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "1,00",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                    "Döviz Fiyat",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: enableDisableColor),
                                  ),
                                ),
                                SizedBox(
                                    width: x * 0.05,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 2,
                                      indent: 10,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: x * .05),
                                  child: SizedBox(
                                      width: x * .25,
                                      child: Text("Net Fiyat",
                                          style: TextStyle(fontSize: 17))),
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
                                width: x * .3,
                                child: TextField(
                                  enabled:
                                      Ctanim.kullanici!.FIYATDEGISTIRILSIN ==
                                              "E"
                                          ? true
                                          : false,
                                  readOnly: readOnly!,
                                  onChanged: (value) {
                                    hesaplaDovizKurFiyat(
                                        degisenControllerAdiTamYaz:
                                            "dovizFiyatController");
                                    setState(() {});
                                  },
                                  controller: dovizFiyatController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'))
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "1,00",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: x * .05,
                                  child: Text(" ",
                                      style: TextStyle(fontSize: 17))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .05),
                                child: SizedBox(
                                  width: x * .25,
                                  child: TextFormField(
                                    enabled:
                                       
                                             true,
                                    onChanged: (value) {
                                      /*
                                      hesaplaDovizKurFiyat(
                                          degisenControllerAdiTamYaz:
                                              "fiyatCont");
                                      setState(() {});
                                      */
                                    },
                                    readOnly: true,
                                    controller: fiyatCont,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*'))
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        /*
                                        counterText: (widget
                                                        .stokkart
                                                        .guncelDegerler!
                                                        .fiyat! *
                                                    stokKur!.KUR!)
                                                .toStringAsFixed(2) +
                                            " TL",
                                        counterStyle:
                                            TextStyle(color: Colors.red)*/),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                    "Brüt Fiyat",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: enableDisableColor),
                                  ),
                                ),
                                SizedBox(
                                    width: x * 0.05,
                                    child: VerticalDivider(
                                      color: Colors.blue,
                                      thickness: 2,
                                      indent: 10,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: x * .05),
                                  child: SizedBox(
                                      width: x * .25,
                                      child: Text("",
                                          style: TextStyle(fontSize: 17))),
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
                                width: x * .3,
                                child: TextFormField(
                                    enabled:
                                        Ctanim.kullanici!.FIYATDEGISTIRILSIN ==
                                                "E"
                                            ? true
                                            : false,
                                    onChanged: (value) {
                                      hesaplaDovizKurFiyat(
                                          degisenControllerAdiTamYaz:
                                              "fiyatCont");
                                              iskontoluFiyatHesapla();
                                           //   fiyatController.text = ((double.tryParse(value)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!)*iskonto1Gec)/100).toString();
                                      setState(() {});
                                    },
                                    controller: brutFiyatController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*'))
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: (widget
                                                        .stokkart
                                                        .guncelDegerler!
                                                        .fiyat! *
                                                    stokKur!.KUR!)
                                                .toStringAsFixed(2) +
                                            " TL",
                                        counterStyle:
                                            TextStyle(color: Colors.red)),
                                  ),
                              ),
                              SizedBox(
                                  width: x * .05,
                                  child: Text(" ",
                                      style: TextStyle(fontSize: 17))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .05),
                                child: SizedBox(
                                  width: x * .25,
                                  child:Container()
                                ),
                              ),
                            ],
                          ),
                        ),
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
                    "İskonto Düzenlemeleri",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: x * .03,
                    left: x * .07,
                  ),
                  child: Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                 SizedBox(
                                width: x * .3,
                                child: Text(
                                  "İSK 1",
                                  style: TextStyle(fontSize: 17),
                                ),
                              )
                            ,
                        SizedBox(
                            width: x * 0.05,
                            child: VerticalDivider(
                              color: Colors.blue,
                              thickness: 2,
                              indent: 10,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: x * .05),
                          child: SizedBox(
                                  width: x * .25,
                                  child: Text("İSK 2",
                                      style: TextStyle(fontSize: 17)))
                             
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
                              width: x * .3,
                              child: TextField(
                                onChanged: (value) {
                                  iskontoluFiyatHesapla();
                                },
                                enabled:
                                        true,
                              
                                controller: isk1Controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*'))
                                ],
                                decoration: InputDecoration(
                                  hintText: "1,00",
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                    ,
                      SizedBox(
                          width: x * .05,
                          child: Text(" ", style: TextStyle(fontSize: 17))),
                      Padding(
                        padding: EdgeInsets.only(left: x * .05),
                        child: 
                           SizedBox(
                                width: x * .25,
                                child: TextField(
                                  focusNode: _focusNode,
                                  onChanged: (value) {
                                    if(isk1Controller.text == ""){
                                        showAlertDialog(context,
                                        "İskonto1 değeri boşken İskonto2 değeri değiştirilemez!");


                                    }else{
                                             String yeniFiyat = "";
                                    if (value== "") {
                                      yeniFiyat = fiyatTutucuForIsk2
                                          .toStringAsFixed(2);
                                       

                                    } else {
                                      yeniFiyat = (fiyatTutucuForIsk2 -
                                              ((double.tryParse(value)! *
                                                      fiyatTutucuForIsk2) /
                                                  100))
                                          .toStringAsFixed(2);
                                       
                                    }

                                    fiyatCont.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, double.tryParse(yeniFiyat)??0.0);
                                    fiyatController.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, double.tryParse(yeniFiyat)??0.0);
                                    setState(() {});

                                    }
                             
                                  },
                                  onTap: () {
                                    if (_focusNode.hasFocus) {
                                      isk2Controller.selection = TextSelection(
                                          baseOffset: 0,
                                          extentOffset: isk2Controller.text.length);
                                    }
                                  },
                                  enabled:
                                    true,
                                        
                                  controller: isk2Controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                       RegExp(r'^\d*\.?\d*'))
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "1,00",
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                       
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(top: x * .02),
                  child: Text(
                    "Ürün Açıklamaları",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                            "KDV",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        SizedBox(
                            width: x * 0.05,
                            child: VerticalDivider(
                              color: Colors.blue,
                              thickness: 2,
                              indent: 10,
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: x * .05),
                          child: SizedBox(
                              width: x * .25,
                              child: Text("Teslim Tarihi",
                                  maxLines: 2, style: TextStyle(fontSize: 17))),
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
                        width: x * .3,
                        child: TextField(
                          controller: KDVOranController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: "1,00",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                          width: x * .05,
                          child: Text(" ", style: TextStyle(fontSize: 17))),
                      Padding(
                        padding: EdgeInsets.only(left: x * .03),
                        child: SizedBox(
                          width: x * .30,
                          child: ElevatedButton(
                            child: Text(
                                '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
                            onPressed: () async {
                              final date = await pickDate();
                              if (date == null) return;
                              setState(() {
                                dateTime = date;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: x * .1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    height: 70,
                    child: TextFormField(
                      controller: aciklama,
                      maxLength: 250,
                      maxLines: 5,
                      decoration: InputDecoration(hintText: "AÇIKLAMA..."),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: x * .1),
                  child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            int birimID = -1;
                            for (var element in listeler.listOlcuBirim) {
                              if (selectedItem == element.ACIKLAMA) {
                                birimID = element.ID!;
                              }
                            }
                            int dovizID = -1;
                            double kur = 0.0;
                            String dovizAdi = "";
                            listeler.listKur.forEach((element) {
                              if (element.ACIKLAMA == seciliDovizAdi) {
                                dovizID = element.ID!;
                                kur = element.KUR!;
                                dovizAdi = element.ACIKLAMA!;
                              }
                            });
                            if (readOnly == true) {
                              kurController.text = "1";
                            } else if (readOnly == false &&
                                kurController.text == "") {
                              showAlertDialog(context,
                                  "Döviz Tipi TL olmadığından Kur Alanı Boş Olamaz!");
                            }
                            fisEx.fiseStokEkle(
                              belgeTipi: widget.belgeTipi,
                                urunListedenMiGeldin:
                                    widget.urunListedenMiGeldin,
                                KDVOrani: double.parse(
                                    KDVOranController.text), //alınmıyor

                                birim: selectedItem.toString(),
                              birimID: birimID, //cTanima bir map yapılacak
                                dovizAdi: dovizAdi,
                                dovizId: dovizID, // map yapılacak
                                burutFiyat:
                                 double.parse(brutFiyatController.text),
                                iskonto:
                                    double.parse(donusturDouble(isk1Controller.text)),
                                iskonto2:
                                    double.parse(donusturDouble(isk2Controller.text)),
                                miktar: int.parse(adetController.text),
                                stokAdi: widget.stokAdi,
                                stokKodu: widget.stokKodu,
                                Aciklama1: aciklama.text,
                                KUR: kur,
                                TARIH: dateTime.toString(),
                                UUID: fisEx.fis!.value.UUID!);
                            Ctanim.genelToplamHesapla(fisEx);
                            print(selectedItem);
                            Get.back(
                                result: hesaplaToplamTutar(adetController,
                                    fiyatController, iskontoController));
                          },
                          child: Text("Ürünü Ekle"))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void iskontoluFiyatHesapla() {
 String yeniFiyat = "";
       
    if (isk1Controller.text == "") {
      yeniFiyat = (double.tryParse(brutFiyatController.text)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!))
          .toStringAsFixed(2);
          fiyatTutucuForIsk2 = (double.tryParse(brutFiyatController.text)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!));
    } else {
      yeniFiyat = ((double.tryParse(brutFiyatController.text)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!)) -
              ((double.tryParse(donusturDouble(isk1Controller.text ))! *
                     (double.tryParse(brutFiyatController.text)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!))) /
                  100))
          .toStringAsFixed(2);
          fiyatTutucuForIsk2 =  ((double.tryParse(brutFiyatController.text)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!)) -
              ((double.tryParse(donusturDouble(isk1Controller.text ))! *
                     (double.tryParse(brutFiyatController.text)??(widget.stokkart.guncelDegerler!.fiyat!*stokKur!.KUR!))) /
                  100));
    }
    
    fiyatCont.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, double.tryParse(yeniFiyat)??0.0);
    fiyatController.text = Ctanim.noktadanSonraAlinacakParametreli(Kfiyat!, double.tryParse(yeniFiyat)??0.0);
    
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      //locale: const Locale('tr', 'TR'),
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  showAlertDialog(BuildContext context, String mesaj) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hatalı İşlem!"),
      content: Text(mesaj),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
