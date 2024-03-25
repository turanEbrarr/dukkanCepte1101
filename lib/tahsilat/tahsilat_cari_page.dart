import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/cari_kart/yeni_cari_olustur.dart';
import 'package:dukkan_cepte/controllers/tahsilatController.dart';
import 'package:dukkan_cepte/tahsilat/tahsilat_tab_page.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/cari.dart';
import 'package:uuid/uuid.dart';

import '../controllers/cariController.dart';
import '../widget/ctanim.dart';

class tahsilat_cari_page extends StatefulWidget {
  tahsilat_cari_page(
      {super.key, required this.tahsilatId, required this.belgeTipi});
  final int? tahsilatId;
  final String? belgeTipi;

  @override
  State<tahsilat_cari_page> createState() => _tahsilat_cari_pageState();
}

class _tahsilat_cari_pageState extends State<tahsilat_cari_page> {
  var uuid = Uuid();
  final CariController cariEx = Get.find();
  final TahsilatController tahsilatEx = Get.find();
  List<Cari> carikayit = [];
  TextEditingController editController = TextEditingController();
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cariEx.searchCari("");
  }

  @override
  Widget build(BuildContext context) {
    for (var element in cariEx.searchCariList) {
      print(element.ADI);
    }
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        backgroundColor: Color.fromARGB(255, 30, 38, 45),
        buttonSize: Size(65, 65),
        children: [
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.add,
                color: Colors.green,
                size: 32,
              ),
              label: "Yeni Cari Oluştur",
              onTap: () {
                Get.to(const yeni_cari_olustur());
              }),
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.refresh,
                color: Colors.amber,
                size: 32,
              ),
              label: "Carilerimi Güncelle (Listelenen Cari" +
                  cariEx.searchCariList.length.toString() +
                  ")",
              onTap: () async {
                await cariEx.servisCariGetir();
              }),
        ],
      ),
      appBar: MyAppBar(
        title: widget.belgeTipi!,
        height: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 247, 245, 245),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(),
                          ),
                          child: TextFormField(
                            onChanged: (value) => cariEx.searchCari(value),
                            cursorColor: Color.fromARGB(255, 60, 59, 59),
                            decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                iconColor: Color.fromARGB(255, 60, 59, 59),
                                hintText: "Cari Adı / Cari Kodu",
                                border: InputBorder.none),
                          )),
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
                      String trim =
                          cariKart.ADI!.trim(); // bu ifade cariler eklenecek
                      String harf1 = "";
                      String harf2 = "";
                      if (trim.length > 0) {
                        harf1 = trim[0];
                        if (trim.length == 1) {
                          harf2 = "K";
                        } else {
                          harf2 = trim[1];
                        }
                      } else {
                        harf1 = "A";
                        harf2 = "B";
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
                                          harf1.toString() + harf2.toString(),
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
                                                  cariKart.BAKIYE.toString())
                                              .toString() +
                                          " ₺"),
                                      onTap: () {
                                        tahsilatEx.tahsilat!.value.UUID =
                                            uuid.v1().toString();
                                        tahsilatEx.tahsilat!.value.TIP =
                                            Ctanim()
                                                .MapIlslemTip[widget.belgeTipi];
                                        tahsilatEx.tahsilat!.value.BELGENO =
                                            "123456";
                                        tahsilatEx.tahsilat!.value.SUBEID =
                                            
                                                Ctanim.kullanici!.YERELSUBEID;
                                        tahsilatEx.tahsilat!.value.PLASIYERKOD =
                                            Ctanim.kullanici!.KOD;
                                        tahsilatEx.tahsilat?.value.CARIKOD =
                                            cariEx.searchCariList[index].KOD;
                                        tahsilatEx.tahsilat?.value.CARIADI =
                                            cariEx.searchCariList[index].ADI;
                                        tahsilatEx.tahsilat?.value.cariKart =
                                            cariEx.searchCariList[index];
                                        Get.to(() => tahsilat_tab_page(
                                              uuid: tahsilatEx
                                                  .tahsilat!.value.UUID
                                                  .toString(),
                                              belgeTipi: widget.belgeTipi,
                                              cariKod: cariEx
                                                  .searchCariList[index].KOD,
                                              cariKart:
                                                  cariEx.searchCariList[index],
                                            ));
                                      }),
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
