import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dukkan_cepte/tahsilat/nakit_visa.dart';
import 'package:dukkan_cepte/tahsilat/tahsilat_toplam.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilatHaraket.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:uuid/uuid.dart';

import '../controllers/tahsilatController.dart';
import '../tahsilatOdemeModel/tahsilat.dart';
import '../widget/cari.dart';

class tahsilat_tab_page extends StatefulWidget {
  tahsilat_tab_page(
      {super.key,
      this.belgeTipi,
      this.cariKod,
      required this.cariKart,
      required this.uuid});
  final String? belgeTipi;
  final String? cariKod;
  final Cari cariKart;
  final String uuid;

  @override
  State<tahsilat_tab_page> createState() => _tahsilat_tab_pageState();
}

class _tahsilat_tab_pageState extends State<tahsilat_tab_page> {
  TahsilatController tahsilatEx = Get.find();

  TahsilatHareket nakit = TahsilatHareket.empty();
  TahsilatHareket visa = TahsilatHareket.empty();
  TahsilatHareket cek = TahsilatHareket.empty();
  TahsilatHareket senet = TahsilatHareket.empty();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Cari Bilgi");
    print(tahsilatEx.tahsilat!.value.CARIADI);
    senet.ID = 4;
    cek.ID = 3;
    visa.ID = 2;
    nakit.ID = 1; //nakit yaptık;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    Tahsilat.empty().tahsilatEkle(
        belgeTipi: "Tahsilat", tahsilat: tahsilatEx.tahsilat!.value);
    tahsilatEx.tahsilat!.value = Tahsilat.empty();
    super.dispose();
  }

  Color tab1 = Colors.amber;
  Color tab2 = Colors.white;
  Color tab3 = Colors.white;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(height: 50, title: "Tahsilat"),
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
                      text: ("Nakit & Pos"),
                      icon: Icon(
                        Icons.wallet_rounded,
                        color: tab1,
                      ),
                    ),
                   
                    Tab(
                      text: ("Toplam"),
                      icon: Icon(
                        Icons.add_box,
                        color: tab3
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  nakit_visa(
                    uid: widget.uuid,
                  ),
               
                  tahsilat_toplam()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
