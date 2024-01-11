import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';

import '../controllers/depoController.dart';
import '../controllers/fisController.dart';
import '../controllers/tahsilatController.dart';

class creatBadge extends StatefulWidget {
  final Widget child;
  final String belgeTipi;
  final double top;
  final double end;
  final double size;
  const creatBadge(
      {super.key,
      required this.child,
      required this.belgeTipi,
      required this.top,
      required this.end,
      required this.size});

  @override
  State<creatBadge> createState() => _creatBadgeState();
}

class _creatBadgeState extends State<creatBadge> {
  int sayi = 0;
  bool isLoading = false;
  static FisController fisEx = Get.find();
  static TahsilatController tahsilatEx = Get.find();
  static SayimController sayimEx = Get.find();
  Future<void> loadData() async {
    bool belgeVarmi = false;
    await Future.delayed(Duration(milliseconds: 500));
    if (widget.belgeTipi == "") {
      sayi = 0;
    } else if (widget.belgeTipi == "Tahsilat" || widget.belgeTipi == "Odeme") {
      int a = await tahsilatEx.getTahsilatSayisi(belgeTipi: widget.belgeTipi);

      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "Sayim") {
      int a = await sayimEx.getSayimSayisi();

      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "faturaToplam") {
      int a = await fisEx.getFislerSayisi(
          belgeTipi1: "Satis_Fatura",
          belgeTipi2: "Satis_Irsaliye",
          belgeTipi3: "Alis_Irsaliye");
      if (a > 0) {
        belgeVarmi = true;
      }
      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "siparisToplam") {
      int a = await fisEx.getFislerSayisi(
          belgeTipi1: "Alinan_Siparis",
          belgeTipi2: "Musteri_Siparis",
          belgeTipi3: "Satis_Teklif");
      if (a > 0) {
        belgeVarmi = true;
      }
      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "perakendeToplam") {
      int a = await fisEx.getFisSayisi(belgeTipi: "Perakende_Satis");
      if (a > 0) {
        belgeVarmi = true;
      }
      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "stokIslemToplam") {
      int a = await sayimEx.getSayimSayisi();
      int b = await fisEx.getFisSayisi(belgeTipi: "Depo_Transfer");
      if (a > 0) {
        belgeVarmi = true;
      }

      setState(() {
        sayi = a + b;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "tahsilatOdemeToplam") {
      int a = await tahsilatEx.getTahsilatlarSayisi(
          belgeTipi1: "Tahsilat", belgeTipi2: "Odeme");
      if (a > 0) {
        belgeVarmi = true;
      }
      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else if (widget.belgeTipi == "genel") {
      int a = -1;
      setState(() {
        sayi = a;
        isLoading = false;
      });
    } else {
      int a = await fisEx.getFisSayisi(belgeTipi: widget.belgeTipi);
      setState(() {
        sayi = a;
        isLoading = false;
      });
    }
    Ctanim.bekleyenBelgeVarMi = belgeVarmi;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: badges.Badge(
        badgeStyle: badges.BadgeStyle(
          badgeColor: Color(0xffff4040),
        ),
        showBadge: sayi == 0 ? false : true,
        position: badges.BadgePosition.topEnd(top: widget.top, end: widget.end),
        badgeContent: isLoading == true
            ? CircularProgressIndicator()
            : Text(
                sayi.toString(),
                style: TextStyle(
                    color: sayi != -1 ? Colors.white : Color(0xffff4040),
                    fontSize: widget.size),
              ),
        child: widget.child,
      ),
    );
  }
}
