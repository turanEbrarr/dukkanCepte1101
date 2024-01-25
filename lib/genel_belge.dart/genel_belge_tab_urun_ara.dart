import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';
import 'package:dukkan_cepte/genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';
import 'package:dukkan_cepte/genel_belge.dart/genel_belge_stok_kart_guncelleme.dart';
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/webservis/kurModel.dart';

import 'package:dukkan_cepte/widget/String_tanim.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:path/path.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controllers/cariController.dart';
import '../controllers/stokKartController.dart';

import '../faturaFis/fisHareket.dart';

import '../stok_kart/stok_kart_detay_guncel.dart';
import '../widget/cari.dart';

enum SampleItem { itemOne, itemTwo, itemThere, itemFour, itemFife }

class genel_belge_tab_urun_ara extends StatefulWidget {
  const genel_belge_tab_urun_ara({
    super.key,
    required this.cariKod,

    required this.belgeTipi,
  });
  final String? cariKod;

  final String belgeTipi;

  @override
  State<genel_belge_tab_urun_ara> createState() =>
      _genel_belge_tab_urun_araState();
}

class _genel_belge_tab_urun_araState extends State<genel_belge_tab_urun_ara> {
  TextEditingController editingController = TextEditingController(text: "");

  late String alinanString;
  String result = '';
  DateTime now = DateTime.now();
  final StokKartController stokKartEx = Get.find();
  final CariController cariEx = Get.find();
  final FisController fisEx = Get.find();
  List<String> fiyatListesi = [];
  List<StokKart> tempTempStok = [];
  TextEditingController aramaCont = TextEditingController();

  String seciliFiyat =
      Ctanim.satisFiyatListesi.isNotEmpty ? Ctanim.satisFiyatListesi[0] : "-";
  TextStyle boldBlack =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  SampleItem? selectedMenu;
  List<String> markalar = [];

  KUSURAT? Kfiyat;
  KUSURAT? Kmiktar;
  KUSURAT? Kkur;
  KUSURAT? KdovizFiyat;
  KUSURAT? Ktutar;
  KUSURAT? KdovTutar;
  late StreamSubscription<bool> keyboardSubscription;
  var keyboardVisibilityController = KeyboardVisibilityController();
  String? texIci;
  int kont = 0;

  @override
  void initState() {
    int tip = Ctanim().MapFisTip[widget.belgeTipi] ?? 0;
    super.initState();
    Ctanim.fiyatListesiKosul.clear();
    Ctanim.seciliCariKodu = widget.cariKod!;
    fiyatListesi.addAll(Ctanim.satisFiyatListesi);
    Ctanim.fiyatListesiKosul.addAll(fiyatListesi);
    fisEx.fis!.value.ALTHESAP = "NORMAL";
    fisEx.fis!.value.ALTHESAPID = 0;
    if (tip == 3 || tip == 12 || tip == 17) {
      Kfiyat = KUSURAT.ALISFIYAT;
      Kmiktar = KUSURAT.ALISMIKTAR;
      Kkur = KUSURAT.ALISKUR;
      KdovizFiyat = KUSURAT.ALISDOVFIYAT;
      Ktutar = KUSURAT.ALISTUTAR;
      KdovTutar = KUSURAT.ALISDOVTUTAR;
    } else if (tip == 1 || tip == 4 || tip == 6) {
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
/*
    int kalan = 0;
    double ilk = stokKartEx.searchList.length / 100;
    int kacTam = int.parse(ilk.toString().split(".")[0]);
    kalan = stokKartEx.searchList.length % 20;
    List<List<StokKart>> parcali = [];
    int b = 0;
    if (kalan != 0) {
      kacTam += 1;
    }
    for (int i = 0; i < kacTam; i++) {
      if (b + 100 <= stokKartEx.searchList.length) {
        parcali.add(stokKartEx.searchList.sublist(b, b + 100));
        b = b + 100;
      } else {
        parcali.add(
            stokKartEx.searchList.sublist(b, stokKartEx.searchList.length));
      }
    }

    // bagla(parcali);
    
    final iterator = stokKartEx.searchList.iterator;

    while (iterator.moveNext()) {
      final item = iterator.current;
      // Tek tek öğeleri işleyebilirsiniz

      conList.add(TextEditingController(text: "1"));

      List<dynamic> gelenFiyatVeIskonto =
          stokKartEx.fiyatgetir(item, widget.cariKod!, fiyatListesi[0]);

      item.guncelDegerler!.fiyat =
          double.parse(gelenFiyatVeIskonto[0].toString());
      item.guncelDegerler!.iskonto =
          double.parse(gelenFiyatVeIskonto[1].toString());
      item.guncelDegerler!.seciliFiyati = gelenFiyatVeIskonto[2].toString();
      item.guncelDegerler!.fiyatDegistirMi = gelenFiyatVeIskonto[3];

      item.guncelDegerler!.netfiyat = item.guncelDegerler!.hesaplaNetFiyat();
      if (!fiyatListesiKosul.contains(item.guncelDegerler!.seciliFiyati)) {
        fiyatListesiKosul.add(item.guncelDegerler!.seciliFiyati);
      }
    }

 */

    stokKartEx.tempList.clear();
    if (stokKartEx.searchList.length > 100) {
      for (int i = 0; i < 100; i++) {


        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.searchList[i],
            widget.cariKod!,
            fiyatListesi[0],
          );

        stokKartEx.searchList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());
        stokKartEx.searchList[i].guncelDegerler!.iskonto =
            double.parse(gelenFiyatVeIskonto[1].toString());
        stokKartEx.searchList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.searchList[i].KOD;
        stokKartEx.searchList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.searchList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1.0;

        stokKartEx.searchList[i].guncelDegerler!.netfiyat =
            stokKartEx.searchList[i].guncelDegerler!.hesaplaNetFiyat();
        //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati!);
        }
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    } else {
      for (int i = 0; i < stokKartEx.searchList.length; i++) {
        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.searchList[i],
            widget.cariKod!,
            fiyatListesi[0],
            );
        stokKartEx.searchList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.searchList[i].KOD;
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1.0;
        stokKartEx.searchList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto =
            double.parse(gelenFiyatVeIskonto[1].toString());
        stokKartEx.searchList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.searchList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];

        stokKartEx.searchList[i].guncelDegerler!.netfiyat =
            stokKartEx.searchList[i].guncelDegerler!.hesaplaNetFiyat();
        //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati!);
        }
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    }
    tempTempStok.addAll(stokKartEx.tempList);
    for (var element in stokKartEx.searchList) {
      if (!markalar.contains(element.MARKA) && element.MARKA != "") {
        markalar.add(element.MARKA!);
        Ctanim.seciliMarkalarFiltreMap.add({false: element.MARKA!});
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stokKartEx.searchB("");
    Ctanim.secililiMarkalarFiltre.clear();
    Ctanim.seciliMarkalarFiltreMap.clear();
  }

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*
            Container(
              color: const Color.fromARGB(255, 121, 184, 240),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Obx(
                    () => Text(
                      "Listelenen Stok:   ${stokKartEx.searchList.length}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.refresh_outlined,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
            */
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 8, right: 8),
                    child: TextField(
                      onChanged: ((value) {
                        stokKartEx.searchB(value);
                      }),
                      controller: editingController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Aranacak kelime (İsim/Kod/Marka)",
                          hintStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SimpleBarcodeScannerPage(),
                          ));
                      setState(() {
                        if (res is String) {
                          result = res;
                          editingController.text = result;
                        }
                       stokKartEx.searchB(result);
                      });
                    },
                  ),
                ),
                PopupMenuButton<SampleItem>(
                  icon: Icon(Icons.filter_list),
                  onOpened: () {},
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (SampleItem item) {
                    setState(() {
                      selectedMenu = item;
                    });
                  },

                  itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.itemOne,
                      onTap: () {
                        stokKartEx.tempList
                            .sort((a, b) => b.BAKIYE!.compareTo(a.BAKIYE!));
                        tempListFiltre();
                        setState(() {});
                      },
                      child: Text('Bakiye Azalan'),
                    ),
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.itemTwo,
                      child: Text('Bakiye Artan'),
                      onTap: () {
                        stokKartEx.tempList
                          ..sort((a, b) => a.BAKIYE!.compareTo(b.BAKIYE!));
                        tempListFiltre();
                      },
                    ),
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.itemThere,
                      child: Text('Bakiyesi Eksi Olanlar'),
                      onTap: () {
                        stokKartEx.tempList.clear();
                        stokKartEx.tempList.addAll(tempTempStok);
                        stokKartEx.tempList
                            .removeWhere((cari) => cari.BAKIYE! >= 0);
                        tempListFiltre();
                        setState(() {});
                      },
                    ),
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.itemFour,
                      child: Text('Bakiyesi Artı Olanlar'),
                      onTap: () {
                        stokKartEx.tempList.clear();
                        stokKartEx.tempList.addAll(tempTempStok);
                        stokKartEx.tempList
                            .removeWhere((cari) => cari.BAKIYE! < 0);
                        tempListFiltre();
                        setState(() {});
                      },
                    ),
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.itemFife,
                      child: Text('Marka Filtresi Uygula'),
                      onTap: () {
                        Future.delayed(
                            Duration.zero,
                            () => showDialog(
                                context: context,
                                builder: (_) {
                                  return markaFiltre(
                                  
                                      cariKod: widget.cariKod!,
                                      aramaCont: aramaCont,
                                      markalar: Ctanim.seciliMarkalarFiltreMap);
                                }));
                      },
                    ),
                  ],
                ),
              ],
            ),
            Ctanim.yatayDikey == false
                ? urunAraDikeyTasarim(context, y, x)
                : urunAraYatayTasarim(context, y, x)
          ],
        ),
      ),
    );
  }

  SizedBox urunAraYatayTasarim(BuildContext context, double y, double x) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .70,
      child: Obx(() => ListView.builder(
          itemCount: stokKartEx.tempList.length,
          itemBuilder: (context, index) {
            StokKart stokKart = stokKartEx.tempList[index];
            TextEditingController t1 = TextEditingController();
            var miktar = stokKart.guncelDegerler!.carpan.obs;
            t1.text = stokKart.guncelDegerler!.carpan.toString();
            KurModel stokKartKur =
                KurModel(ID: -1, ACIKLAMA: "-", KUR: 1, ANABIRIM: "H");
        

            print("S" + stokKartEx.tempList.length.toString());
            return Padding(
              padding: EdgeInsets.all(8),
              child: Card(
                elevation: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: x * .2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                width: x * .2,
                                child: Text(
                                  stokKart.ADI!,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: x * .09,
                                    child: Text("Ürün Kodu:",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500))),
                                Padding(
                                  padding: EdgeInsets.only(left: x * .005),
                                  child: SizedBox(
                                      width: x * .09,
                                      child: Text(stokKart.KOD!)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: x * .09,
                                      child: Text("Marka:",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500))),
                                  Padding(
                                    padding: EdgeInsets.only(left: x * .005),
                                    child: SizedBox(
                                        width: x * .09,
                                        child: Text(stokKart.MARKA == "" ||
                                                stokKart.MARKA == null
                                            ? "-"
                                            : stokKart.MARKA!)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: x * .05,
                    ),
                    SizedBox(
                      width: x * .15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: x * .06,
                                  child: Text("Fiyat Seç:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width: x * .06,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        value: stokKartEx.tempList[index]
                                            .guncelDegerler!.seciliFiyati,
                                        items: stokKartEx
                                                    .tempList[index]
                                                    .guncelDegerler!
                                                    .fiyatDegistirMi ==
                                                false
                                            ? Ctanim.fiyatListesiKosul
                                                .map((e) =>
                                                    DropdownMenuItem<String>(
                                                        value: e,
                                                        child: Text(e)))
                                                .toList()
                                            : fiyatListesi
                                                .map((e) =>
                                                    DropdownMenuItem<String>(
                                                        value: e,
                                                        child: Text(e)))
                                                .toList(),
                                        onChanged: stokKartEx
                                                    .tempList[index]
                                                    .guncelDegerler!
                                                    .fiyatDegistirMi ==
                                                true
                                            ? (value) {
                                                setState(() {
                                                  List<dynamic> donenListe =
                                                      stokKartEx.fiyatgetir(
                                                          stokKart,
                                                          widget.cariKod
                                                              .toString(),
                                                          value!,
                                                         );
                                                  stokKartEx
                                                      .tempList[index]
                                                      .guncelDegerler!
                                                      .seciliFiyati = value;
                                                  stokKartEx
                                                      .tempList[index]
                                                      .guncelDegerler!
                                                      .fiyat = donenListe[0];
                                                  stokKartEx
                                                          .tempList[index]
                                                          .guncelDegerler!
                                                          .netfiyat =
                                                      stokKartEx.tempList[index]
                                                          .guncelDegerler!
                                                          .hesaplaNetFiyat();
                                                });
                                              }
                                            : null),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 9),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: x * .06,
                                  child: Text("Döviz Tipi:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(stokKartKur.ACIKLAMA ?? "-"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: x * .06,
                                  child: Text("Bakiye:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(Ctanim.noktadanSonraAlinacakParametreli(
                                    Kmiktar!, stokKart.BAKIYE!)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: x * .05,
                    ),
                    SizedBox(
                      width: x * .15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: x * .06,
                                child: Text(
                                  "Fiyat:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(Ctanim.noktadanSonraAlinacakParametreli(
                                  Kfiyat!,
                                  stokKartEx
                                      .tempList[index].guncelDegerler!.fiyat!)),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: x * .06,
                                  child: Text("İskonto:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(Ctanim.noktadanSonraAlinacakParametreli(
                                    Kfiyat!,
                                    stokKartEx.tempList[index].guncelDegerler!
                                        .iskonto!)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: x * .06,
                                  child: Text("Net Fiyat:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(Ctanim.noktadanSonraAlinacakParametreli(
                                    Kfiyat!,
                                    stokKartEx.tempList[index].guncelDegerler!
                                        .netfiyat!)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: x * .1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => Row(children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if (miktar.value! -
                                              stokKart.guncelDegerler!.carpan! >
                                          0) {
                                        miktar.value = miktar.value! -
                                            stokKart.guncelDegerler!.carpan!;
                                        print(miktar.value);
                                        t1.text = miktar.value!.toString();
                                      }
                                    },
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                                SizedBox(
                                  width: x * .1,
                                  child: TextFormField(
                                    controller: t1,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: miktar.value!.toString(),
                                        counterStyle: TextStyle(
                                            fontSize: 0, color: Colors.white)),
                                    keyboardType: TextInputType.number,
                                    onChanged: (newValue) {
                                      // TextFormField'dan gelen değeri miktar değişkenine atayın
                                      miktar.value =
                                          double.tryParse(newValue) ?? 0;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      miktar.value = miktar.value! +
                                          stokKart.guncelDegerler!.carpan!;
                                      t1.text = miktar.value!.toString();
                                    },
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: y * .04,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                  width: x * .15,
                                  height: y * .05,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    child: Text("Sepete Ekle"),
                                    onPressed: () {
                                      sepeteEkle(stokKart, stokKartKur, miktar);
                                      editingController.text = "";
                                    },
                                  )),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: x * .05),
                      child: Column(
                        children: [
                          IconButton(
                              iconSize: 35,
                              onPressed: () {
                                genelBelgeBottomSheet(index, context,
                                    stokKartKur, stokKart, miktar);
                              },
                              icon: Icon(Icons.more_vert)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }

  SizedBox urunAraDikeyTasarim(BuildContext context, double y, double x) {
    ScrollController _scrollController = ScrollController();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .70,
      child: Obx(() => ListView.builder(
          controller: _scrollController,
          itemCount: stokKartEx.tempList.length,
          itemBuilder: (context, index) {
            StokKart stokKart = stokKartEx.tempList[index];
            TextEditingController t1 = TextEditingController();
            var miktar = stokKart.guncelDegerler!.carpan.obs;

            t1.text = stokKart.guncelDegerler!.carpan.toString();



            KurModel? stokKartKur;


            for(var el in listeler.listKur){
              if(el.ACIKLAMA == stokKart.SATDOVIZ){
                stokKartKur = el;
              }
            }


          
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                elevation: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .70,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 20.0),
                            child: Text(
                              stokKart.ADI!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              genelBelgeBottomSheet(index, context, stokKartKur!,
                                  stokKart, miktar);
                            },
                            icon: Icon(Icons.more_vert))
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: y * .03,
                            left: x * .07,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: x * .25,
                                  child: Text("Ürün Kodu:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .1),
                                child: SizedBox(
                                    width: x * .5, child: Text(stokKart.KOD!)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: y * .01,
                            left: x * .07,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: x * .25,
                                  child: Text("Fiyat Seç:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .1),
                                child: SizedBox(
                                    width: x * .5,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          value: stokKartEx.tempList[index]
                                              .guncelDegerler!.seciliFiyati,
                                          items: stokKartEx
                                                      .tempList[index]
                                                      .guncelDegerler!
                                                      .fiyatDegistirMi ==
                                                  false
                                              ? Ctanim.fiyatListesiKosul
                                                  .map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Text(e)))
                                                  .toList()
                                              : fiyatListesi
                                                  .map((e) =>
                                                      DropdownMenuItem<String>(
                                                          value: e,
                                                          child: Text(e)))
                                                  .toList(),
                                          onChanged: stokKartEx
                                                      .tempList[index]
                                                      .guncelDegerler!
                                                      .fiyatDegistirMi ==
                                                  true
                                              ? (value) {
                                                  setState(() {
                                                    List<dynamic> donenListe =
                                                        stokKartEx.fiyatgetir(
                                                            stokKart,
                                                            widget.cariKod
                                                                .toString(),
                                                            value!,
                                                           );
                                                    stokKartEx
                                                        .tempList[index]
                                                        .guncelDegerler!
                                                        .seciliFiyati = value;
                                                    stokKartEx
                                                        .tempList[index]
                                                        .guncelDegerler!
                                                        .fiyat = donenListe[0];
                                                    stokKartEx
                                                            .tempList[index]
                                                            .guncelDegerler!
                                                            .netfiyat =
                                                        stokKartEx
                                                            .tempList[index]
                                                            .guncelDegerler!
                                                            .hesaplaNetFiyat();
                                                  });
                                                }
                                              : null),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: x * .07,
                            top: y * .01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: x * .25,
                                  child: Text("Döviz Tipi:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .1),
                                child: SizedBox(
                                    width: x * .5,
                                    child: Text(stokKartKur!.ACIKLAMA ?? "-")),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: x * .07,
                            top: y * .03,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: x * .25,
                                  child: Text("Marka:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                padding: EdgeInsets.only(left: x * .1),
                                child: SizedBox(
                                    width: x * .5,
                                    child: Text(stokKart.MARKA == "" ||
                                            stokKart.MARKA == null
                                        ? "-"
                                        : stokKart.MARKA!)),
                              ),
                            ],
                          ),
                        ),
                        stokKartEx.tempList.length > 1
                            ? Padding(
                                padding: EdgeInsets.only(
                                  left: x * .07,
                                  top: y * .03,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: x * .25,
                                        child: Text("Bakiye:",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500))),
                                    Padding(
                                      padding: EdgeInsets.only(left: x * .1),
                                      child: SizedBox(
                                          width: x * .5,
                                          child: Text(Ctanim
                                              .noktadanSonraAlinacakParametreli(
                                                  Kmiktar!, stokKart.BAKIYE!))),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
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
                                  width: x * .15,
                                  child: Text(
                                    "Fiyat",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                    width: x * .05,
                                    child: VerticalDivider(
                                      color: Colors.green,
                                      thickness: 2,
                                      indent: 10,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: x * .05),
                                  child: SizedBox(
                                      width: x * .15,
                                      child: Text("İskonto",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500))),
                                ),
                                SizedBox(
                                    width: x * .05,
                                    child: VerticalDivider(
                                      color: Colors.green,
                                      thickness: 2,
                                      indent: 10,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: x * .05, right: x * .05),
                                  child: SizedBox(
                                      width: x * .15,
                                      child: Text("Net Fiyat",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500))),
                                ),
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
                                  width: x * .15,
                                  child: Text(
                                      Ctanim.noktadanSonraAlinacakParametreli(
                                          Kfiyat!,
                                          stokKartEx.tempList[index]
                                              .guncelDegerler!.fiyat!))),
                              SizedBox(
                                  width: x * .05,
                                  child: VerticalDivider(
                                    color: Colors.transparent,
                                    thickness: 2,
                                    indent: 10,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: x * .05),
                                child: SizedBox(
                                    width: x * .15,
                                    child: Text(
                                        Ctanim.noktadanSonraAlinacakParametreli(
                                            Kfiyat!,
                                            stokKartEx.tempList[index]
                                                .guncelDegerler!.iskonto!))),
                              ),
                              SizedBox(
                                  width: x * .05,
                                  child: VerticalDivider(
                                    color: Colors.transparent,
                                    thickness: 2,
                                    indent: 10,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: x * .05, right: x * .04),
                                child: SizedBox(
                                  width: x * .15,
                                  child: Text(
                                      Ctanim.noktadanSonraAlinacakParametreli(
                                          Kfiyat!,
                                          stokKartEx.tempList[index]
                                              .guncelDegerler!.netfiyat!)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: x * .05, left: x * .07, bottom: x * .05),
                          child: Container(
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FloatingActionButton(
                                          onPressed: () {
                                            if (miktar.value! -
                                                    stokKart.guncelDegerler!
                                                        .carpan! >
                                                0) {
                                              miktar.value = miktar.value! -
                                                  stokKart
                                                      .guncelDegerler!.carpan!;
                                              print(miktar.value);
                                              t1.text =
                                                  miktar.value!.toString();
                                            }
                                          },
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.remove),
                                        ),
                                        //turan
                                        SizedBox(
                                          width: x * .15,
                                          child: TextFormField(
                                            autocorrect: true,
                                            controller: t1,
                                            onEditingComplete: () {},
                                            onTap: () {
                                              _scrollController.animateTo(
                                                _scrollController.offset + 50,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                              );
                                            },
                                            textAlign: TextAlign.right,
                                            decoration: InputDecoration(
                                                counterText:
                                                    miktar.value!.toString(),
                                                counterStyle: TextStyle(
                                                    fontSize: 0,
                                                    color: Colors.white)),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^[\d\.]*$')),
                                            ],
                                            onChanged: (newValue) {
                                              double gelen =
                                                  double.tryParse(newValue) ??
                                                      0;
                                              if (gelen > 0) {
                                                miktar.value = gelen;
                                              }
                                            },
                                          ),
                                        ),
                                        FloatingActionButton(
                                          onPressed: () {
                                            miktar.value = miktar.value! +
                                                stokKart
                                                    .guncelDegerler!.carpan!;
                                            t1.text = miktar.value!.toString();
                                          },
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.add),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: x * .05, right: x * .05),
                                  child: SizedBox(
                                      width: x * .3,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue),
                                        child: Text("Sepete Ekle"),
                                        onPressed: () {
                                          sepeteEkle(
                                              stokKart, stokKartKur!, miktar);
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }

  void genelBelgeBottomSheet(int index, BuildContext context,
      KurModel stokKartKur, StokKart stokKart, Rx<double?> miktar) {
    fisEx.listFisStokHareketGetir(stokKartEx.tempList[index].KOD!);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          /* height: MediaQuery.of(context)
                        .size
                        .height *
                    0.3,*/
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 3,
                indent: 150,
                endIndent: 150,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  Future.delayed(
                      Duration.zero,
                      () => showDialog(
                          context: context,
                          builder: (_) {
                            return genel_belge_stok_kart_guncellemeDialog(
                                belgeTipi: widget.belgeTipi,
                                stokKartKurAdi: stokKartKur.ACIKLAMA!,
                                urunListedenMiGeldin: false,
                                stokkart: stokKartEx.tempList[index],
                                stokAdi: stokKartEx.tempList[index].ADI!,
                                stokKodu:
                                    stokKart.guncelDegerler!.guncelBarkod!,
                                KDVOrani: stokKartEx.tempList[index].SATIS_KDV!,
                                cariKod: widget.cariKod.toString(),
                                fiyat: stokKart.guncelDegerler!.fiyat!,
                                iskonto: stokKart.guncelDegerler!.iskonto!,
                                miktar: miktar.value!.toInt());
                          }));
                },
                child: ListTile(
                  title: Text("Düzenle"),
                  leading: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Future.delayed(
                      Duration.zero,
                      () => showDialog(
                          context: context,
                          builder: (_) {
                            return genel_belge_gecmis_satis_bilgileri();
                          }));
                },
                child: ListTile(
                  title: Text("Geçmiş Satış Detayları"),
                  leading: Icon(
                    Icons.history,
                    color: Colors.amber,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Future.delayed(
                      Duration.zero,
                      () => showDialog(
                          context: context,
                          builder: (_) {
                            return stok_kart_detay_guncel(
                              stokKart: stokKart,
                            );
                          }));
                },
                child: ListTile(
                  title: Text("Stoğa Git"),
                  leading: Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void sepeteEkle(StokKart stokKart, KurModel stokKartKur, Rx<double?> miktar) {
    int birimID = -1;
    for (var element in listeler.listOlcuBirim) {
      if (stokKart.OLCUBIRIM1 == element.ACIKLAMA) {
        birimID = element.ID!;
      }
    }

    double? tempFiyat = stokKart.guncelDegerler!.fiyat;
    listeler.listKur.forEach((element) {
      if (element.ANABIRIM == "E") {
        if (stokKartKur.ACIKLAMA != element.ACIKLAMA) {
          tempFiyat = tempFiyat! * stokKartKur.KUR!;
        }
      }
    });

    double KDVTUtarTemp =
        stokKart.guncelDegerler!.fiyat! * (1 + (stokKart.SATIS_KDV!));
    {
      fisEx.fiseStokEkle(
        belgeTipi: widget.belgeTipi,
        urunListedenMiGeldin: false,
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: birimID,
        dovizAdi: stokKartKur.ACIKLAMA!,
        dovizId: stokKartKur.ID!,
        burutFiyat: tempFiyat!,
        iskonto: stokKart.guncelDegerler!.iskonto!,
        iskonto2: 0.0,
        miktar: (miktar.value)!.toInt(),
        stokKodu: stokKart.guncelDegerler!.guncelBarkod!,
        Aciklama1: '',
        KUR: stokKartKur.KUR!,
        TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        UUID: fisEx.fis!.value.UUID!,
      );
      Ctanim.genelToplamHesapla(fisEx);
      Get.snackbar(
        "Stok eklendi",
        (miktar.value).toString() + " adet ürün sepete eklendi ! ",
        //sepette ${sepettekiStok.length} adet stok var",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(milliseconds: 800),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      miktar.value = stokKart.guncelDegerler!.carpan;
      editingController.clear();
      setState(() {});
    }
  }

  void tempListFiltre() {
    for (int i = 0; i < stokKartEx.tempList.length; i++) {
      if (stokKartEx.tempList[i].guncelDegerler!.seciliFiyati == "") {
        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.tempList[i],
            widget.cariKod!,
            Ctanim.satisFiyatListesi.first,
        );
        stokKartEx.tempList[i].guncelDegerler!.carpan = 1.0;
        stokKartEx.tempList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.tempList[i].KOD!;
        stokKartEx.tempList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());
        stokKartEx.tempList[i].guncelDegerler!.iskonto =
            double.parse(gelenFiyatVeIskonto[1].toString());
        stokKartEx.tempList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.tempList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];

        stokKartEx.tempList[i].guncelDegerler!.netfiyat =
            stokKartEx.tempList[i].guncelDegerler!.hesaplaNetFiyat();
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.tempList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.tempList[i].guncelDegerler!.seciliFiyati!);
        }
      }
    }
  }

  @override
  List<Object?> get props => [
        editingController,
        alinanString,
        result,
        now,
        stokKartEx,
        cariEx,
        fisEx,
        fiyatListesi,
        tempTempStok,
        aramaCont,
        seciliFiyat,
        boldBlack,
        selectedMenu,
        markalar
      ];
}

class markaFiltre extends StatefulWidget {
  const markaFiltre({
    super.key,
    required this.aramaCont,
    required this.markalar,
    required this.cariKod,

  });

  final TextEditingController aramaCont;
  final List<Map<bool, String>>? markalar;
  final String cariKod;

  @override
  State<markaFiltre> createState() => _markaFiltreState();
}

class _markaFiltreState extends State<markaFiltre> {
  List<Map<bool, String>> markaIceri = [];
  List<bool> markaIceriBool = [];
  @override
  void initState() {
    // TODO: implement initState
    if (widget.markalar != null) {
      markaIceri.addAll(widget.markalar!);
      for (var element in widget.markalar!) {
        if (element.keys.first == true) {
          seciliMarkalarWidget.add(itemOlustur(element.values.first));
          seciliMarkalarString.add(element.values.first);
        }
      }
    }

    super.initState();
  }

  void searchB(String query) {
    markaIceri.clear();
    if (query.isEmpty) {
      if (widget.markalar != null) {
        markaIceri.addAll(widget.markalar!);
      }
    } else {
      markaIceri = widget.markalar!
          .where((map) =>
              map.values.first.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  List<Widget> seciliMarkalarWidget = [];
  List<String> seciliMarkalarString = [];
  Widget itemOlustur(String adi) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              adi,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 12,
            color: Colors.white,
            onPressed: () {
              seciliMarkalarString.remove(adi);
              int ii = 0;
              setState(() {
                removeCard(adi);
                for (int i = 0; i < widget.markalar!.length; i++) {
                  if (widget.markalar![i].values.first == adi) {
                    ii = i;
                  }
                }
                widget.markalar!.removeAt(ii);
                widget.markalar!.insert(ii, {false: adi});
                markaIceri.clear();
                markaIceri.addAll(widget.markalar!);
              });
            },
          ),
        ],
      ),
    );
  }

  void removeCard(String targetText) {
    setState(() {
      seciliMarkalarWidget.removeWhere((widget) {
        if (widget is Card && widget.child is Row) {
          Row rowWidget = widget.child as Row;
          if (rowWidget.children.length == 3) {
            if (rowWidget.children[0] is Padding &&
                rowWidget.children[2] is IconButton) {
              Padding paddingWidget = rowWidget.children[0] as Padding;
              Text textWidget = paddingWidget.child as Text;
              return textWidget.data == targetText;
            }
          }
        }
        return false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      insetPadding: EdgeInsets.zero,
      title: Text(
        "   Marka Filtresi Uygula",
        style: TextStyle(fontSize: 17),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              seciliMarkalarWidget.length > 0
                  ? SizedBox(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: seciliMarkalarWidget.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            return seciliMarkalarWidget[index];
                          },
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: widget.aramaCont,
                  onChanged: (value) {
                    searchB(value);
                    setState(() {});
                  },
                  cursorColor: Color.fromARGB(255, 30, 38, 45),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        color: Color.fromARGB(255, 30, 38, 45),
                        onPressed: () {},
                        icon: Icon(Icons.clear)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Color.fromARGB(255, 30, 38, 45))),
                    hintText: 'Marka Arayanız',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: ListView.builder(
                  itemCount: markaIceri.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isChecked = markaIceri[index].keys.first;
                    String text = markaIceri[index].values.first;
                    return Container(
                      //ASDFDFSDF
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              int ii = 0;

                              setState(() {
                                for (int i = 0;
                                    i < widget.markalar!.length;
                                    i++) {
                                  if (widget.markalar![i].values.first ==
                                      text) {
                                    ii = i;
                                  }
                                }

                                widget.markalar!.removeAt(ii);
                                widget.markalar!.insert(ii, {value!: text});
                                Ctanim.seciliMarkalarFiltreMap.removeAt(ii);
                                Ctanim.seciliMarkalarFiltreMap
                                    .insert(ii, {value: text});
                                markaIceri.clear();

                                markaIceri.addAll(widget.markalar!);

                                if (value == true) {
                                  if (!seciliMarkalarString.contains(text)) {
                                    seciliMarkalarString.add(text);
                                    seciliMarkalarWidget.add(itemOlustur(text));
                                  }
                                } else {
                                  if (seciliMarkalarString.contains(text)) {
                                    seciliMarkalarString.remove(text);
                                    removeCard(text);
                                  }
                                }
                              });
                            },
                          ),
                          Text(text),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: ElevatedButton(
                          child: Text(
                            "Tamam",
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 30, 38, 45),
                              shadowColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              )),
                          onPressed: () {
                            Ctanim.secililiMarkalarFiltre.clear();
                            Ctanim.secililiMarkalarFiltre
                                .addAll(seciliMarkalarString);
                            stokKartEx.searchB("");
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
