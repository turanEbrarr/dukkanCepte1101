import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilatHaraket.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilat_pdf_onizleme.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';

import '../controllers/tahsilatController.dart';
import '../genel_belge.dart/genel_belge_tab_urun_toplam.dart';
import '../localDB/databaseHelper.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../tahsilatOdemeModel/tahsilat.dart';
import '../webservis/base.dart';
import '../widget/customAlertDialog.dart';
import '../widget/main_page.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';

class tahsilat_toplam extends StatefulWidget {
  const tahsilat_toplam({
    super.key,
  });

  @override
  State<tahsilat_toplam> createState() => _tahsilat_toplamState();
}

class _tahsilat_toplamState extends State<tahsilat_toplam> {
  IslemTipi? seciliFaturaTip;
  List<IslemTipi> islemTipiList = [
    IslemTipi(ADI: "Normal", ID: 0),
    IslemTipi(ADI: "Açık", ID: 1)
  ];
  BaseService bs = BaseService();
  double genelToplam = 0.0;
  String sonnnnn = "";
  List<String> textAciklama = [
    "Toplam Nakit",
    "Toplam Visa",
    "Toplam Çek",
    "Toplam Senet"
  ];
  final TahsilatController tahsilatEx = Get.find();
  List<bool> silmeAktifListe = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in tahsilatEx.tahsilat!.value.tahsilatHareket) {
      silmeAktifListe.add(false);
    }
   
    seciliFaturaTip = tahsilatEx.tahsilat!.value.ISLEMTIPI == null ||
            tahsilatEx.tahsilat!.value.ISLEMTIPI == ""
        ? islemTipiList.first
        : islemTipiList.firstWhere((element) =>
            element.ID == int.parse(tahsilatEx.tahsilat!.value.ISLEMTIPI!));
            tahsilatEx.tahsilat!.value.ISLEMTIPI =seciliFaturaTip!.ID.toString();
  }

  @override
  Widget build(BuildContext context) {
    String sonYazilacak;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 66, 82, 97),
          label: Text("Tahsilatı Kaydet"),
          icon: Icon(Icons.save),
          onPressed: () async {
            if (tahsilatEx.tahsilat!.value.tahsilatHareket.length != 0) {
              Tahsilat fiss = tahsilatEx.tahsilat!.value;
              if (Ctanim.kullanici!.ISLEMAKTARILSIN == "H") {
                Tahsilat fiss = tahsilatEx.tahsilat!.value;
                tahsilatEx.tahsilat!.value.DURUM = true;
                await Tahsilat.empty().tahsilatEkle(
                    tahsilat: tahsilatEx.tahsilat!.value,
                    belgeTipi: "Tahsilat");

                tahsilatEx.tahsilat!.value = Tahsilat.empty();
                showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        secondButtonText: "Tamam",
                        onSecondPress: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        pdfSimgesi: true,
                        align: TextAlign.center,
                        title: 'Kayıt Başarılı',
                        message:
                            'Tahsilat Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                        onPres: () async {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TahsilatPdfOnizleme(
                                      m: fiss,
                                      belgeTipi: "Tahsilat",
                                    )),
                          );
                        },
                        buttonText: 'Tahsilatı Gör',
                      );
                    });
              } else {
                tahsilatEx.tahsilat!.value.DURUM = true;
                tahsilatEx.tahsilat!.value.AKTARILDIMI = true;

                await Tahsilat.empty().tahsilatEkle(
                    tahsilat: tahsilatEx.tahsilat!.value,
                    belgeTipi: "Tahsilat");
                int tempID = tahsilatEx.tahsilat!.value.ID!;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LoadingSpinner(
                      color: Colors.black,
                      message:
                          "Online Aktarım Aktif. Tahsilat Merkeze Gönderiliyor..",
                    );
                  },
                );
                await tahsilatEx.listGidecekTekTahsilatGetir(
                    tahsilatID: tempID);

                Map<String, dynamic> jsonListesi =
                    tahsilatEx.list_gidecek_tahsilat[0].toJson2();

                setState(() {});
                SHataModel gelenHata = await bs.ekleTahsilat(
                    jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
                if (gelenHata.Hata == "true") {
                  tahsilatEx.tahsilat!.value.DURUM = false;
                  tahsilatEx.tahsilat!.value.AKTARILDIMI = false;
                  LogModel logModel = LogModel(
                    TABLOADI: "TBLTAHSILATSB",
                    FISID: tahsilatEx.list_gidecek_tahsilat[0].ID,
                    HATAACIKLAMA: gelenHata.HataMesaj,
                    UUID: tahsilatEx.list_gidecek_tahsilat[0].UUID,
                    CARIADI: tahsilatEx.list_gidecek_tahsilat[0].CARIADI,
                  );

                  await VeriIslemleri().logKayitEkle(logModel);
                  print("GÖNDERİM HATASI");
                  await Ctanim.showHataDialog(
                      context, gelenHata.HataMesaj.toString(),
                      ikinciGeriOlsunMu: true);
                } else {
                  tahsilatEx.tahsilat!.value = Tahsilat.empty();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          pdfSimgesi: true,
                          secondButtonText: "Geri",
                          onSecondPress: () {
                            Navigator.pop(context);
                          },
                          align: TextAlign.left,
                          title: 'Başarılı',
                          message:
                              'Tahsilat merkeze başarıyla gönderildi. PDF dosyasını görmek ister misiniz ?',
                          onPres: () async {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => TahsilatPdfOnizleme(
                                        m: fiss,
                                        belgeTipi: "Tahsilat",
                                      )),
                            );
                          },
                          buttonText: 'Pdf\'\i Gör',
                        );
                      });
                  setState(() {});
                  tahsilatEx.list_gidecek_tahsilat.clear();
                  print("ONLİNE AKRARIM AKTİF EDİLECEK");
                }
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      align: TextAlign.center,
                      title: 'Hata',
                      message: 'Tahsilatın Kalem Listesi Boş Olamaz',
                      onPres: () async {
                        Navigator.pop(context);

                        setState(() {});
                      },
                      buttonText: 'Geri',
                    );
                  });
            }
          }),
      body: Container(
        
        child: Column(
          children: [
            tahsilatEx.tahsilat!.value.tahsilatHareket.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Listeden işlem silmek için işlemin üzerine uzun basınız.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                : Container(),
                Padding(
                        padding:
                            const EdgeInsets.only(top: 20, bottom: 0, left: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "İşlem Tipi :",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
            Container(
              width: MediaQuery.of(context).size.width * .80,
              height: MediaQuery.of(context).size.height / 15,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<IslemTipi>(
                    value: seciliFaturaTip,
                    items: islemTipiList.map((IslemTipi banka) {
                      return DropdownMenuItem<IslemTipi>(
                        value: banka,
                        child: Text(
                          banka.ADI ?? "",
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (IslemTipi? selected) {
                      setState(() {
                        seciliFaturaTip = selected;
                      });
                      tahsilatEx.tahsilat!.value.ISLEMTIPI =
                          seciliFaturaTip!.ID.toString();
                    },
                  ),
                ),
                
              ),
            ),
      
            Expanded(
              child: ListView.builder(
                  itemCount: tahsilatEx.tahsilat!.value.tahsilatHareket.length,
                  itemBuilder: ((context, index) {
                    TahsilatHareket tahsilatHareket =
                        tahsilatEx.tahsilat!.value.tahsilatHareket[index];
                    String leadingText;
                    if (tahsilatEx
                            .tahsilat!.value.tahsilatHareket[index].DOVIZ ==
                        "USD") {
                      leadingText = "\$";
                    } else if (tahsilatEx
                            .tahsilat!.value.tahsilatHareket[index].DOVIZ ==
                        "EUR") {
                      leadingText = "€";
                    } else {
                      leadingText = "₺";
                    }
                    return Row(
                      children: [
                        SizedBox(
                          width: silmeAktifListe[index] == false
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width * .85,
                  
                          child: GestureDetector(
                            onLongPress: () {
                              silmeAktifListe[index] = true;
                              setState(() {});
                            },
                            onTap: () {
                              if (silmeAktifListe[index] == true) {
                                silmeAktifListe[index] = false;
                                setState(() {});
                              }
                            },
                            child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Text(
                                      leadingText,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    title: Text(Ctanim()
                                            .MapTahsilatOdemeTip[tahsilatEx
                                                .tahsilat!
                                                .value
                                                .tahsilatHareket[index]
                                                .TIP]
                                            .toString() +
                                        " Tahsilat :" +
                                        Ctanim.donusturMusteri(tahsilatEx
                                            .tahsilat!
                                            .value
                                            .tahsilatHareket[index]
                                            .TUTAR
                                            .toString()) +
                                        " " +
                                        tahsilatEx.tahsilat!.value
                                            .tahsilatHareket[index].DOVIZ!),
                                    subtitle: silmeAktifListe[index] == false
                                        ? Text(tahsilatEx
                                                .tahsilat!.value.CARIADI
                                                .toString() +
                                            " / " +
                                            tahsilatEx.tahsilat!.value
                                                .tahsilatHareket[index].TAKSIT
                                                .toString() +
                                            " Taksit")
                                        : Text(""),
                                  )),
                            ),
                          ),
                        ),
                        silmeAktifListe[index] == true
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .1,
                                child: Card(
                                  child: IconButton(
                                      onPressed: () async {
                                        tahsilatEx
                                            .tahsilat?.value.tahsilatHareket
                                            .removeWhere((item) {
                                          return item.TIP ==
                                                  tahsilatHareket.TIP! &&
                                              item.BELGENO ==
                                                  tahsilatHareket.BELGENO!;
                                        });
                                        /*
                                        await Tahsilat.empty().tahsilatHareketSil( tahsilatEx
                                            .tahsilat!.value.ID!);
                                            */
                                        

                                        setState(() {});
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Tahsilat silindi..',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          showCloseIcon: false,
                                          backgroundColor:
                                              Color.fromARGB(255, 30, 38, 45),
                                        );
                                        ScaffoldMessenger.of(
                                                context as BuildContext)
                                            .showSnackBar(snackBar);

                                        silmeAktifListe[index] = false;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      )),
                                ),
                              )
                            : Container()
                      ],
                    );
                  })),
            ),
            /*
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Toplam Tahsilat Tutarı : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Ctanim.donusturMusteri(genelToplam.toString()) + " ₺",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}
