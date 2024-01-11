import 'dart:ffi';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/customAlertDialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widget/ctanim.dart';
import 'package:get/get.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../Depo Transfer/depo_transfer_main_page.dart';
import '../cari_raporlari/cari_raporlari_main_page.dart';

import '../cari_kart/cari_islemler_page.dart';
import '../stok_kart/Spinkit.dart';

import '../controllers/fisController.dart';
import '../controllers/depoController.dart';
import '../fatura_raporlari/fatura_raporlari_main_page.dart';

import '../odeme/odeme_main_page.dart';
import '../sayim_kayit/sayim_fisi_main_page.dart';

import '../stok_raporlari/stok_raporlari_main_page.dart';
import '../tahsilat/tahsilat_main_page.dart';
import '../veri_islemleri/veri_kayit_main_page.dart';
import '../webservis/base.dart';
import 'appbar.dart';
import 'drawer.dart';
import '../controllers/tahsilatController.dart';
import '../genel_belge.dart/genel_belge_main_page.dart';
import '../stok_kart/stok_kart_listesi.dart';
import '../widget/veriler/listeler.dart';
import '../widget/silmeDuzenleme.dart';
import '../faturaFis/fis.dart';

import '../tahsilatOdemeModel/tahsilat.dart';
import '../genel_belge.dart/genel_belge_tab_page.dart';
import '../Depo Transfer/depo_transfer_tab_page.dart';
import '../tahsilat/tahsilat_tab_page.dart';
import '../odeme/odeme_tab_page.dart';
import '../tahsilat/deneme3.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int len = 0;
  BaseService bs = BaseService();
  static FisController fisEx = Get.find();
  static TahsilatController tahsilatEx = Get.find();
  static SayimController sayimEx = Get.find();
  bool isLoading = true;
  List<Widget> son = [];
  List<Fis> gelenFis = [];
  List<Tahsilat> gelenTahsilat = [];

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    tahsilatEx.list_tahsilat_son10.clear();

    fisEx.list_fis_son10.clear();
    //await fisEx.getFisSayisi();

    var a = await fisEx.listSonFisleriGetir();
    var b = await tahsilatEx.listSonTahsilatlarGetir();
    setState(() {
      gelenFis = a;
      gelenTahsilat = b as List<Tahsilat>;
      isLoading = false;
      // boolController.updateBool(false);
      // boolController.updateBoolLong(false);
    });
  }
 

  @override
  initState() {
    // TODO: implement initState

    super.initState();

    loadData();

    List<Widget> w = [
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 0;
              Get.to(() => cari_islemler_page(
                    widgetListBelgeSira: widgetListBelgeSira,
                  ));
            }
          },
          child: widgetTasarim(
            title: "Cari Kart Listesi",
            icon: Icons.groups_sharp,
            color: 0xFF4D6275,
            widgetBelgeSira: 0,
          )),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 1;

              fisEx
                  .listFisGetir(belgeTip: "Satis_Fatura")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Satis_Fatura",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
            title: "Satış Fatura Kayıt",
            icon: Icons.shopping_bag,
            color: 0xFFF29638,
            widgetBelgeSira: 1,
            belgeTipi: "Satis_Fatura",
          )),
      GestureDetector(
          onTap: () {
            if (boolController.isLong.value == false) {
              int widgetListBelgeSira = 2;
              fisEx
                  .listFisGetir(belgeTip: "Satis_Irsaliye")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Satis_Irsaliye",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 2,
              title: "Satış İrsaliye",
              icon: Icons.receipt_long,
              belgeTipi: "Satis_Irsaliye",
              color: 0xFFF29638)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 3;
              fisEx
                  .listFisGetir(belgeTip: "Alis_Irsaliye")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Alis_Irsaliye",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 3,
              title: "Alış İrsaliye",
              belgeTipi: "Alis_Irsaliye",
              icon: Icons.receipt_long,
              color: 0xFFF29638)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 4;
              fisEx
                  .listFisGetir(belgeTip: "Alinan_Siparis")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Alinan_Siparis",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 4,
              title: "Alınan Sipariş",
              belgeTipi: "Alinan_Siparis",
              icon: Icons.south_east,
              color: 0xFF0A8916)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 5;
              fisEx
                  .listFisGetir(belgeTip: "Musteri_Siparis")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Musteri_Siparis",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 5,
              title: "Müşteri Sipariş",
              belgeTipi: "Musteri_Siparis",
              icon: Icons.shopping_cart,
              color: 0xFF0A8916)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 6;
              fisEx
                  .listFisGetir(belgeTip: "Satis_Teklif")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Satis_Teklif",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 6,
              title: "Satış Teklif",
              belgeTipi: "Satis_Teklif",
              icon: Icons.real_estate_agent,
              color: 0xFF0A8916)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 7;
              Get.to(() => stok_kart_listesi(
                    widgetListBelgeSira: widgetListBelgeSira,
                  ));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 7,
              title: "Stok Kart Listesi",
              icon: Icons.app_registration_outlined,
              color: 0xFF595E72)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 8;
              fisEx
                  .listFisGetir(belgeTip: "Depo_Transfer")
                  .then((value) => Get.to(() => depo_transfer_main_page(
                        belgeTipi: "Depo_Transfer",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 8,
              title: "Depo Transfer",
              belgeTipi: "Depo_Transfer",
              icon: Icons.local_shipping,
              color: 0xFF595E72)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 9;
              sayimEx
                  .listSayimGetir()
                  .then((value) => Get.to(() => sayim_fisi_main_page(
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              belgeTipi: "Sayim",
              widgetBelgeSira: 9,
              title: "Sayım Kayıt Fişi",
              icon: Icons.content_paste_search_rounded,
              color: 0xFF595E72)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 10;
              fisEx
                  .listFisGetir(belgeTip: "Perakende_Satis")
                  .then((value) => Get.to(() => const genel_belge_main_page(
                        belgeTipi: "Perakende_Satis",
                        widgetListBelgeSira: 10,
                      )));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 10,
              title: "Perakende Satış",
              belgeTipi: "Perakende_Satis",
              icon: Icons.store_mall_directory,
              color: 0xFF595E72)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 11;
              tahsilatEx
                  .listTahsilatGetir(belgeTip: "Tahsilat")
                  .then((value) => Get.to(() => tahsilat_main_page(
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: widgetTasarim(
              belgeTipi: "Tahsilat",
              widgetBelgeSira: 11,
              title: "Tahsilat",
              icon: Icons.add_card_outlined,
              color: 0xFF5D86CC)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 12;
              tahsilatEx
                  .listTahsilatGetir(belgeTip: "Odeme")
                  .then((value) => Get.to(() => odeme_main_page(
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child:  widgetTasarim(
              belgeTipi: "Odeme",
              widgetBelgeSira: 12,
              title: "Odeme",
              icon: Icons.payments,
              color: 0xFF5D86CC)
              ),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 13;
        
            }
          },
          child: Container()),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 14;
              Get.to(() => veri_kayit_main_page(
                    widgetListBelgeSira: widgetListBelgeSira,
                  ));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 14,
              title: "Veri İşlemleri",
              icon: Icons.data_saver_off_sharp,
              color: 0xFFD0BF3C)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 15;
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 15,
              title: "Raporlar",
              icon: Icons.abc,
              color: 0xFFD0BF3C)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 16;
              Get.to(() => cari_raporlari_main_page(
                    widgetListBelgeSira: widgetListBelgeSira,
                  ));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 16,
              title: "Cari Raporları",
              icon: Icons.badge,
              color: 0xFFB3BCB3)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 17;
              Get.to(() => stok_raporlari_main_page(
                    widgetListBelgeSira: widgetListBelgeSira,
                  ));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 17,
              title: "Stok Raporları",
              icon: Icons.query_stats,
              color: 0xFFB3BCB3)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 18;
              Get.to(() => stok_raporlari_main_page(
                    widgetListBelgeSira: widgetListBelgeSira,
                  ));
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 18,
              title: "Sipariş Raporları",
              icon: Icons.trending_up,
              color: 0xFFB3BCB3)),
      GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 19;
            
            }
          },
          child: Container()),
      GestureDetector(
        onTap: () {
          if (boolController.ust.value == false) {
            int widgetListBelgeSira = 20;
            Get.to(() => fatura_raporlari_main_page(
                  widgetListBelgeSira: widgetListBelgeSira,
                  cariGonderildiMi: false,
                ));
          }
        },
        child: widgetTasarim(
            widgetBelgeSira: 20,
            title: "İraliye Raporları",
            icon: Icons.timeline,
            color: 0xFFB3BCB3),
      ),
      GestureDetector(
        onTap: () {
          if (boolController.ust.value == false) {
            int widgetListBelgeSira = 21;
           
          }
        },
        child: Container(),
      ),
      GestureDetector(
        onTap: () async {
          if (boolController.ust.value == false) {
            int widgetListBelgeSira = 22;
            if (await Connectivity().checkConnectivity() ==
                ConnectivityResult.none) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      align: TextAlign.center,
                      title: 'Hata',
                      message: "İnternet Bağlantısı Bulunamadı!",
                      onPres: () {
                        Navigator.pop(context);
                      },
                      buttonText: 'Tamam',
                    );
                  });
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingSpinner(
                    color: Colors.black,
                    message: "Yönetimsel Raporlar Hazırlanıyor...",
                  );
                },
              );
              try {
                List<List<dynamic>> gelenNakitDurum =
                    await bs.getirFinansNakitDurum(sirket: Ctanim.sirket!);
                List<List<dynamic>> gelenSatisDurum =
                    await bs.getirFinansSatisDurum(sirket: Ctanim.sirket!);
                List<List<dynamic>> gelenSiparisTeklifDurum = await bs
                    .getirFinansSiparisTeklifDurum(sirket: Ctanim.sirket!);
                List<List<dynamic>> gelenCekSenetDurum =
                    await bs.getirFinansCekSenetDurum(sirket: Ctanim.sirket!);
                List<List<dynamic>> gelenCariDurum =
                    await bs.getirFinansCariDurum(sirket: Ctanim.sirket!);
                String genelHata = "";
                if (gelenNakitDurum[0].length == 1 &&
                    gelenNakitDurum[1].length == 0 &&
                    gelenNakitDurum[2].length == 0) {
                  genelHata = genelHata + "\n" + gelenNakitDurum[0][0];
                }
                if (gelenSatisDurum[0].length == 1 &&
                    gelenSatisDurum[1].length == 0 &&
                    gelenSatisDurum[2].length == 0) {
                  genelHata = genelHata + "\n" + gelenSatisDurum[0][0];
                }
                if (gelenSiparisTeklifDurum[0].length == 1 &&
                    gelenSiparisTeklifDurum[1].length == 0 &&
                    gelenSiparisTeklifDurum[2].length == 0) {
                  genelHata = genelHata + "\n" + gelenSiparisTeklifDurum[0][0];
                }
                if (gelenCekSenetDurum[0].length == 1 &&
                    gelenCekSenetDurum[1].length == 0 &&
                    gelenCekSenetDurum[2].length == 0) {
                  genelHata = genelHata + "\n" + gelenCekSenetDurum[0][0];
                }
                if (gelenCariDurum[0].length == 1 &&
                    gelenCariDurum[1].length == 0 &&
                    gelenCariDurum[2].length == 0) {
                  genelHata = genelHata + "\n" + gelenCekSenetDurum[0][0];
                }
                if (genelHata != "") {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          align: TextAlign.left,
                          title: 'Hata',
                          message:
                              'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                  genelHata,
                          onPres: () async {
                       
                          },
                          buttonText: 'Devam Et',
                        );
                      });
                } else {
                
                }
              } catch (error) {
                print("Hata: $error");
                const snackBar = SnackBar(
                  content: Text(
                    'Raporlar Çekilirken Hata Oluştu.',
                    style: TextStyle(fontSize: 16),
                  ),
                  showCloseIcon: true,
                  backgroundColor: Colors.blue,
                  closeIconColor: Colors.white,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          }
        },
        child: widgetTasarim(
            widgetBelgeSira: 22,
            title: "Yönetimsel Raporlar",
            icon: Icons.manage_accounts,
            color: 0xFFB3BCB3),
      ),
      //// LAAAAA 23 DEĞİL 22 YAPACAZ
      ///
         GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 23;
              fisEx
                  .listFisGetir(belgeTip: "Alis_Fatura")
                  .then((value) => Get.to(() => genel_belge_main_page(
                        belgeTipi: "Alis_Fatura",
                        widgetListBelgeSira: widgetListBelgeSira,
                      )));
            }
          },
          child: Container()),
                       GestureDetector(
          onTap: () {
            if (boolController.ust.value == false) {
              int widgetListBelgeSira = 24;
                   
                  
            
            }
          },
          child: widgetTasarim(
              widgetBelgeSira: 23,
              title: "Stok Etiket",
              belgeTipi: "sa",
              icon:   Icons.crop_sharp,
              color: 0xFFF29638)),
    ];
    print("abcde" + listeler.sayfaDurum.length.toString());
    for (int i = 0; i < listeler.sayfaDurum.length; i++) {
      print(w[i].toString());
      if (listeler.sayfaDurum[i] == true) {
        son.add(w[i]);
      }
    }
  }

  final BoolController boolController = Get.put(BoolController());
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    BaseService bs = new BaseService();
    // double ekranYuksekligi = ekranBilgisi.size.height;
    // double ekranGenisligi = ekranBilgisi.size.width;
    // int colonAdet = 2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(
        height: 50,
        title: "Anasayfa",
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (boolController.isLong.value) {
                  setState(() {
                    boolController.updateBool(false);
                    boolController.updateBoolLong(false);
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /*
                          Icon(Icons.history),
                          SizedBox(width: 5,),
                          */
                            Text(
                              "Bekleyen Fatura İşlemlerim",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: isLoading
                          ? Center(
                              child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/eeBlue.gif',
                                  width: 80, height: 80),
                            ))
                          : gelenFis.length < 1
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                            "Bekleyen Fatura İşleminiz Yok."),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: gelenFis.length,
                                  itemBuilder: (context, index) {
                                    String gidenSube = "";
                                    String gidenDepo = "";

                                    Fis fis = gelenFis[index];
                                    if (fis.CARIADI == "") {
                                      for (var element
                                          in listeler.listSubeDepoModel) {
                                        if (fis.GIDENSUBEID == element.SUBEID) {
                                          gidenSube = element.SUBEADI!;
                                        }
                                        if (fis.GIDENDEPOID == element.DEPOID) {
                                          gidenDepo = element.DEPOADI!;
                                        }
                                      }
                                    }
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (boolController.isLong.value) {
                                                setState(() {
                                                  boolController
                                                      .updateBool(false);
                                                  boolController
                                                      .updateBoolLong(false);
                                                });
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage(),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                if (Ctanim()
                                                        .MapFisTipTersENG[
                                                            fis.TIP]
                                                        .toString() !=
                                                    "Depo_Transfer") {
                                                  print("Depo değil");
                                                  fisEx.fis?.value =
                                                      gelenFis[index];
                                                  Get.to(() =>
                                                      genel_belge_tab_page(
                                                   
                                                        belgeTipi: Ctanim()
                                                                .MapFisTipTersENG[
                                                            fis.TIP]!,
                                                        cariKod: fis.CARIKOD,
                                                        cariKart: fis.cariKart,
                                                      ));
                                                } else {
                                                  print("depo");
                                                  fisEx.fis?.value =
                                                      gelenFis[index];
                                                  Get.to(() =>
                                                      depo_transfer_tab_page(
                                                        belgeTipi: Ctanim()
                                                                .MapFisTipTersENG[
                                                            fis.TIP]!,
                                                        fis_id: fisEx
                                                            .fis!.value.ID!,
                                                      ));
                                                }
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.history,
                                                  color: Colors.green,
                                                ),
                                                title: fis.CARIADI != ""
                                                    ? Text(
                                                        fis.CARIADI! +
                                                            " (" +
                                                            Ctanim()
                                                                .MapFisTipTers[
                                                                    fis.TIP]
                                                                .toString() +
                                                            ")",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    : Text(
                                                        gidenSube +
                                                            "/" +
                                                            gidenDepo +
                                                            " (" +
                                                            Ctanim()
                                                                .MapFisTipTers[
                                                                    fis.TIP]
                                                                .toString() +
                                                            ")",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                subtitle: fis.CARIADI != ""
                                                    ? Text(
                                                        "Tutar: " +
                                                            Ctanim.donusturMusteri(
                                                                fis.GENELTOPLAM!
                                                                    .toString()),
                                                      )
                                                    : Text(
                                                        "Tarih :" + fis.TARIH!,
                                                      ),
                                                trailing: Icon(
                                                    Icons.arrow_right_rounded),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /*
                                          Icon(Icons.history),
                                          SizedBox(width: 5,),
                                          */
                            Text(
                              "Bekleyen Tahsilat & Ödeme İşlemlerim",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: isLoading
                          ? Center(
                              child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('images/eeBlue.gif',
                                  width: 80, height: 80),
                            ))
                          : gelenTahsilat.length < 1
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                            "Bekleyen Tahsilat & Ödeme İşleminiz Yok."),
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: gelenTahsilat.length,
                                  itemBuilder: (context, index) {
                                    Tahsilat fis = gelenTahsilat[index];
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (boolController.isLong.value) {
                                                setState(() {
                                                  boolController
                                                      .updateBool(false);
                                                  boolController
                                                      .updateBoolLong(false);
                                                });
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MainPage(),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              } else {
                                                if (Ctanim()
                                                        .MapIlslemTipTers[
                                                            fis.TIP]
                                                        .toString() ==
                                                    "Tahsilat") {
                                                  tahsilatEx.tahsilat!.value =
                                                      gelenTahsilat[index];
                                                  Get.to(() =>
                                                      tahsilat_tab_page(
                                                        belgeTipi: Ctanim()
                                                            .MapIlslemTipTers[
                                                                fis.TIP]
                                                            .toString(),
                                                        cariKod: fis.CARIKOD,
                                                        cariKart: fis.cariKart,
                                                        uuid: fis.UUID!,
                                                      ));
                                                } else {
                                                  tahsilatEx.tahsilat!.value =
                                                      gelenTahsilat[index];
                                                  Get.to(() =>
                                                      odeme_detay_tab_page(
                                                          cariKart:
                                                              fis.cariKart,
                                                          uuid: fis.UUID!));
                                                }
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.history,
                                                  color: Colors.green,
                                                ),
                                                title: Text(
                                                  fis.CARIADI! +
                                                      " (" +
                                                      Ctanim()
                                                          .MapIlslemTipTers[
                                                              fis.TIP]
                                                          .toString() +
                                                      ")",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                trailing: Icon(
                                                    Icons.arrow_right_rounded),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Container(
                        height: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Favori İşlemlerim",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        child: 
                        son.isEmpty ? Center(child: Column(
                          children: [
                            Icon(Icons.star_border_outlined,color: Colors.amber,),
                            Text("Favori İşlemleriniz Boş."),
                          ],
                        )) :ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: son.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            return son[index];
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /*
          Obx(() {
            return boolController.ust.value == true
                ? SizedBox(
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text("Düzenleme Modu Açık      "),
                          Text(
                            "✓",
                            style: TextStyle(color: Colors.green),
                          ),
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  boolController.updateBool(false);
                                  boolController.updateBoolLong(false);
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "Kapat",
                                style: TextStyle(color: Colors.red),
                              ))
                        ],
                      ),
                    ))
                : Container();
          }),

          Expanded(
            child: AnimationLimiter(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1.3,
                padding: EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                children: List.generate(son.length, (index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    columnCount: colonAdet,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: son[index],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}

class widgetTasarim extends StatefulWidget {
  const widgetTasarim({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.widgetBelgeSira,
    this.belgeTipi = "",
  }) : super(key: key);

  final String title;
  final IconData icon;
  final int color;
  final int widgetBelgeSira;
  final String? belgeTipi;

  @override
  _widgetTasarimState createState() => _widgetTasarimState();
}

class _widgetTasarimState extends State<widgetTasarim> {
  final BoolController boolController = Get.put(BoolController());

  bool isRemoved = false;
  // bool isLongPress = false;

  @override
  Widget build(BuildContext context) {
    if (isRemoved) {
      return Container();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * .45,
      child: Obx(() {
        if (boolController.isLong.value) {
          return GestureDetector(
            onTap: () async {
              setState(() {});
            },
            child: Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Color(widget.color),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          widget.icon,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                widget.title,
                                maxLines: 3,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () async {
                            print("dsf");
                            setState(() {
                              isRemoved = true;
                              //boolController.updateBoolLong(false);
                              listeler.sayfaDurum[widget.widgetBelgeSira] =
                                  false;
                            });
                            await SharedPrefsHelper.saveList(
                                listeler.sayfaDurum);
                          },
                          color: Color.fromARGB(255, 30, 38, 45)),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return GestureDetector(
              onLongPress: () {
                setState(() {
                  boolController.isLong.value = true;
                  boolController.ust.value = true;
                });
              },
              child: creatBadge(
                top: -5,
                end: -5,
                size: 14,
                belgeTipi: widget.belgeTipi!,
                child: Container(
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Color(widget.color),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              widget.icon,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                  width: 100,
                                  child: Text(
                                    widget.title,
                                    maxLines: 3,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        }
      }),
    );
  }
}
