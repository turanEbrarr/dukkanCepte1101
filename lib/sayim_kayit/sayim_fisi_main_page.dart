import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dukkan_cepte/Depo%20Transfer/depo.dart';
import 'package:dukkan_cepte/controllers/depoController.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_fis_detay.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_kayit_depo_secimi.dart';
import 'package:dukkan_cepte/sayim_kayit/sayim_kayit_tab_page.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import '../Depo Transfer/depo_transfer_tab_page.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../webservis/base.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';

import '../widget/ctanim.dart';

class sayim_fisi_main_page extends StatefulWidget {
  const sayim_fisi_main_page({super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;
  @override
  State<sayim_fisi_main_page> createState() => _sayim_fisi_main_pageState();
}

class _sayim_fisi_main_pageState extends State<sayim_fisi_main_page> {
  BaseService bs = BaseService();
  SayimController fisEx = Get.find();
  Color favIconColor = Colors.black;
  @override
  bool? check1 = false;
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
      appBar: MyAppBar(height: 50, title: "Sayım Fişi"),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => sayim_kayit_depo_secimi()));
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
                    itemCount: fisEx.list_Depo.length,
                    itemBuilder: (context, index) {
                      Sayim fis = fisEx.list_Depo[index];
                      String subeAdi = "";
                      String depoAdi = "";

                      for (var element in listeler.listSubeDepoModel) {
                        if (element.SUBEID == fis.SUBEID) {
                          subeAdi = element.SUBEADI!;
                        }
                        if (element.DEPOID == fis.DEPOID) {
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
                                                       /* height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.3,*/
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
                                                                fisEx.sayim
                                                                        ?.value =
                                                                    fisEx.list_Depo[
                                                                        index];
                                                                Get.to(() =>
                                                                    sayim_kayit_tab_page(
                                                                      fis_id: fisEx
                                                                          .sayim!
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
                                                                print("Sil");
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
                                                              onTap: () async {
                                                                if (fisEx
                                                                        .list_Depo[
                                                                            index]
                                                                        .sayimStokListesi
                                                                        .length !=
                                                                    0) {
                                                                  if (Ctanim
                                                                          .kullanici!
                                                                          .ISLEMAKTARILSIN ==
                                                                      "H") {
                                                                    fisEx
                                                                        .list_Depo[
                                                                            index]
                                                                        .DURUM = true;
                                                                    Sayim.empty()
                                                                        .sayimEkle(
                                                                      sayim: fisEx
                                                                              .list_Depo[
                                                                          index],
                                                                    );
                                                                    fisEx.sayim!
                                                                            .value =
                                                                        Sayim
                                                                            .empty();
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return CustomAlertDialog(
                                                                            align:
                                                                                TextAlign.center,
                                                                            title:
                                                                                'Kayıt Başarılı',
                                                                            message:
                                                                                'Sayım Kaydedildi.',
                                                                            onPres:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            buttonText:
                                                                                'Tamam',
                                                                          );
                                                                        });
                                                                    await fisEx
                                                                        .listSayimGetir();
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    fisEx
                                                                        .list_Depo[
                                                                            index]
                                                                        .DURUM = true;
                                                                    fisEx
                                                                        .list_Depo[
                                                                            index]
                                                                        .AKTARILDIMI = true;
                                                                    Sayim.empty()
                                                                        .sayimEkle(
                                                                      sayim: fisEx
                                                                              .list_Depo[
                                                                          index],
                                                                    );
                                                                    int tempID = fisEx
                                                                        .list_Depo[
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
                                                                              "Online Aktarım Aktif. Sayım Merkeze Gönderiliyor..",
                                                                        );
                                                                      },
                                                                    );
                                                                    await fisEx.listGidecekTekDepoGetir(
                                                                        sayimID:
                                                                            tempID);

                                                                    Map<String,
                                                                            dynamic>
                                                                        jsonListesi =
                                                                        fisEx
                                                                            .list_gidecek_Depo[0]
                                                                            .toJson2();
                                                                    setState(
                                                                        () {});

                                                                    SHataModel
                                                                        gelenHata =
                                                                        await bs.ekleSayim(
                                                                            jsonDataList:
                                                                                jsonListesi,
                                                                            sirket:
                                                                                Ctanim.sirket!);
                                                                    if (gelenHata
                                                                            .Hata ==
                                                                        "true") {
                                                                      fisEx
                                                                          .list_Depo[
                                                                              index]
                                                                          .DURUM = false;
                                                                      fisEx
                                                                          .list_Depo[
                                                                              index]
                                                                          .AKTARILDIMI = false;
                                                                      await Sayim
                                                                              .empty()
                                                                          .sayimEkle(
                                                                              sayim: fisEx.list_Depo[index]);
                                                                      LogModel
                                                                          logModel =
                                                                          LogModel(
                                                                            TABLOADI: "TBLSAYIMSB",
                                                                        FISID: fisEx
                                                                            .list_gidecek_Depo[0]
                                                                            .ID,
                                                                        HATAACIKLAMA:
                                                                            gelenHata.HataMesaj,
                                                                        UUID: fisEx
                                                                            .list_gidecek_Depo[0]
                                                                            .UUID,
                                                                        CARIADI: fisEx
                                                                            .list_gidecek_Depo[0]
                                                                            .ACIKLAMA,
                                                                      );

                                                                      await VeriIslemleri()
                                                                          .logKayitEkle(
                                                                              logModel);
                                                                      print(
                                                                          "GÖNDERİM HATASI");

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
                                                                              align: TextAlign.left,
                                                                              title: 'Başarılı',
                                                                              message: 'Sayım merkeze başarıyla gönderildi.',
                                                                              onPres: () async {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              buttonText: 'Tamam',
                                                                            );
                                                                          });
                                                                      await fisEx
                                                                          .listSayimGetir();
                                                                      setState(
                                                                          () {});
                                                                      fisEx
                                                                          .list_gidecek_Depo
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
                                                                          align:
                                                                              TextAlign.center,
                                                                          title:
                                                                              'Hata',
                                                                          message:
                                                                              'Sayımın Kalem Listesi Boş Olamaz',
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
                                                                    " Sayımı Kaydet"),
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
                                          fis.ACIKLAMA == null || fis.ACIKLAMA == ""
                                              ? ""
                                              : fis.ACIKLAMA.toString(),
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
                                      //Text(fis.DOVIZ.toString())
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
          fisEx.sayim?.value = fisEx.list_Depo[index];
          print(fisEx.sayim?.value.ID);
          Sayim.empty().sayimVeHareketSil(fisEx.sayim!.value.ID!);
          fisEx.list_Depo
              .removeWhere((item) => item.ID == fisEx.sayim!.value.ID!);
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
