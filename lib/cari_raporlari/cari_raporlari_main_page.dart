import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/cari_raporlari/bakiye_raporu/bakiye_raporu_page.dart';
import 'package:dukkan_cepte/cari_kart/cari_cari_islemler.dart';
import 'package:dukkan_cepte/cari_raporlari/odenecek_faturalar/odenecek_faturalar_page.dart';

import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import '../cari_kart/cari_islemler_page.dart';

import '../stok_kart/Spinkit.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';

class cari_raporlari_main_page extends StatefulWidget {
  const cari_raporlari_main_page(
      {super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;
  @override
  State<cari_raporlari_main_page> createState() =>
      _cari_raporlari_main_pageState();
}

class _cari_raporlari_main_pageState extends State<cari_raporlari_main_page> {
  BaseService bs = BaseService();
  List list = [
    "CARİ KART LİSTESİ",
    "BAKİYE RAPORU",


  
  ];
  List<Map<String, String>> cari_list = [
    {
      "Cari Kodu": "108-01-0002",
      "Cari Adı": "Paynet Ödeme Sistemleri A.Ş.",
      "Bakiye": "0.00",
    },
    {
      "Cari Kodu": "120-01-0002",
      "Cari Adı": "Ada Büro Makineleri Ticaret Ltd. Şti.",
      "Bakiye": "0.00",
    },
    {
      "Cari Kodu": "120-01-0003",
      "Cari Adı": "Avrupa Ofis Malz. ve Teknik  San. Tic. Ltd. Şti.",
      "Bakiye": "0.00",
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
        appBar: MyAppBar(height: 50, title: "Cari Raporları"),
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
                  leading: Icon(Icons.person),
                  title: Text(
                    "Cari Kart Listesi",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => cari_islemler_page(
                              widgetListBelgeSira: 0,
                            )),
                  ),
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
                  leading: Icon(Icons.account_balance),
                  title: Text(
                    "Bakiye Raporu",
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
                          message: "Cari Bakiye Raporu Hazırlanıyor...",
                        );
                      },
                    );

                    List<bool> cek = await SharedPrefsHelper.filtreCek(
                        "raporCariBakiyeFiltre");
                    List<List<dynamic>> gelen = await bs.getirGenelRapor(
                      sirket: Ctanim.sirket!,
                      kullaniciKodu: Ctanim.kullanici!.KOD!,
                      fonksiyonAdi: "RaporCariBakiye",
                    );


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
                      // gelenlerden colon kaldırıldıysa veya eklendiyse favorileri temizle
                      if(gelen[1].length!=cek.length){
                        cek.clear();
                        for (var i = 0; i < gelen[1].length; i++) {
                          cek.add(true);
                        }
                      }
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => bakiye_raporu_page(
                                gelenFiltre: cek,
                                gelenBakiyeRapor: gelen,
                              )),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),

          ],
        ));
  }
}
