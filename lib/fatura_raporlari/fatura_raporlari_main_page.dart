import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/fatura_raporlari/alisFatura/alis_fatura_cari_list.dart';
import 'package:dukkan_cepte/fatura_raporlari/satisFatura/satis_fatura_cari_list.dart';
import 'package:dukkan_cepte/fatura_raporlari/satisFatura/satis_fatura_rapor.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/appbar.dart';

import '../stok_kart/Spinkit.dart';
import '../widget/cari.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import 'alisFatura/alis_fatura_rapor.dart';

class fatura_raporlari_main_page extends StatefulWidget {
  const fatura_raporlari_main_page(
      {super.key,
      required this.widgetListBelgeSira,
      this.cariKart,
      required this.cariGonderildiMi});
  final int widgetListBelgeSira;
  final Cari? cariKart;
  final bool cariGonderildiMi;
  @override
  State<fatura_raporlari_main_page> createState() =>
      _fatura_raporlari_main_pageState();
}

class _fatura_raporlari_main_pageState
    extends State<fatura_raporlari_main_page> {
  Color favIconColor = Colors.black;
  BaseService bs = BaseService();
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
        appBar: MyAppBar(height: 50, title: "Fatura Raporları"),
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
                  leading: Icon(Icons.receipt_long),
                  title: Text(
                    "Satış Fatura Raporları",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () async {
                    if (widget.cariGonderildiMi == false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => satis_fatura_cari_list_page(
                                    widgetListBelgeSira: 0,
                                  )));
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message: "Satış Fatura Raporu Hazırlanıyor...",
                          );
                        },
                      );

                      List<bool> cek =
                          await SharedPrefsHelper.filtreCek("raporSatisFatura");
                      List<List<dynamic>> gelen =
                          await bs.getirSatisFaturaRapor(
                        sirket: Ctanim.sirket!,
                        cariKodu: widget.cariKart!.KOD!,
                        basTar: Ctanim.son10GunDon()[0],
                        bitTar: Ctanim.son10GunDon()[1],
                      );

                      if (gelen[0].length == 1 && gelen[1].length == 0) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: gelen[0][0] == "Veri Bulunamadı"
                                  ? "Kayıtlı Belge Yok"
                                  : 'Hata',
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
                        if (gelen[1].length != cek.length) {
                          cek.clear();
                          for (var i = 0; i < gelen[1].length; i++) {
                            cek.add(true);
                          }
                        }
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => satis_fatura_rapor_page(
                                  gelenFiltre: cek,
                                  gelenBakiyeRapor: gelen,
                                  cariKart: widget.cariKart,
                                )),
                          ),
                        );
                      }
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
                  leading: Icon(Icons.receipt_long),
                  title: Text(
                    "Alış Fatura Raporları",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: (() async {
                    if (widget.cariGonderildiMi == false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => alis_fatura_cari_list_page(
                                    widgetListBelgeSira: 0,
                                  ))));
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message: "Alış Fatura Raporu Hazırlanıyor...",
                          );
                        },
                      );

                      List<bool> cek =
                          await SharedPrefsHelper.filtreCek("alisFaturaRaporu");
                      List<List<dynamic>> gelen = await bs.getirAlisFaturaRapor(
                        sirket: Ctanim.sirket!,
                        cariKodu: widget.cariKart!.KOD!,
                        basTar: Ctanim.son10GunDon()[0],
                        bitTar: Ctanim.son10GunDon()[1],
                      );

                      if (gelen[0].length == 1 && gelen[1].length == 0) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: gelen[0][0] == "Veri Bulunamadı"
                                  ? "Kayıtlı Belge Yok"
                                  : 'Hata',
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
                        if (gelen[1].length != cek.length) {
                          cek.clear();
                          for (var i = 0; i < gelen[1].length; i++) {
                            cek.add(true);
                          }
                        }
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => alis_fatura_rapor_page(
                                  gelenFiltre: cek,
                                  gelenBakiyeRapor: gelen,
                                  cariKart: widget.cariKart,
                                )),
                          ),
                        );
                      }
                    }
                  }),
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
