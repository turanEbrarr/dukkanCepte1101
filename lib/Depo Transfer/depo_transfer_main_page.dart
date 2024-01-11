import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/Depo%20Transfer/depo_transfer_depo_secimi.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';

import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:uuid/uuid.dart';
import '../faturaFis/fis.dart';

import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../webservis/base.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import 'depo_transfer_pdf_onizleme.dart';
import 'depo_transfer_tab_page.dart';
import '../webservis/base.dart';

enum PopupMenuOption { duzenle, sil, kaydet }

//DENEME
class depo_transfer_main_page extends StatefulWidget {
  final String belgeTipi;
  final int widgetListBelgeSira;
  const depo_transfer_main_page(
      {super.key, required this.belgeTipi, required this.widgetListBelgeSira});

  @override
  State<depo_transfer_main_page> createState() =>
      _depo_transfer_main_pageState();
}

class _depo_transfer_main_pageState extends State<depo_transfer_main_page> {
  BaseService b = BaseService();
  var uuid = Uuid();
  Color favIconColor = Colors.black;
  FisController fisEx = Get.find();
  TextStyle bold = const TextStyle(fontWeight: FontWeight.bold);

  @override
  /*
  void dispose() {
    Fis.empty().fisEkle(fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
    fisEx.fis!.value = Fis.empty();
    super.dispose();
    //listede güncelleme yaptı ve çıktı
  }
  */

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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        backgroundColor: Color.fromARGB(255, 30, 38, 45),
        buttonSize: Size(65, 65),
        children: [
           SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.refresh,
                color: Colors.black,
                size: 32,
              ),
              label: "Listeyi Yenile",
              onTap: () {
                fisEx.listFisGetir(belgeTip: "Depo_Transfer");
                setState(() {
                  
                });
              }),
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
                Get.to(() => depo_transfer_depo_secimi());
              }),
             
            
        ],
      ),
      appBar: MyAppBar(
          height: 50, title: Ctanim().MapFisTR[widget.belgeTipi].toString()),
      body: Column(
        children: [
          //BURADA FİYATA DAİR BİR ŞEY BIRAKMA
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Obx(() => ListView.builder(
                    itemCount: fisEx.list_fis.length,
                    itemBuilder: (context, index) {
                      Fis fis = fisEx.list_fis[index];
                      String subeAdi = "";
                      String depoAdi = "";

                      for (var element in listeler.listSubeDepoModel) {
                        if (element.SUBEID == fis.GIDENSUBEID) {
                          subeAdi = element.SUBEADI!;
                        }
                        if (element.DEPOID == fis.GIDENDEPOID) {
                          depoAdi = element.DEPOADI!;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            elevation: 10,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .1),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .35,
                                              child: Text(
                                                "Gönderilen Şube:",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .31,
                                              child: Text(
                                                subeAdi,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16.0),
                                                      ),
                                                    ),
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        padding: EdgeInsets.all(
                                                            16.0),
                                                       
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
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                fisEx.fis
                                                                        ?.value =
                                                                    fisEx.list_fis[
                                                                        index];
                                                                Get.to(() =>
                                                                    depo_transfer_tab_page(
                                                                      belgeTipi:
                                                                          widget
                                                                              .belgeTipi,
                                                                      fis_id: fisEx
                                                                          .fis!
                                                                          .value
                                                                          .ID!,
                                                                    ));
                                                              },
                                                              child: ListTile(
                                                                title: Text(
                                                                    "Düzenle"),
                                                                leading: Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                         
                                                                showAlertDialog(
                                                                    context,
                                                                    index);
                                                              },
                                                              child: ListTile(
                                                                title:
                                                                    Text("Sil"),
                                                                leading: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          DepoTransferPdfOnizleme(
                                                                              m: fisEx.list_fis[index])),
                                                                );
                                                              },
                                                              child: ListTile(
                                                                title:
                                                                    Text("PDF"),
                                                                leading: Icon(
                                                                  Icons
                                                                      .picture_as_pdf,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .fisStokListesi
                                                                        .length !=
                                                                    0) {
                                                                  Fis fiss =
                                                                      fisEx.list_fis[
                                                                          index];
                                                                  if (Ctanim
                                                                          .kullanici!
                                                                          .ISLEMAKTARILSIN ==
                                                                      "H") {
                                                                    final now =
                                                                        DateTime
                                                                            .now();
                                                                    final formatter =
                                                                        DateFormat(
                                                                            'HH:mm');
                                                                    String
                                                                        saat =
                                                                        formatter
                                                                            .format(now);

                                                                    fisEx
                                                                        .fis!
                                                                        .value
                                                                        .KDVDAHIL = "H";

                                                                    fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .DURUM = true;
                                                                    fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .SAAT = saat;
                                                                    Fis.empty().fisEkle(
                                                                        fis: fisEx.list_fis[
                                                                            index],
                                                                        belgeTipi:
                                                                            widget.belgeTipi);
                                                                    fisEx.fis!
                                                                            .value =
                                                                        Fis.empty();
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
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            pdfSimgesi:
                                                                                true,
                                                                            align:
                                                                                TextAlign.center,
                                                                            title:
                                                                                'Kayıt Başarılı',
                                                                            message:
                                                                                'Transfer Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                                                                            onPres:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              Navigator.of(context).push(
                                                                                MaterialPageRoute(builder: (context) => DepoTransferPdfOnizleme(m: fiss)),
                                                                              );
                                                                            },
                                                                            buttonText:
                                                                                'Transferi Gör',
                                                                          );
                                                                        });
                                                                    await fisEx.listFisGetir(
                                                                        belgeTip:
                                                                            widget.belgeTipi);
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    final now =
                                                                        DateTime
                                                                            .now();
                                                                    final formatter =
                                                                        DateFormat(
                                                                            'HH:mm');
                                                                    String
                                                                        saat =
                                                                        formatter
                                                                            .format(now);

                                                                    fisEx
                                                                        .fis!
                                                                        .value
                                                                        .KDVDAHIL = "H";

                                                                    fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .DURUM = true;
                                                                        fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .AKTARILDIMI = true;
                                                                    fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .SAAT = saat;
                                                                    Fis.empty().fisEkle(
                                                                        fis: fisEx.list_fis[
                                                                            index],
                                                                        belgeTipi:
                                                                            widget.belgeTipi);
                                                                    int tempID = fisEx
                                                                        .list_fis[
                                                                            index]
                                                                        .ID!;

                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return LoadingSpinner(
                                                                          color:
                                                                              Colors.black,
                                                                          message:
                                                                              "Online Aktarım Aktif. Transfer Merkeze Gönderiliyor..",
                                                                        );
                                                                      },
                                                                    );
                                                                    await fisEx.listGidecekTekFisGetir(
                                                                        belgeTip:
                                                                            widget
                                                                                .belgeTipi,
                                                                        fisID:
                                                                            tempID);

                                                                    Map<String,
                                                                            dynamic>
                                                                        jsonListesi =
                                                                        fisEx
                                                                            .list_fis_gidecek[0]
                                                                            .toJson2();
                                                                    setState(
                                                                        () {});

                                                                    SHataModel
                                                                        gelenHata =
                                                                        await b.ekleFatura(
                                                                            jsonDataList:
                                                                                jsonListesi,
                                                                            sirket:
                                                                                Ctanim.sirket!);
                                                                    if (gelenHata
                                                                            .Hata ==
                                                                        "true") {
                                                                      fisEx
                                                                          .list_fis[
                                                                              index]
                                                                          .DURUM = false;
                                                                           fisEx
                                                                          .list_fis[
                                                                              index]
                                                                          .AKTARILDIMI = false;
                                                                      await Fis.empty().fisEkle(
                                                                          fis: fisEx.list_fis[
                                                                              index],
                                                                          belgeTipi:
                                                                              widget.belgeTipi);
                                                                      LogModel
                                                                          logModel =
                                                                          LogModel(
                                                                            TABLOADI: "TBLFISSB",
                                                                        FISID: fisEx
                                                                            .list_fis_gidecek[0]
                                                                            .ID,
                                                                        HATAACIKLAMA:
                                                                            gelenHata.HataMesaj,
                                                                        UUID: fisEx
                                                                            .list_fis_gidecek[0]
                                                                            .UUID,
                                                                        CARIADI: fisEx
                                                                            .list_fis_gidecek[0]
                                                                            .CARIADI,
                                                                      );

                                                                      await VeriIslemleri()
                                                                          .logKayitEkle(
                                                                              logModel);
                                                         
                                                                      await Ctanim.showHataDialog(
                                                                          context,
                                                                          gelenHata.HataMesaj
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
                                                                              pdfSimgesi: true,
                                                                              secondButtonText: "Geri",
                                                                              onSecondPress: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              align: TextAlign.left,
                                                                              title: 'Başarılı',
                                                                              message:  'Transfer merkeze başarıyla gönderildi. PDF dosyasını görmek ister misiniz ?',
                                                                              onPres: () async {
                                                                                Navigator.pop(context);
                                                                                Navigator.of(context).push(
                                                                                  MaterialPageRoute(builder: (context) => DepoTransferPdfOnizleme(m: fiss)),
                                                                                );
                                                                              },
                                                                              buttonText: 'Transferi Gör',
                                                                            );
                                                                          });
                                                                      await fisEx.listFisGetir(
                                                                          belgeTip:
                                                                              "Depo_Transfer");
                                                                      setState(
                                                                          () {});
                                                                      fisEx
                                                                          .list_fis_gidecek
                                                                          .clear();

                                                                    }
                                                                  }
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return CustomAlertDialog(
                                                                          align:
                                                                              TextAlign.center,
                                                                          title:
                                                                              'Hata',
                                                                          message:
                                                                              'Transferin Kalem Listesi Boş Olamaz',
                                                                          onPres:
                                                                              () async {
                                                                            Navigator.pop(context);

                                                                            setState(() {});
                                                                          },
                                                                          buttonText:
                                                                              'Geri',
                                                                        );
                                                                      });
                                                                }
                                                              },
                                                              child: ListTile(
                                                                title: Text(
                                                                    " Transferi Kaydet"),
                                                                leading: Icon(
                                                                  Icons.save,
                                                                  color: Colors
                                                                      .green,
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
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .35,
                                              child: Text(
                                                "Gönderilen Depo:",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .41,
                                              child: Text(
                                                depoAdi,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),

                                        /*
                                        PopupMenuButton<PopupMenuOption>(
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem<PopupMenuOption>(
                                              value: PopupMenuOption.duzenle,
                                              child: Text('Düzenle'),
                                            ),
                                            PopupMenuItem<PopupMenuOption>(
                                              value: PopupMenuOption.sil,
                                              child: Text('Sil'),
                                            ),
                                            PopupMenuItem<PopupMenuOption>(
                                              value: PopupMenuOption.kaydet,
                                              child: Text('Kaydet'),
                                            ),
                                          ],
                                          onSelected: (PopupMenuOption option) {
                                            if (option ==
                                                PopupMenuOption.duzenle) {
                                              fisEx.fis?.value =
                                                  fisEx.list_fis[index];
                                              Get.to(() => depo_transfer_tab_page(
                                                    belgeTipi: widget.belgeTipi,
                                                    cariKod: fis.CARIKOD,
                                                    cariKart: fis.cariKart,
                                                  ));
                                            } else if (option ==
                                                PopupMenuOption.sil) {
                                              print("Sil");
                                              showAlertDialog(context, index);
                                            } else if (option ==
                                                PopupMenuOption.kaydet) {
                                              fisEx.list_fis[index].DURUM =
                                                  true;
                                              Fis.empty().fisEkle(
                                                  fis: fisEx.list_fis[index],
                                                  belgeTipi: widget.belgeTipi);
                                              fisEx.fis!.value = Fis.empty();

                                              fisEx.listFisGetir(
                                                  belgeTip: widget.belgeTipi);

                                              super.dispose();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomAlertDialog(
                                                      title: 'Kayıt Başarılı',
                                                      message:
                                                          'Fatura Kaydedildi',
                                                      onPres: () {
                                                        Get.back();
                                                        setState(() {});
                                                      },
                                                      buttonText: 'Tamam',
                                                    );
                                                  });

                                              ////////

                                              /*ONLİNE AKRARIM AKTİF EDİLECEK*/

                                              //////////
                                              if (true) {
                                                print(
                                                    "ONLİNE AKRARIM AKTİF EDİLECEK");
                                              }
                                            }
                                          },
                                        ),
                                        */
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
                                      top: 40,
                                      left: MediaQuery.of(context).size.width *
                                          .1),
                                  child: Row(
                                    children: [
                                      Text(
                                        "İşlem Tarihi",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 81, 81, 81)),
                                      )
                                    ],
                                  ),
                                ),
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
                                      Text(fis.TARIH.toString()),
                                      Text(fis.DOVIZ.toString())
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Divider(
                                    thickness: 10,
                                    color: Colors.green,
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

  List<String> akbankStyle(String text) {
    List<String> don = text.split(",");
    return don;
  }

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
          fisEx.fis?.value = fisEx.list_fis[index];
          Fis.empty().fisVeHareketSil(fisEx.fis!.value.ID!);
          fisEx.list_fis.removeWhere((item) => item.ID == fisEx.fis!.value.ID!);
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
         
        }
        Navigator.pop(context);
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
