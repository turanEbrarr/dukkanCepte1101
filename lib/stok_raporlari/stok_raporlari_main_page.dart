import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/stok_raporlari/stok_bakiye_page.dart';
import 'package:dukkan_cepte/stok_raporlari/stok_depo_bakiye_raporu_page.dart';
import 'package:dukkan_cepte/webservis/base.dart';

import '../stok_kart/Spinkit.dart';
import '../widget/appbar.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';

class stok_raporlari_main_page extends StatefulWidget {
  const stok_raporlari_main_page({
    super.key,
    required this.widgetListBelgeSira,
  });
  final int widgetListBelgeSira;
  @override
  State<stok_raporlari_main_page> createState() =>
      _stok_raporlari_main_pageState();
}

class _stok_raporlari_main_pageState extends State<stok_raporlari_main_page> {
  BaseService bs = BaseService();
  List<Map<String, String>> stok_list = [
    {
      "Stok Kodu": "000522",
      "Stok Adı": "Parmak Rulo Sapı 10 cm",
      "Bakiye": "0.00",
      "Fiyat": "5.00",
      "Tutar": "5.00"
    },
    {
      "Stok Kodu": "001044",
      "Stok Adı": "Muadil Panasonic TU10J -1820 Toner",
      "Bakiye": "0.00",
      "Fiyat": "17.20",
      "Tutar": "17.20"
    },
    {
      "Stok Kodu": "000048",
      "Stok Adı": "Muadil Brother TN3487 Toner 20K",
      "Bakiye": "0.00",
      "Fiyat": "12.50",
      "Tutar": "275.00"
    },
  ];
  Color favIconColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    if (listeler.sayfaDurum[widget.widgetListBelgeSira] == true) {
      setState(() {
        favIconColor = Colors.amber;
      });
    } else {
      setState(() {
        favIconColor = Colors.white;
      });
    }

    return Scaffold(
        appBar: MyAppBar(height: 50, title: "Stok Raporları"),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 30, 38, 45),
          onPressed: () async {
            listeler.sayfaDurum[widget.widgetListBelgeSira] =
                !listeler.sayfaDurum[widget.widgetListBelgeSira]!;
            if (listeler.sayfaDurum[widget.widgetListBelgeSira] == true) {
              setState(() {
                favIconColor = Colors.amber;
              });
            } else {
              setState(() {
                favIconColor = Colors.white;
              });
            }
            await SharedPrefsHelper.saveList(listeler.sayfaDurum);
          },
          label: favIconColor == Colors.amber
              ? Text("Favorilerimden Kaldır")
              : Text("Favorilerime Ekle"),
          icon: Icon(
            Icons.star,
            color: favIconColor,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5, bottom: 5, top: 8),
              child: Container(
                child: ListTile(
                  leading: Icon(Icons.storage),
                  title: Text(
                    "Stok Bakiye Listesi",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return LoadingSpinner(
                          color: Colors.black,
                          message: "Stok Bakiye Raporu Hazırlanıyor...",
                        );
                      },
                    );
                    List<bool> gelenFiltre = await SharedPrefsHelper.filtreCek(
                        "raporStokBakiyeFiltre");
                    List<List<dynamic>> gelen = await bs.getirGenelRapor(
                        sirket: Ctanim.sirket!,
                        kullaniciKodu: Ctanim.kullanici!.KOD!,
                        fonksiyonAdi: "RaporStokBakiye");
                    if (gelen[0].length == 1 && gelen[1].length == 0) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            align: TextAlign.left,
                            title: gelen[0][0] == "Veri Bulunamadı"
                                ? "Kayıtlı Belge Yok"
                                : "Hata",
                            message: gelen[0][0] == "Veri Bulunamadı"
                                ? 'İstenilen Belge Mevcut Değil'
                                : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                    gelen[0][0],
                            onPres: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            buttonText: 'Geri',
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => stok_bakiye_rapor_page(
                                    gelenBakiyeRapor: gelen,
                                    gelenFiltre: gelenFiltre,
                                  )));
                    }
                  },
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: ListTile(
                  leading: Icon(Icons.store),
                  title: Text(
                    "Stok Depo Bakiye Raporu",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return LoadingSpinner(
                          color: Colors.black,
                          message: "Stok Depo Bakiye Raporu Hazırlanıyor...",
                        );
                      },
                    );
                    List<bool> gelenFiltre = await SharedPrefsHelper.filtreCek(
                        "raporStokDepoBakiyeFiltre");
                    List<List<dynamic>> gelen = await bs.getirGenelRapor(
                        sirket: Ctanim.sirket!,
                        kullaniciKodu: Ctanim.kullanici!.KOD!,
                        fonksiyonAdi: "RaporStokDepoBakiye");
                    if (gelen[0].length == 1 && gelen[1].length == 0) {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            align: TextAlign.left,
                            title: 'Hata',
                            message: gelen[0][0] == "Veri Bulunamadı"
                                ? 'İstenilen Belge Mevcut Değil'
                                : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                    gelen[0][0],
                            onPres: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            buttonText: 'Geri',
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => stok_depo_bakiye_rapor_page(
                                    gelenBakiyeRapor: gelen,
                                    gelenFiltre: gelenFiltre,
                                  )));
                    }
                  },
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            /*
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text(
                      "Stok Satış Raporu",
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () async {
                      //yok
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message: "Stok Satış Raporu Hazırlanıyor...",
                          );
                        },
                      );
                      List<bool> gelenFiltre =
                          await SharedPrefsHelper.filtreCek(
                              "stokDepoBakiyeRaporu");
                      List<List<dynamic>> gelen = await bs.getirGenelRapor(
                          sirket: Ctanim.sirket!,
                          kullaniciKodu: Ctanim.kullanici!.KOD!,
                          fonksiyonAdi: "RaporStokDepoBakiye");
                      if (gelen[0].length == 1 && gelen[1].length == 0) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                             title: gelen[0][0] == "Veri Bulunamadı" ? "Kayıtlı Belge Yok":'Hata',
                              message:
                                  'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                      gelen[0][0],
                              onPres: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              buttonText: 'Geri',
                            );
                          },
                        );
                      } else {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    stok_depo_bakiye_rapor_page(
                                      gelenBakiyeRapor: gelen,
                                      gelenFiltre: gelenFiltre,
                                    )));
                      }
                    },
                  ),
                )),*/
          ],
        ));
  }
}
