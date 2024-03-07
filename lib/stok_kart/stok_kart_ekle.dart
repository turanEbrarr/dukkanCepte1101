import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/modeller/olcuBirimModel.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../webservis/kurModel.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sHataModel.dart';
import 'Spinkit.dart';

class stok_kart_olustur extends StatefulWidget {
  const stok_kart_olustur({super.key});

  @override
  State<stok_kart_olustur> createState() => _stok_kart_olusturState();
}

class _stok_kart_olusturState extends State<stok_kart_olustur> {
  String result = '';
  OlcuBirimModel? seciliBirim;
  KurModel? seciliDoviz;
  TextEditingController urunIsmi = TextEditingController();
  TextEditingController urunBarkod = TextEditingController();
  TextEditingController sFiyat1 = TextEditingController();
  TextEditingController sFiyat2 = TextEditingController();
  TextEditingController sFiyat3 = TextEditingController();
  TextEditingController sFiyat4 = TextEditingController();
  TextEditingController sFiyat5 = TextEditingController();
  TextEditingController aFiyat1 = TextEditingController();
  TextEditingController sKDV = TextEditingController();
  TextEditingController aKDV = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (listeler.listOlcuBirim.isNotEmpty) {
      seciliBirim = listeler.listOlcuBirim.first;
    }
    if (listeler.listKur.isNotEmpty) {
      seciliDoviz = listeler.listKur.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Stok Kayıt"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Ürün Bilgileri",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Satir(labelText: "Ürün İsmi", controller: urunIsmi,keyboardTypeVarMi: false,),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 247, 245, 245),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: urunBarkod,
                  readOnly:
                      Ctanim.kullanici!.OTOMATIKSTOKKODU == "H" ? false : true,
                  cursorColor: Color.fromARGB(255, 60, 59, 59),
                  decoration: InputDecoration(
                      hintText: Ctanim.kullanici!.OTOMATIKSTOKKODU == "H"
                          ? ""
                          : "Otomatik Barkod Oluşturma Aktif",
                      suffixIcon: Ctanim.kullanici!.OTOMATIKSTOKKODU == "H"
                          ? GestureDetector(
                              onTap: () async {
                                var res = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SimpleBarcodeScannerPage(),
                                    ));
                                setState(() {
                                  if (res is String) {
                                    result = res;
                                    urunBarkod.text = result;
                                  }
                                });
                              },
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  "images/barkodTara.png",
                                ),
                              ),
                            )
                          : null,
                      label: Text(
                        "Barkod",
                        style: TextStyle(
                            color: Color.fromARGB(255, 60, 59, 59),
                            fontSize: 15),
                      ),
                      border: InputBorder.none),
                )),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Fiyat Bilgileri",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Birim Seçiniz"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(
                  8.0), // İstediğiniz padding değerini belirleyin
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 245, 245),
                // Kenarlık rengini ve kalınlığını ayarlayın
                borderRadius:
                    BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OlcuBirimModel>(
                    hint:
                        Text('Birim'), // Varsayılan olarak görüntülenecek metin
                    value: seciliBirim, // Seçili ülke değeri
                    onChanged: (newValue) {
                      setState(() {
                        seciliBirim = newValue;
                      });
                    },
                    items: listeler.listOlcuBirim.map((OlcuBirimModel country) {
                      return DropdownMenuItem<OlcuBirimModel>(
                        value: country,
                        child: Text(country.ACIKLAMA!),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Döviz Tipi Seçiniz"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(
                  8.0), // İstediğiniz padding değerini belirleyin
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 245, 245),
                // Kenarlık rengini ve kalınlığını ayarlayın
                borderRadius:
                    BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<KurModel>(
                    hint:
                        Text('Döviz'), // Varsayılan olarak görüntülenecek metin
                    value: seciliDoviz, // Seçili ülke değeri
                    onChanged: (newValue) {
                      setState(() {
                        seciliDoviz = newValue;
                      });
                    },
                    items: listeler.listKur.map((KurModel country) {
                      return DropdownMenuItem<KurModel>(
                        value: country,
                        child: Text(country.ACIKLAMA!),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Container(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .42,
                              child: Text("S.Fiyat 1")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text("S.Fiyat 2")),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: sFiyat1,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: sFiyat2,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .42,
                              child: Text("S.Fiyat 3")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text("S.Fiyat 4"))
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: sFiyat3,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: sFiyat4,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .42,
                              child: Text("S.Fiyat 5")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text("Alış Fiyatı")),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: sFiyat5,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: aFiyat1,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Container(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .42,
                              child: Text("Satış KDV")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .4,
                              child: Text("Alış KDV")),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: sKDV,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Satir(
                            labelText: "",
                            controller: aKDV,
                            keyboardTypeVarMi: true,
                            keyboardType: TextInputType.number,
                            sagaYaslansinMi: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Butonun arka plan rengi
                minimumSize: Size(MediaQuery.of(context).size.width * .8,
                    48), // Butonun minimum genişlik ve yükseklik değeri
              ),
              onPressed: () async {
                BaseService bs = BaseService();
                StokKart yeniStok = StokKart();
                yeniStok.ADI = urunIsmi.text;
                yeniStok.KOD = urunBarkod.text;
                yeniStok.OLCUBR1 = int.parse(seciliBirim!.ID!.toString());
                yeniStok.SATDOVIZ = seciliDoviz!.ACIKLAMA!;
                yeniStok.SFIYAT1 = double.parse(sFiyat1.text);
                yeniStok.SFIYAT2 = double.parse(sFiyat2.text);
                yeniStok.SFIYAT3 = double.parse(sFiyat3.text);
                yeniStok.SFIYAT4 = double.parse(sFiyat4.text);
                yeniStok.SFIYAT5 = double.parse(sFiyat5.text);
                yeniStok.AFIYAT1 = double.parse(aFiyat1.text);
              

                Map<String, dynamic> jsonListesi = yeniStok.toJson();

                setState(() {});
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LoadingSpinner(
                      color: Colors.black,
                      message: "Stok Kaydı Yapılıyor...",
                    );
                  },
                );
                SHataModel gelenHata = await bs.ekleStok(
                    jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
                if (gelenHata.Hata == "true") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          align: TextAlign.left,
                          title: 'Hata',
                          message:
                              'Ürün Kaydedilirken Hatayla Karşılaşıldı:\n' +
                                  gelenHata.HataMesaj.toString(),
                          onPres: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          buttonText: 'Geri',
                        );
                      });
                } else {
                  await VeriIslemleri().stokEkle(yeniStok);
                  await VeriIslemleri().stokGetir();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          align: TextAlign.left,
                          title: 'Başarılı',
                          message:
                              'Kayıt Başarıyla Tamamlandı. Kaydedilen Ürün Kodu:\n' +
                                  gelenHata.HataMesaj.toString(),
                          onPres: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          buttonText: 'Geri',
                        );
                      });
                }
              },
              child: Text(
                'Ürünü Kaydet',
                style: TextStyle(
                  color: Colors.white, // Buton metni rengi
                  fontSize: 16, // Buton metni font boyutu
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class Satir extends StatelessWidget {
  const Satir({
    super.key,
    required this.labelText,
    required this.controller,
    this.iconVarMi = false,
    this.keyboardType,
    this.keyboardTypeVarMi,
    this.sagaYaslansinMi = false,
  });
  final String labelText;
  final TextEditingController controller;
  final bool? iconVarMi;
  final bool? keyboardTypeVarMi;
  final bool? sagaYaslansinMi;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? bosInputFormatters = [];
    List<TextInputFormatter>? doluInputFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      FilteringTextInputFormatter.digitsOnly,
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 245, 245),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            keyboardType: keyboardTypeVarMi == true ? keyboardType : null,
            inputFormatters: keyboardTypeVarMi == false
                ? bosInputFormatters
                : doluInputFormatters,
            controller: controller,
            textAlign:
                sagaYaslansinMi == true ? TextAlign.right : TextAlign.left,
            cursorColor: Color.fromARGB(255, 60, 59, 59),
            decoration: InputDecoration(
                suffixIcon: iconVarMi == true
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          "images/barkodTara.png",
                        ),
                      )
                    : null,
                label: Text(
                  labelText,
                  style: TextStyle(
                      color: Color.fromARGB(255, 60, 59, 59), fontSize: 15),
                ),
                border: InputBorder.none),
          )),
    );
  }
}
