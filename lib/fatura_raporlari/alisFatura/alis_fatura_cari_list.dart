import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/fatura_raporlari/alisFatura/alis_fatura_rapor.dart';
import 'package:dukkan_cepte/webservis/base.dart';

import '../../controllers/cariController.dart';
import '../../stok_kart/Spinkit.dart';
import '../../widget/appbar.dart';
import '../../widget/cari.dart';
import '../../widget/ctanim.dart';
import '../../widget/customAlertDialog.dart';
import '../../widget/modeller/sharedPreferences.dart';

class alis_fatura_cari_list_page extends StatefulWidget {
  const alis_fatura_cari_list_page({required this.widgetListBelgeSira});

  final int widgetListBelgeSira;

  @override
  State<alis_fatura_cari_list_page> createState() =>
      _alis_fatura_cari_list_pageState();
}

class _alis_fatura_cari_list_pageState
    extends State<alis_fatura_cari_list_page> {
  BaseService bs = BaseService();
  Color favIconColor = Colors.black;
  static CariController cariEx = Get.find();
  TextEditingController editController = TextEditingController();
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: "Cari İşlemler",
        height: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Color.fromARGB(255, 121, 184, 240),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(
                        () => Text(
                          "Listelenen Cari:  ${cariEx.searchCariList.length}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 12.0),
                      child: IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text('Cariler yükleniyor'),
                                content: Text('Lütfen bekleyin...'),
                              );
                            },
                          );
                          await cariEx.servisCariGetir();

                          Navigator.pop(context);
                          //servisten cari bilgilerini çekip günceller
                        },
                        icon: Icon(
                          Icons.published_with_changes_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        // labelText: "Listeyi ara",
                        hintText: "Aranacak kelime (Ünvan/Kod)",
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        iconColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onChanged: ((value) => cariEx.searchCari(value)),
                    ),
                  ),
                  /*
                  Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset("images/slider.png",
                            height: 60, width: 60),
                      )),
                      */
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .70,
              child: Obx(() => ListView.builder(
                    itemCount: cariEx.searchCariList.length,
                    itemBuilder: (context, index) {
                      Cari cariKart = cariEx.searchCariList[index];
                      String trim = cariKart.ADI!.trim();
                      String harf1 = "";
                      String harf2 = "";
                      harf1 = trim[0];
                      if (trim.length == 1) {
                        harf2 = "K";
                      } else {
                        harf2 = trim[1];
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5, top: 1, bottom: 1),
                        child: Column(
                          children: [
                            Container(
                              // color: Colors.grey[100],

                              color: Colors.blue[70],
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: randomColor(),
                                      child: Text(
                                        harf1 + harf2,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      cariKart.ADI!,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(cariKart.IL.toString()),
                                    ),
                                    trailing: Text(Ctanim.donusturMusteri(
                                            cariKart.BAKIYE.toString()) +
                                        " TL"),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return LoadingSpinner(
                                            color: Colors.black,
                                            message:
                                                "Alış Fatura Raporu Hazırlanıyor...",
                                          );
                                        },
                                      );

                                      List<bool> cek =
                                          await SharedPrefsHelper.filtreCek(
                                              "alisFaturaRaporu");
                                      List<List<dynamic>> gelen =
                                          await bs.getirAlisFaturaRapor(
                                        sirket: Ctanim.sirket!,
                                        cariKodu: cariKart.KOD!,
                                        basTar: Ctanim.son10GunDon()[0],
                                        bitTar: Ctanim.son10GunDon()[1],
                                      );

                                      if (gelen[0].length == 1 &&
                                          gelen[1].length == 0) {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              align: TextAlign.left,
                                              title: gelen[0][0] ==
                                                      "Veri Bulunamadı"
                                                  ? "Kayıtlı Belge Yok"
                                                  : "Hata",
                                              message: gelen[0][0] ==
                                                      "Veri Bulunamadı"
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
                                          for (var i = 0;
                                              i < gelen[1].length;
                                              i++) {
                                            cek.add(true);
                                          }
                                        }
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                alis_fatura_rapor_page(
                                                  gelenFiltre: cek,
                                                  gelenBakiyeRapor: gelen,
                                                  cariKart: cariKart,
                                                )),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  /*void searchB(String query) {
    final suggestion = cariler.where((c1) {
      final Ctitle = c1.title.toLowerCase();
      final Ckod = c1.kodu.toLowerCase();
      final input = query.toLowerCase();
      return Ctitle.contains(input) || Ckod.contains(input);
    }).toList();
    setState(() => carikayit = suggestion);
  }*/
}
