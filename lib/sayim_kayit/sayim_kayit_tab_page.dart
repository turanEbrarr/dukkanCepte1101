import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_kayit_genel.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_kayit_urun_ara.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_kayit_urun_liste.dart';

import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/cari.dart';
import '../Depo Transfer/depo.dart';
import '../controllers/depoController.dart';
import '../widget/ctanim.dart';

class sayim_kayit_tab_page extends StatefulWidget {
  const sayim_kayit_tab_page({
    super.key,
    required this.fis_id,
  });

  final int fis_id;

  @override
  State<sayim_kayit_tab_page> createState() => _sayim_kayit_tab_pageState();
}

class _sayim_kayit_tab_pageState extends State<sayim_kayit_tab_page> {
  SayimController fisEx = Get.find();
  void dispose() {
    Sayim.empty().sayimEkle(
      sayim: fisEx.sayim!.value,
    );
    fisEx.sayim!.value = Sayim.empty();
    super.dispose();
  }

  Color tab1 = Colors.amber;
  Color tab2 = Colors.white;
  Color tab3 = Colors.white;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MyAppBar(height: 50, title: "Sayım Kayıt Fişi"),
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 10),
              child: Material(
                color: Color.fromARGB(255, 66, 82, 97),
                child: TabBar(
                  labelColor: Colors.amber,
                  unselectedLabelColor: Colors.white,
                  onTap: (value) {
                    setState(() {
                      if (value == 0) {
                        tab1 = Colors.amber;
                        tab2 = Colors.white;
                        tab3 = Colors.white;
                      } else if (value == 1) {
                        tab2 = Colors.amber;
                        tab1 = Colors.white;
                        tab3 = Colors.white;
                      } else if (value == 2) {
                        tab3 = Colors.amber;
                        tab2 = Colors.white;
                        tab1 = Colors.white;
                      }
                    });
                  },
                  tabs: [
                    Tab(
                      text: ("Ürün Ara"),
                      icon: Icon(
                        Icons.search,
                        color: tab1,
                      ),
                    ),
                    Tab(
                      text: ("Liste"),
                      icon: Icon(
                        Icons.list,
                        color: tab2,
                      ),
                    ),
                    Tab(
                      text: ("Genel"),
                      icon: Icon(
                        Icons.info,
                        color: tab3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  sayim_kayit_urun_ara(
                    cariKod: "DepoID",
                  ),
                  sayim_kayit_urun_liste(),
                  sayim_kayit_son_bakis()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
