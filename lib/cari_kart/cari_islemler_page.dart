import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/appbar.dart';
import '../widget/cari.dart';
import '../widget/ctanim.dart';
import '../localDB/veritabaniIslemleri.dart';

import '../widget/cari_kart_page.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import '../cari_kart/yeni_cari_olustur.dart';

enum SampleItem { itemOne, itemTwo,itemThere,itemFour ,itemFife}

class cari_islemler_page extends StatefulWidget {
  const cari_islemler_page({required this.widgetListBelgeSira});

  final int widgetListBelgeSira;

  @override
  State<cari_islemler_page> createState() => _cari_islemler_pageState();
}

class _cari_islemler_pageState extends State<cari_islemler_page> {
  Color favIconColor = Colors.black;
  TextEditingController editController = TextEditingController();
  SampleItem? selectedMenu;
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

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
      appBar: const MyAppBar(
        title: "Cari İşlemler",
        height: 50,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        backgroundColor: Color.fromARGB(255, 30, 38, 45),
        buttonSize: Size(65, 65),
        children: [
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.star,
                color: favIconColor,
                size: 32,
              ),
              label: favIconColor == Colors.amber
                  ? "Favorilerimden Kaldır"
                  : "Favorilerime Ekle",
              onTap: () async {
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
              }),
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.refresh,
                color: Colors.green,
                size: 32,
              ),
              label: "Carileri Güncelle(" +
                  cariEx.searchCariList.length.toStringAsFixed(2) +
                  ")",
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LoadingSpinner(
                      color: Colors.black,
                      message:
                          "Cariler güncelleniyor. Bu işlem biraz zaman alabilir...",
                    );
                  },
                );
                await cariEx.servisCariGetir();
                Navigator.pop(context);
                //stokKartEx.servisStokGetir();  //servisten stokları çekip günceller
              }),
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.add_circle,
                color: Colors.blue,
                size: 32,
              ),
              label: "Yeni Cari Ekle",
              onTap: () {
                Get.to(yeni_cari_olustur());
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        // labelText: "Listeyi ara",
                        hintText: "Aranacak kelime (Ünvan/Kod)",
                        prefixIcon: Icon(Icons.search, color: Colors.black),
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

                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<SampleItem>>[
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemOne,
                        onTap: () {
                          cariEx.searchCariList.sort((a, b) => b.BAKIYE!.compareTo(a.BAKIYE!));
                          setState(() {
                            
                          });
                        },
                        child: Text('Bakiye Azalan'),
                      ),
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemTwo,
                        child: Text('Bakiye Artan'),
                        onTap: () {
                            cariEx.searchCariList..sort((a, b) => a.BAKIYE!.compareTo(b.BAKIYE!));
                        },
                      ),
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemThere,
                        child: Text('Bakiyesi Eksi Olanlar'),
                        onTap: () {
                          cariEx.searchCariList.clear();
                          cariEx.searchCariList.addAll(listeler.listCari);
                           cariEx.searchCariList.removeWhere((cari) => cari.BAKIYE! >= 0);
                           setState(() {
                             
                           });
                        },
                      ),
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemFour,
                        child: Text('Bakiyesi Artı Olanlar'),
                        onTap: () {
                             cariEx.searchCariList.clear();
                          cariEx.searchCariList.addAll(listeler.listCari);
                          cariEx.searchCariList.removeWhere((cari) => cari.BAKIYE! < 0);
                           setState(() {
                             
                           });
                        },
                      ),
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.itemFife,
                        child: Text('Filtreyi Temizle'),
                        onTap: () {
                             cariEx.searchCariList.clear();
                          cariEx.searchCariList.addAll(listeler.listCari);
                          
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .90,
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
                        child: SingleChildScrollView(
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
                                      onTap: () => Get.to(cari_kart_page(
                                        cariKart: cariKart,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              )
                            ],
                          ),
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
