import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/odeme/odeme_nakit_visa.dart';
import 'package:dukkan_cepte/odeme/odemeToplam.dart';
import 'package:dukkan_cepte/widget/appbar.dart';

import '../controllers/tahsilatController.dart';
import '../tahsilatOdemeModel/tahsilat.dart';
import '../widget/cari.dart';

class odeme_detay_tab_page extends StatefulWidget {
  const odeme_detay_tab_page({super.key, this.belgeTipi, this.cariKod, required this.cariKart, required this.uuid});
  final String? belgeTipi;
  final String? cariKod;
  final Cari cariKart;
  final String uuid;

  @override
  State<odeme_detay_tab_page> createState() => _odeme_detay_tab_pageState();
}

class _odeme_detay_tab_pageState extends State<odeme_detay_tab_page> {
    TahsilatController tahsilatEx = Get.find();
    @override
  void dispose() {
    // TODO: implement dispose

    Tahsilat.empty()
        .tahsilatEkle(belgeTipi: "Odeme", tahsilat: tahsilatEx.tahsilat!.value);
    tahsilatEx.tahsilat!.value = Tahsilat.empty();
    super.dispose();
  }
    Color tab1 = Colors.amber;
  Color tab2 = Colors.white;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(height: 50, title: "Ödeme Detay"),
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
             
                    
                      } else if (value == 1) {
                        tab2 = Colors.amber;
                        tab1 = Colors.white;
               
                 
                      } 
                    });
                  },
                  tabs: [
                    Tab(
                      text: ("Nakit & Visa"),
                      icon: Icon(
                        Icons.wallet_rounded,
                        color: tab1,
                      ),
                    ),
                    Tab(
                      text: ("Toplam"),
                      icon: Icon(
                        Icons.add_box,
                        color: tab2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  odeme_nakit_visa(uid: widget.uuid,),
                  odeme_toplam(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
