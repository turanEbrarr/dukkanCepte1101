import 'package:flutter/material.dart';
import '../cari_kart/cari_cari_rapor.dart';
import '../cari_kart/cari_cari_analiz.dart';
import '../cari_kart/cari_cari_genel.dart';
import '../cari_kart/cari_cari_islemler.dart';
import '../cari_kart/cari_cari_rapor.dart';
import '../widget/cari.dart';
import 'appbar.dart';

class cari_kart_page extends StatefulWidget {
  const cari_kart_page({super.key, required this.cariKart});
  final Cari cariKart;

  @override
  State<cari_kart_page> createState() => _cari_kart_pageState();
}

class _cari_kart_pageState extends State<cari_kart_page> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: MyAppBar(height: 50, title: "Cari Kart"),
          body: Column(children: [
            TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: ("İşlemler"), icon: Icon(Icons.receipt_long)),
                  Tab(text: ("Genel"), icon: Icon(Icons.info)),
                  Tab(text: ("İletişim"), icon: Icon(Icons.wifi_calling_3)),
                  Tab(
                    text: ("Rapolar"),
                    icon: Icon(Icons.bar_chart_rounded),
                  ),
                ]),
            Expanded(
              child: TabBarView(children: [
                cari_cari_islemler(cariKart: widget.cariKart,),
                cari_cari_genel(cariKart: widget.cariKart,),
                cari_cari_iletisim(cariKart: widget.cariKart,),
                cari_cari_rapor(cariKart: widget.cariKart),
              ]),
            )
          ]),
        ));
  }
}
