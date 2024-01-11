import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/controllers/tahsilatController.dart';
import 'package:dukkan_cepte/odeme/odemeCari.dart';
import 'package:dukkan_cepte/odeme/odeme_tab_page.dart';
import 'package:dukkan_cepte/tahsilat/tahsilat_cari_page.dart';
import 'package:dukkan_cepte/tahsilat/tahsilat_tab_page.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilat.dart';
import 'package:dukkan_cepte/widget/appbar.dart';

import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../tahsilatOdemeModel/tahsilat_pdf_onizleme.dart';
import '../webservis/base.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';

enum PopupMenuOption { duzenle, sil, kaydet }

class odeme_main_page extends StatefulWidget {
  const odeme_main_page({super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;

  @override
  State<odeme_main_page> createState() => _tahsilat_main_pageState();
}

class _tahsilat_main_pageState extends State<odeme_main_page> {
  BaseService bs = BaseService();
  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);
  final TahsilatController tahsilatEx = Get.find();
  Color favIconColor = Colors.black;
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
      appBar: MyAppBar(height: 50, title: "Ödeme"),
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
                Icons.add,
                color: Colors.green,
                size: 32,
              ),
              label: "Yeni Belge Oluştur",
              onTap: () {
                Get.to(() => odeme_cari(
                      belgeTipi: "Ödeme",
                      tahsilatId: tahsilatEx.tahsilat!.value.ID,
                    ));
                if (tahsilatEx.tahsilat?.value.CARIKOD != "") {
                  tahsilatEx.tahsilat?.value = Tahsilat.empty();
                }
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Obx(() => ListView.builder(
                    itemCount: tahsilatEx.list_tahsilat.length,
                    itemBuilder: (context, index) {
                      Tahsilat fis = tahsilatEx.list_tahsilat[index];
                      List<String> toplamList = akbankStyle(
                          Ctanim.donusturMusteri(fis.GENELTOPLAM.toString()));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 10,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .1),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .7,
                                          child: Text(
                                            fis.CARIADI.toString(),
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Spacer(),
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
                                                    /*    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.35,
                                                            */
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                                            tahsilatEx.tahsilat!
                                                                .value = tahsilatEx
                                                                    .list_tahsilat[
                                                                index];
                                                            Get.to(() =>
                                                                odeme_detay_tab_page(
                                                                  belgeTipi:
                                                                      "Odeme",
                                                                  cariKod: fis
                                                                      .CARIKOD,
                                                                  cariKart: fis
                                                                      .cariKart,
                                                                  uuid: tahsilatEx
                                                                      .list_tahsilat[
                                                                          index]
                                                                      .UUID
                                                                      .toString(),
                                                                ));
                                                          },
                                                          child: ListTile(
                                                            title:
                                                                Text("Düzenle"),
                                                            leading: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            print("Sil");
                                                            showAlertDialog(
                                                                context, index);
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
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          TahsilatPdfOnizleme(
                                                                            m: tahsilatEx.list_tahsilat[index],
                                                                            belgeTipi:
                                                                                "Ödeme",
                                                                          )),
                                                            );
                                                          },
                                                          child: ListTile(
                                                            title: Text("PDF"),
                                                            leading: Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (tahsilatEx
                                                                    .list_tahsilat[
                                                                        index]
                                                                    .tahsilatHareket
                                                                    .length !=
                                                                0) {
                                                              Tahsilat fiss =
                                                                  tahsilatEx
                                                                          .list_tahsilat[
                                                                      index];
                                                              if (Ctanim
                                                                      .kullanici!
                                                                      .ISLEMAKTARILSIN ==
                                                                  "H") {
                                                                tahsilatEx
                                                                    .list_tahsilat[
                                                                        index]
                                                                    .DURUM = true;
                                                                Tahsilat.empty().tahsilatEkle(
                                                                    tahsilat: tahsilatEx
                                                                            .list_tahsilat[
                                                                        index],
                                                                    belgeTipi:
                                                                        "Odeme");
                                                                tahsilatEx
                                                                        .tahsilat!
                                                                        .value =
                                                                    Tahsilat
                                                                        .empty();
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return CustomAlertDialog(
                                                                        secondButtonText:
                                                                            "Tamam",
                                                                        onSecondPress:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        pdfSimgesi:
                                                                            true,
                                                                        align: TextAlign
                                                                            .center,
                                                                        title:
                                                                            'Kayıt Başarılı',
                                                                        message:
                                                                            'Ödeme Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                                                                        onPres:
                                                                            () async {
                                                                          bool
                                                                              cekMi =
                                                                              false;
                                                                          for (var element
                                                                              in fis.tahsilatHareket) {
                                                                            if (element.CEKSERINO !=
                                                                                "") {
                                                                              cekMi = true;
                                                                            }
                                                                          }
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.of(context)
                                                                              .push(
                                                                            MaterialPageRoute(
                                                                                builder: (context) => TahsilatPdfOnizleme(
                                                                                      m: fiss,
                                                                                      belgeTipi: "Ödeme",
                                                                                    )),
                                                                          );
                                                                        },
                                                                        buttonText:
                                                                            'Ödemeyi Gör',
                                                                      );
                                                                    });
                                                                await tahsilatEx
                                                                    .listTahsilatGetir(
                                                                        belgeTip:
                                                                            "Odeme");
                                                                setState(() {});
                                                              } else {
                                                                tahsilatEx
                                                                    .list_tahsilat[
                                                                        index]
                                                                    .DURUM = true;
                                                                tahsilatEx
                                                                    .list_tahsilat[
                                                                        index]
                                                                    .AKTARILDIMI = true;
                                                                int tempId =
                                                                    tahsilatEx
                                                                        .list_tahsilat[
                                                                            index]
                                                                        .ID!;
                                                                Tahsilat.empty().tahsilatEkle(
                                                                    tahsilat: tahsilatEx
                                                                            .list_tahsilat[
                                                                        index],
                                                                    belgeTipi:
                                                                        "Odeme");

                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return LoadingSpinner(
                                                                      color: Colors
                                                                          .black,
                                                                      message:
                                                                          "Online Aktarım Aktif. Ödeme Merkeze Gönderiliyor..",
                                                                    );
                                                                  },
                                                                );
                                                                await tahsilatEx
                                                                    .listGidecekTekTahsilatGetir(
                                                                        tahsilatID:
                                                                            tempId);

                                                                Map<String,
                                                                        dynamic>
                                                                    jsonListesi =
                                                                    tahsilatEx
                                                                        .list_gidecek_tahsilat[
                                                                            0]
                                                                        .toJson2();
                                                                setState(() {});

                                                                SHataModel
                                                                    gelenHata =
                                                                    await bs.ekleTahsilat(
                                                                        jsonDataList:
                                                                            jsonListesi,
                                                                        sirket:
                                                                            Ctanim.sirket!);
                                                                if (gelenHata
                                                                        .Hata ==
                                                                    "true") {
                                                                  tahsilatEx
                                                                      .list_tahsilat[
                                                                          index]
                                                                      .DURUM = false;
                                                                  tahsilatEx
                                                                      .list_tahsilat[
                                                                          index]
                                                                      .AKTARILDIMI = false;
                                                                  await Tahsilat.empty().tahsilatEkle(
                                                                      tahsilat:
                                                                          tahsilatEx.list_tahsilat[
                                                                              index],
                                                                      belgeTipi:
                                                                          "Odeme");
                                                                  LogModel
                                                                      logModel =
                                                                      LogModel(
                                                                    TABLOADI:
                                                                        "TBLTAHSILATSB",
                                                                    FISID: tahsilatEx
                                                                        .list_gidecek_tahsilat[
                                                                            0]
                                                                        .ID,
                                                                    HATAACIKLAMA:
                                                                        gelenHata
                                                                            .HataMesaj,
                                                                    UUID: tahsilatEx
                                                                        .list_gidecek_tahsilat[
                                                                            0]
                                                                        .UUID,
                                                                    CARIADI: tahsilatEx
                                                                        .list_gidecek_tahsilat[
                                                                            0]
                                                                        .CARIADI,
                                                                  );

                                                                  await VeriIslemleri()
                                                                      .logKayitEkle(
                                                                          logModel);
                                                                  print(
                                                                      "GÖNDERİM HATASI");
                                                                  await Ctanim.showHataDialog(
                                                                      context,
                                                                      gelenHata
                                                                              .HataMesaj
                                                                          .toString(),
                                                                      ikinciGeriOlsunMu:
                                                                          true);
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return CustomAlertDialog(
                                                                          pdfSimgesi:
                                                                              true,
                                                                          secondButtonText:
                                                                              "Geri",
                                                                          onSecondPress:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          align:
                                                                              TextAlign.left,
                                                                          title:
                                                                              'Başarılı',
                                                                          message:
                                                                              'Ödeme merkeze başarıyla gönderildi. PDF dosyasını görmek ister misiniz ?',
                                                                          onPres:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => TahsilatPdfOnizleme(
                                                                                        m: fiss,
                                                                                        belgeTipi: "Ödeme",
                                                                                      )),
                                                                            );
                                                                          },
                                                                          buttonText:
                                                                              'Ödemeyi Gör',
                                                                        );
                                                                      });
                                                                  await tahsilatEx
                                                                      .listTahsilatGetir(
                                                                          belgeTip:
                                                                              'Odeme');
                                                                  setState(
                                                                      () {});
                                                                  tahsilatEx
                                                                      .list_gidecek_tahsilat
                                                                      .clear();

                                                                  print(
                                                                      "ONLİNE AKRARIM AKTİF EDİLECEK");
                                                                }
                                                              }
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CustomAlertDialog(
                                                                      align: TextAlign
                                                                          .center,
                                                                      title:
                                                                          'Hata',
                                                                      message:
                                                                          'Ödemenin Kalem Listesi Boş Olamaz',
                                                                      onPres:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);

                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      buttonText:
                                                                          'Geri',
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: ListTile(
                                                            title: Text(
                                                                " Ödemeyi Kaydet"),
                                                            leading: Icon(
                                                              Icons.save,
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
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .1),
                                    child: Row(
                                      children: [
                                        Text(
                                          fis.CARIKOD.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 81, 81, 81)),
                                        )
                                      ],
                                    )),
                             
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    right: MediaQuery.of(context).size.width *
                                        0.05,
                                    left:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                       Row(
                                      children: [
                                         Text("İşlem Tipi : "),
                                     Text(
                                      fis.ISLEMTIPI.toString()== "0" ?"Normal":"Açık",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 81, 81, 81)),
                                      ),
                                      ],
                                     ),
                                      Text(fis.TARIH.toString())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Divider(
                                    thickness: 10,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            )),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
/*
  @override
  void dispose() {
    // TODO: implement dispose

    Tahsilat.empty()
        .tahsilatEkle(belgeTipi: "Odeme", tahsilat: tahsilatEx.tahsilat!.value);
    tahsilatEx.tahsilat!.value = Tahsilat.empty();
    super.dispose();
  }
  */

  List<String> akbankStyle(String text) {
    List<String> don = text.split(",");
    return don;
  }

/* eski dönüştür!
  String donusturMusteri(String inText) {
    MoneyFormatter fmf = MoneyFormatter(amount: double.parse(inText));
    MoneyFormatterOutput fo = fmf.output;
    String tempSonTutar = fo.nonSymbol.toString();
    if (tempSonTutar.contains(",")) {
      List<String> gecici = tempSonTutar.split(",");
      String kusurat = gecici[1].replaceAll(".", ",");
      String sonYazilacak = gecici[0] + "." + kusurat;
      return sonYazilacak;
    } else {
      String sonYazilacak = tempSonTutar.replaceAll(".", ",");
      return sonYazilacak;
    }
  }
*/
  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("İptal"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Devam"),
      onPressed: () {
        try {
          tahsilatEx.tahsilat?.value = tahsilatEx.list_tahsilat[index];

          Tahsilat.empty().tahsilatVeHareketSil(tahsilatEx.tahsilat!.value.ID!);
          tahsilatEx.list_tahsilat
              .removeWhere((item) => item.ID == tahsilatEx.tahsilat!.value.ID!);
          const snackBar = SnackBar(
            duration: Duration(microseconds: 500),
            content: Text(
              'Fiş silindi..',
              style: TextStyle(fontSize: 16),
            ),
            showCloseIcon: true,
            backgroundColor: Colors.blue,
            closeIconColor: Colors.white,
          );
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        } on PlatformException catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("İşlem Onayı"),
      content: Text(
          "Belge Silindiğinde Geri Döndürürelemez. Devam Etmek İstiyor musunuz?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
