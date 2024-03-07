import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';
import 'package:dukkan_cepte/controllers/stokKartController.dart';
import 'package:dukkan_cepte/faturaFis/fisHareket.dart';
import 'package:dukkan_cepte/genel_belge.dart/genel_belge_stok_kart_guncelleme.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import '../localDB/veritabaniIslemleri.dart';
//16-05-2023.3

class depo_transfer_urun_liste extends StatefulWidget {
  const depo_transfer_urun_liste({
    super.key,
  });

  @override
  State<depo_transfer_urun_liste> createState() =>
      _depo_transfer_urun_listeState();
}

class _depo_transfer_urun_listeState extends State<depo_transfer_urun_liste> {
  TextEditingController editingController = TextEditingController();
  final StokKartController StokKartEx = Get.find();
  final FisController fisEx = Get.find();
  TextStyle boldBlack =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  @override
  void initState() {
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
                      StokKart stokKart = stokKartEx.searchList[index];

                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
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
                                              EdgeInsets.only(left: x * .1),
                                          child: SizedBox(
                                              width: x * .4,
                                              child: Text(
                                                fishareket!.STOKKOD.toString(),
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(16.0),
                                                  ),
                                                ),
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    /*height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                            */
                                                    child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Divider(
                                                          thickness: 3,
                                                          indent: 150,
                                                          endIndent: 150,
                                                          color: Colors.grey,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            fisEx.fis?.value
                                                                .fisStokListesi
                                                                .removeWhere((item) =>
                                                                    item.STOKKOD ==
                                                                    fishareket
                                                                        .STOKKOD!);

                                                            setState(() {});
                                                            const snackBar =
                                                                SnackBar(
                                                              content: Text(
                                                                'Stok silindi..',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              showCloseIcon:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              closeIconColor:
                                                                  Colors.white,
                                                            );
                                                            ScaffoldMessenger
                                                                    .of(context
                                                                        as BuildContext)
                                                                .showSnackBar(
                                                                    snackBar);
                                                            Navigator.pop(
                                                                context);
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
                                                            var result =
                                                                await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (_) {
                                                                      return genel_belge_stok_kart_guncellemeDialog(
                                                                        belgeTipi: "Depo_Transfer",
                                                                        stokKartKurAdi: fishareket.DOVIZADI!,
                                                                        urunListedenMiGeldin: true,
                                                                        stokAdi:
                                                                            fishareket.STOKADI!,
                                                                        stokKodu:
                                                                            fishareket.STOKKOD!,
                                                                     
                                                                        cariKod: cariEx
                                                                            .searchCariList[index]
                                                                            .KOD!,
                                                                        fiyat: fishareket
                                                                            .BRUTFIYAT!,
                                                                        iskonto:
                                                                            fishareket.ISK!,
                                                                        miktar:
                                                                            fishareket.MIKTAR!, stokkart: stokKart,
                                                                      );
                                                                    });
                                                            if (result !=
                                                                null) {
                                                              fisEx.toplam
                                                                  .value = 0.0;
                                                              fisEx.fis!.value
                                                                  .fisStokListesi
                                                                  .forEach(
                                                                      (element) {
                                                                fisEx
                                                                    .toplam = (fisEx
                                                                            .toplam +
                                                                        (element
                                                                            .KDVDAHILNETFIYAT!
                                                                            .toDouble()))
                                                                    as RxDouble;
                                                              });
                                                            }
                                                          },
                                                          child: ListTile(
                                                            title:
                                                                Text("Düzenle"),
                                                            leading: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.more_vert))
                                      ],
                                    ),
                                  ),
                                  Divider(),
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
                                                        FontWeight.w500),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                   Padding(
                                     padding: const EdgeInsets.only(top: 10),
                                     child: Divider(),
                                   ),
                                  Padding(
                                    padding: EdgeInsets.only(

                                        //left: x * .07,
                                        ),
                                    child: Container(
                                      height: y * 0.09,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .07),
                                                child: SizedBox(
                                                  width: x * .22,
                                                  child: Text(
                                                    "Miktar :",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: x * .1),
                                                child: SizedBox(
                                                    width: x * .5,
                                                    child: Text(
                                                      fishareket.MIKTAR
                                                              .toString() +
                                                          " " +
                                                          fishareket.BIRIM
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                              ),
                                            ],
                                          ),

                                          //turan
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .2,
                              ),
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
            color: Color(0xFF2494f4),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SATIR-ADET : ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    fisEx.fis!.value.fisStokListesi.length.toString(),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String donusturMusteri(String inText) {
    MoneyFormatter fmf = MoneyFormatter(amount: double.parse(inText));
    MoneyFormatterOutput fo = fmf.output;
    String tempSonTutar = fo.nonSymbol.toString();
   
    if (tempSonTutar.contains(",")) {
       String kusurat = "";
      List<String> gecici = tempSonTutar.split(",");
      for (int i = 1; i < gecici.length; i++) {
        kusurat = kusurat + gecici[i];
      }
      String kusuratSon = kusurat.replaceAll(".", ",");
      String sonYazilacak = gecici[0] + "." + kusuratSon;
      return sonYazilacak;
    } else {
      String sonYazilacak = tempSonTutar.replaceAll(".", ",");
      return sonYazilacak;
    }
  }
}
