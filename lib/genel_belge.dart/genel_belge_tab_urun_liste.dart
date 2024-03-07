import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';
import 'package:dukkan_cepte/controllers/stokKartController.dart';
import 'package:dukkan_cepte/faturaFis/fisHareket.dart';
import 'package:dukkan_cepte/genel_belge.dart/genel_belge_stok_kart_guncelleme.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import '../faturaFis/fis.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../widget/ctanim.dart';

class genel_belge_tab_urun_liste extends StatefulWidget {
  const genel_belge_tab_urun_liste({
    super.key,
    required this.belgeTipi,
  });
  final String belgeTipi;

  @override
  State<genel_belge_tab_urun_liste> createState() =>
      _genel_belge_tab_urun_listeState();
}

class _genel_belge_tab_urun_listeState
    extends State<genel_belge_tab_urun_liste> {
  TextEditingController editingController = TextEditingController();
  final StokKartController StokKartEx = Get.find();
  final FisController fisEx = Get.find();
  TextStyle boldBlack =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  KUSURAT? Kfiyat;
  KUSURAT? Kmiktar;
  KUSURAT? Kkur;
  KUSURAT? KdovizFiyat;
  KUSURAT? Ktutar;
  KUSURAT? KdovTutar;

  @override
  void initState() {
    int tip = Ctanim().MapFisTip[widget.belgeTipi] ?? 0;
    if (tip == 3 || tip == 12 || tip == 17) {
      Kfiyat = KUSURAT.ALISFIYAT;
      Kmiktar = KUSURAT.ALISMIKTAR;
      Kkur = KUSURAT.ALISKUR;
      KdovizFiyat = KUSURAT.ALISDOVFIYAT;
      Ktutar = KUSURAT.ALISTUTAR;
      KdovTutar = KUSURAT.ALISDOVTUTAR;
    } else if (tip == 1 || tip == 4 || tip == 6) {
      Kfiyat = KUSURAT.PERFIYAT;
      Kmiktar = KUSURAT.PERMIKTAR;
      Kkur = KUSURAT.PERKUR;
      KdovizFiyat = KUSURAT.PERDOVFIYAT;
      Ktutar = KUSURAT.PERTUTAR;
      KdovTutar = KUSURAT.PERDOVTUTAR;
    } else {
      Kfiyat = KUSURAT.FIYAT;
      Kmiktar = KUSURAT.MIKTAR;
      Kkur = KUSURAT.KUR;
      KdovizFiyat = KUSURAT.DOVFIYAT;
      Ktutar = KUSURAT.TUTAR;
      KdovTutar = KUSURAT.DOVTUTAR;
    }
    fisEx.toplam.value = 0.0;
    fisEx.fis!.value.fisStokListesi.forEach((element) {
      fisEx.toplam =
          (fisEx.toplam + (element.KDVDAHILNETFIYAT!.toDouble())) as RxDouble;
    });

    super.initState();
  }

/*void toplamIskontoHesapla () {
  fisEx.toplam_iskonto.value =0.0;
    fisEx.fis!.value.fisStokListesi.forEach((element) {
     fisEx.toplam_iskonto = (fisEx.toplam_iskonto + ( element.ISK!.toDouble())) as RxDouble;
    });
}*/

/*void araToplamHesapla () {
  fisEx.toplam
}*/

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Obx(
                () => ListView.builder(
                    itemCount: fisEx.fis?.value.fisStokListesi.length,
                    itemBuilder: (context, index) {
                      FisHareket? fishareket =
                          fisEx.fis?.value.fisStokListesi[index];
                      var results = stokKartEx.searchList
                          .where((value) =>
                              value.KOD! ==
                                  fisEx.fis?.value.fisStokListesi[index]
                                      .STOKKOD ||
                              value.BARKOD1! ==
                                  fisEx.fis?.value.fisStokListesi[index]
                                      .STOKKOD ||
                              value.BARKOD2! ==
                                  fisEx.fis?.value.fisStokListesi[index]
                                      .STOKKOD )
                          .toList();
                        
                      StokKart stokKart = results[0];

                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: y * .01,
                                      left: x * .07,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: x * .22,
                                            child: Text("Ürün Kodu:",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700))),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: x * .05),
                                          child: SizedBox(
                                              width: x * .4,
                                              child: Text(
                                                maxLines: 2,
                                                fishareket!.STOKKOD.toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              bottomSheetUrunListe(context,
                                                  fishareket, stokKart, index);
                                            },
                                            icon: Icon(Icons.more_vert))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: y * .01,
                                      left: x * .07,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: x * .22,
                                            child: Text("Ürün Adı",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w700))),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: x * .1),
                                          child: SizedBox(
                                              width: x * .5,
                                              child: Text(
                                                fishareket.STOKADI.toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: x * .1,
                                      //left: x * .07,
                                    ),
                                    child: Container(
                                      height: y * .15,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                  width: x * .15,
                                                  child: Text(
                                                    "Miktar :",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .15,
                                                    child: Text("Fiyat    :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .15,
                                                    child: Text("İSK       :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .15,
                                                    child: Text(
                                                      Ctanim.noktadanSonraAlinacakParametreli(
                                                          Kmiktar!,
                                                          double.tryParse(fishareket
                                                                  .MIKTAR!
                                                                  .toString()) ??
                                                              0.0),
                                                    )),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .15,
                                                    child: Text(Ctanim
                                                        .donusturMusteri(Ctanim
                                                            .noktadanSonraAlinacakParametreli(
                                                                Kfiyat!,
                                                                fishareket
                                                                    .BRUTFIYAT!)))),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                  width: x * .15,
                                                  child: fishareket.ISK2! > 0
                                                      ? Text(
                                                          Ctanim.donusturMusteri(
                                                                  Ctanim.noktadanSonraAlinacakParametreli(
                                                                      Kfiyat!,
                                                                      fishareket
                                                                          .ISK!)) +
                                                              " + " +
                                                              Ctanim.donusturMusteri(
                                                                  Ctanim.noktadanSonraAlinacakParametreli(
                                                                      Kfiyat!,
                                                                      fishareket
                                                                          .ISK2!)),
                                                        )
                                                      : Text(Ctanim
                                                          .donusturMusteri(Ctanim
                                                              .noktadanSonraAlinacakParametreli(
                                                                  Kfiyat!,
                                                                  fishareket
                                                                      .ISK!))),
                                                ),
                                              ),
                                            ],
                                          ),
                                          VerticalDivider(
                                            thickness: 2,
                                            color: Colors.green,
                                          ),
                                          //turan
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                  width: x * .2,
                                                  child: Text(
                                                    "Net Fiyat :",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .2,
                                                    child: Text("T.Fiyat     :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .2,
                                                    child: Text("KDV         :",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .15,
                                                    child: Text(Ctanim
                                                        .donusturMusteri(Ctanim
                                                            .noktadanSonraAlinacakParametreli(
                                                                Kfiyat!,
                                                                fishareket
                                                                    .KDVDAHILNETFIYAT!)))),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                    width: x * .15,
                                                    child: Text(Ctanim
                                                        .donusturMusteri(Ctanim
                                                            .noktadanSonraAlinacakParametreli(
                                                                Kfiyat!,
                                                                fishareket
                                                                    .KDVDAHILNETTOPLAM!)))),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .05),
                                                child: SizedBox(
                                                  width: x * .15,
                                                  child: Text(Ctanim
                                                      .donusturMusteri(Ctanim
                                                          .noktadanSonraAlinacakParametreli(
                                                              Kfiyat!,
                                                              fishareket
                                                                  .KDVORANI!))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .05,
            color: Color.fromARGB(255, 66, 82, 97),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Text(
                    "TOPLAM : ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                    Ctanim.donusturMusteri(
                        Ctanim.noktadanSonraAlinacakParametreli(
                            Ktutar!, fisEx.fis!.value.GENELTOPLAM!)),
                    style: const TextStyle(color: Colors.white)),
                Spacer(),
                const Text(
                  "SATIR-ADET : ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Text(
                      fisEx.fis!.value.fisStokListesi.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void bottomSheetUrunListe(BuildContext context, FisHareket fishareket,
      StokKart stokKart, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 3,
                indent: 150,
                endIndent: 150,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () async {
                  fisEx.fis?.value.fisStokListesi.removeWhere(
                      (item) => item.STOKKOD == fishareket.STOKKOD!);
                      await Fis.empty().fisHareketSil( fisEx.fis!.value!.ID!,fishareket.STOKKOD!);

                  setState(() {});
                  const snackBar = SnackBar(
                    content: Text(
                      'Stok silindi..',
                      style: TextStyle(fontSize: 16),
                    ),
                    showCloseIcon: true,
                    backgroundColor: Colors.blue,
                    closeIconColor: Colors.white,
                  );
                  ScaffoldMessenger.of(context as BuildContext)
                      .showSnackBar(snackBar);
                  Navigator.pop(context);
                  setState(() {});
                },
                child: ListTile(
                  title: Text("Sil"),
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var result = await showDialog(
                      context: context,
                      builder: (_) {
                        return genel_belge_stok_kart_guncellemeDialog(
                          belgeTipi: widget.belgeTipi,
                          stokKartKurAdi: fishareket.DOVIZADI!,
                          urunListedenMiGeldin: true,
                          stokkart: stokKart,
                          stokAdi: fishareket.STOKADI!,
                          stokKodu: fishareket.STOKKOD!,
                          cariKod: fisEx.fis!.value.CARIKOD!, // sjkanka
                          fiyat: fishareket.BRUTFIYAT!,
                          iskonto: fishareket.ISK!,
                          miktar: fishareket.MIKTAR!,
                        );
                      });
                  if (result != null) {
                    fisEx.toplam.value = 0.0;
                    fisEx.fis!.value.fisStokListesi.forEach((element) {
                      fisEx.toplam = (fisEx.toplam +
                          (element.KDVDAHILNETFIYAT!.toDouble())) as RxDouble;
                    });
                  }
                  Navigator.pop(context);
                  setState(() {});
                },
                child: ListTile(
                  title: Text("Düzenle"),
                  leading: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
