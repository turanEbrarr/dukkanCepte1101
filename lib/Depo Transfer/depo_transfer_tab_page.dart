import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/Depo%20Transfer/depo_transfer_genel.dart';

import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/cari.dart';
import '../controllers/fisController.dart';
import '../faturaFis/fis.dart';
import '../widget/ctanim.dart';
import 'depo_transfer_urun_ara.dart';
import 'depo_transfer_urun_liste.dart';

class depo_transfer_tab_page extends StatefulWidget {
  const depo_transfer_tab_page({
    super.key,
    required this.belgeTipi,
    required this.fis_id,
  });
  final String belgeTipi;
  final int fis_id;

  @override
  State<depo_transfer_tab_page> createState() => _depo_transfer_tab_pageState();
}

class _depo_transfer_tab_pageState extends State<depo_transfer_tab_page> {
  FisController fisEx = Get.find();
  void dispose() {
    Fis.empty().fisEkle(fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
    fisEx.fis!.value = Fis.empty();
    super.dispose();
    //listede güncelleme yaptı ve çıktı
  }

  Color tab1 = Colors.amber;
  Color tab2 = Colors.white;
  Color tab3 = Colors.white;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MyAppBar(
            height: 50, title: Ctanim().MapFisTR[widget.belgeTipi].toString()),
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 10),
              child: Material(
                color: Color.fromARGB(255, 66, 82, 97),
                child:  TabBar(
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
                        color:tab2,
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
                  depo_transfer_urun_ara(
                    cariKod: "DepoID",
                  ),
                  depo_transfer_urun_liste(),
                  depo_transfer_genel()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
