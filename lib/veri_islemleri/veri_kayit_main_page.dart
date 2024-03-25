import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dukkan_cepte/faturaFis/fis.dart';
import 'package:dukkan_cepte/stok_kart/Spinkit.dart';
import 'package:dukkan_cepte/tahsilatOdemeModel/tahsilat.dart';
import 'package:dukkan_cepte/veri_islemleri/veri_kayit_tile.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/modeller/sHataModel.dart';
import '../Depo Transfer/depo.dart';
import '../controllers/depoController.dart';
import '../controllers/fisController.dart';
import '../controllers/tahsilatController.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import 'dart:convert';
import '../webservis/base.dart';

class veri_kayit_main_page extends StatefulWidget {
  const veri_kayit_main_page({super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;

  @override
  State<veri_kayit_main_page> createState() => _veri_kayit_main_pageState();
}

class _veri_kayit_main_pageState extends State<veri_kayit_main_page> {
  TextEditingController t1 = new TextEditingController();
  BaseService bs = BaseService();

  var json;
  static FisController fisEx = Get.find();
  SayimController sayimEx = Get.find();
  static TahsilatController tahsilatEx = Get.find();
  List baslik = [
    ["Alınan Sipariş", false, "Alinan_Siparis"],
    ["Müşteri Sipariş", false, "Musteri_Siparis"],
    ["Tahsilat", false, "Tahsilat"],
    ["Ödeme", false, "Odeme"],
    ["Cari Virman", false, "Virman"],
    ["Satış Fatura", false, "Satis_Fatura"],
    ["Satış İrsaliye", false, "Satis_Irsaliye"],

    ["Alış Fatura",false,"Alis_Fatura"],
    ["Alış Fatura İadeleri",false,"Alis_Fatura_Iade"],

    ["Alış İrsaliye", false, "Alis_Irsaliye"],
    ["Perakende Satış Fişi", false, "Perakende_Satis"],
    ["Depo Transfer", false, "Depo_Transfer"],
    ["Stok Resim Kayıt", false, "StokResim"],
    ["Sayımları Aktar", false, "Sayim"],
    
  
  ];
  TextEditingController dataDenemeler = new TextEditingController();
  void postDataToWebsite(List<Map<String, dynamic>> jsonDataList) async {
    var url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts'); // JSON verisini göndermek istediğiniz endpoint URL'si

    // JSON listesini dizeye dönüştürme
    for (var element in jsonDataList) {
      var jsonString = jsonEncode(element);
      // t1.text += jsonString;

      // POST isteği oluşturma
      var response = await http.post(url, body: jsonString, headers: {
        'Content-Type':
            'application/json', // İstek başlığında JSON verisi olduğunu belirtmek için Content-Type ayarı
      });

      if (response.statusCode == 201) {
        // İstek başarılı ise
        print('Veri başarıyla gönderildi.');
        print('Yanıt: ${response.body}');
      } else {
        // İstek başarısız ise
        print(
            'Veri gönderimi başarısız oldu. Hata kodu: ${response.statusCode}');
      }
    }
  }

  Future<void> veriGonder() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingSpinner(
          message: "İşlem Tamamlanıyor",
          color: Colors.green,
        );
      },
    );

    int i = 0;
    bool hicTrueGeldiMi = false;
    while (i < baslik.length) {
      if (baslik[i][1] == true && baslik[i][2] == "Sayim") {
        hicTrueGeldiMi = true;
        String hataTopla = "";
        await sayimEx.listGidecekDepoGetir();

        print(baslik[i][0] +
            " içeren fis sayısı: " +
            sayimEx.list_gidecek_Depo.length.toString());
        if (sayimEx.list_gidecek_Depo.length > 0) {
          print(baslik[i][0] + " için gönderme işlemi yapılacak.");
          for (int j = 0; j < sayimEx.list_gidecek_Depo.length; j++) {
            Map<String, dynamic> jsonListesi =
                sayimEx.list_gidecek_Depo[j].toJson2();
            sayimEx.list_gidecek_Depo[j].AKTARILDIMI = true;
            await Sayim.empty().sayimEkle(
              sayim: sayimEx.list_gidecek_Depo[j],
            );
            setState(() {});
            SHataModel gelenHata = await bs.ekleSayim(
                jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
            if (gelenHata.Hata == "true") {
              sayimEx.list_gidecek_Depo[j].AKTARILDIMI = false;
              Sayim.empty().sayimEkle(sayim: sayimEx.list_gidecek_Depo[j]);
              hataTopla = hataTopla +
                  "\n" +
                  baslik[i][0] +
                  " Belge Tipine ait " +
                  sayimEx.list_gidecek_Depo[j].SUBEID.toString() +
                  " şubesi " +
                  sayimEx.list_gidecek_Depo[j].DEPOID.toString() +
                  " deposunda"
                      " yapılan sayım işlemi gönderilemedi.\n Hata Mesajı :" +
                  gelenHata.HataMesaj!;
              LogModel logModel = LogModel(
                TABLOADI: "TBLSAYIMSB",
                FISID: sayimEx.list_gidecek_Depo[0].ID,
                HATAACIKLAMA: gelenHata.HataMesaj,
                UUID: sayimEx.list_gidecek_Depo[0].UUID,
                CARIADI: sayimEx.list_gidecek_Depo[0].TARIH,
              );
              await VeriIslemleri().logKayitEkle(logModel);
            }
          }
          if (hataTopla != "") {
            await showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.left,
                    title: 'Hata',
                    message:
                        'Veri Gönderilierken Bazı Hatalar İle Karşılaşıldı:\n' +
                            hataTopla,
                    onPres: () async {
                      Navigator.pop(context);
                    },
                    buttonText: 'Tamam',
                  );
                });
          } else {
            const snackBar1 = SnackBar(
              content: Text(
                'Veriler Başarılı Bir Şekilde Gönderildi',
                style: TextStyle(fontSize: 16),
              ),
              showCloseIcon: true,
              backgroundColor: Colors.blue,
              closeIconColor: Colors.white,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar1);
          }
          sayimEx.list_gidecek_Depo.clear();

          print("Liste Temizlendi : " +
              sayimEx.list_gidecek_Depo.length.toString());
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  align: TextAlign.left,
                  title: 'Boş Liste',
                  message: '${baslik[i][0]} için gönderilecek Veri Yok',
                  onPres: () async {
                    Navigator.pop(context);
                  },
                  buttonText: 'Tamam',
                );
              });
        }
        sayimEx.list_gidecek_Depo.clear();
        print("Liste Temizlendi : " +
            sayimEx.list_gidecek_Depo.length.toString());
      } else if (baslik[i][1] == true &&
          (baslik[i][2] == "Tahsilat" || baslik[i][2] == "Odeme")) {
        hicTrueGeldiMi = true;
        String hataTopla = "";

        await tahsilatEx.listGidecekTahsilatGetir(belgeTip: baslik[i][2]);

        print(baslik[i][0] +
            " içeren tahsilat sayısı: " +
            tahsilatEx.list_gidecek_tahsilat.length.toString());
        if (tahsilatEx.list_gidecek_tahsilat.length > 0) {
          print(baslik[i][0] + " için gönderme işlemi yapılacak.");
          for (int j = 0; j < tahsilatEx.list_gidecek_tahsilat.length; j++) {
            Map<String, dynamic> jsonListesi =
                tahsilatEx.list_gidecek_tahsilat[j].toJson2();
            tahsilatEx.list_gidecek_tahsilat[j].AKTARILDIMI = true;
            await Tahsilat.empty().tahsilatEkle(
                tahsilat: tahsilatEx.list_gidecek_tahsilat[j],
                belgeTipi: baslik[i][2]);

            SHataModel gelenHata = await bs.ekleTahsilat(
                jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
            if (gelenHata.Hata == "true") {
              tahsilatEx.list_gidecek_tahsilat[j].AKTARILDIMI = false;
              await Tahsilat.empty().tahsilatEkle(
                  tahsilat: tahsilatEx.list_gidecek_tahsilat[j],
                  belgeTipi: baslik[i][2]);
              hataTopla = hataTopla +
                  "\n" +
                  baslik[i][0] +
                  " Belge Tipine ait " +
                  tahsilatEx.list_gidecek_tahsilat[j].CARIADI.toString() +
                  " carisi adına kesilen " +
                  baslik[i][0].toString().toLowerCase() +
                  " işlemi gönderilemedi.\n Hata Mesajı :" +
                  gelenHata.HataMesaj!;
              LogModel logModel = LogModel(
                TABLOADI: "TBLTAHSILATSB",
                FISID: tahsilatEx.list_gidecek_tahsilat[0].ID,
                HATAACIKLAMA: gelenHata.HataMesaj,
                UUID: tahsilatEx.list_gidecek_tahsilat[0].UUID,
                CARIADI: tahsilatEx.list_gidecek_tahsilat[0].CARIADI,
              );
              await VeriIslemleri().logKayitEkle(logModel);
            }
          }
          if (hataTopla != "") {
            await showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.left,
                    title: 'Hata',
                    message:
                        'Veri Gönderilierken Bazı Hatalar İle Karşılaşıldı:\n' +
                            hataTopla,
                    onPres: () async {
                      Navigator.pop(context);
                    },
                    buttonText: 'Tamam',
                  );
                });
          } else {
            const snackBar1 = SnackBar(
              content: Text(
                'Tahsilat Verileri Başarılı Bir Şekilde Gönderildi',
                style: TextStyle(fontSize: 16),
              ),
              showCloseIcon: true,
              backgroundColor: Colors.blue,
              closeIconColor: Colors.white,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar1);
          }

          tahsilatEx.list_gidecek_tahsilat.clear();

          print(
              "Liste Temizlendi : " + fisEx.list_fis_gidecek.length.toString());
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  align: TextAlign.left,
                  title: 'Boş Liste',
                  message: '${baslik[i][0]} için gönderilecek Veri Yok',
                  onPres: () async {
                    Navigator.pop(context);
                  },
                  buttonText: 'Tamam',
                );
              });
        }

        print("Liste Temizlendi : " +
            tahsilatEx.list_gidecek_tahsilat.length.toString());
      } else if (baslik[i][1] == true) {
        hicTrueGeldiMi = true;
        String hataTopla = "";
        
        await fisEx.listGidecekFisGetir(belgeTip: baslik[i][2]);

        print(baslik[i][0] +
            " içeren fis sayısı: " +
            fisEx.list_fis_gidecek.length.toString());
        if (fisEx.list_fis_gidecek.length > 0) {
          print(baslik[i][0] + " için gönderme işlemi yapılacak.");
          for (int j = 0; j < fisEx.list_fis_gidecek.length; j++) {

          bool zorunluKontrol = Fis.zorunluEkParametrelerDoluMu(fisEx.list_fis_gidecek[j].listFisEkParam);
          if(zorunluKontrol == true){
           Map<String, dynamic> jsonListesi =
            fisEx.list_fis_gidecek[j].toJson2();
            fisEx.list_fis_gidecek[j].AKTARILDIMI = true;
            Fis.empty().fisEkle(
                belgeTipi: baslik[i][2], fis: fisEx.list_fis_gidecek[j]);

            SHataModel gelenHata = await bs.ekleFatura(
                jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
            if (gelenHata.Hata == "true") {
              fisEx.list_fis_gidecek[j].AKTARILDIMI = false;
              Fis.empty().fisEkle(
                  belgeTipi: baslik[i][2], fis: fisEx.list_fis_gidecek[j]);
              hataTopla = hataTopla +
                  "\n" +
                  baslik[i][0] +
                  " Belge Tipine ait " +
                  fisEx.list_fis_gidecek[j].BELGENO.toString() +
                  " fatura numaralı belge gönderilemedi.\n Hata Mesajı :" +
                  gelenHata.HataMesaj!;

              LogModel logModel = LogModel(
                TABLOADI: "TBLFISSB",
                FISID: fisEx.list_fis_gidecek[0].ID,
                HATAACIKLAMA: gelenHata.HataMesaj,
                UUID: fisEx.list_fis_gidecek[0].UUID,
                CARIADI: fisEx.list_fis_gidecek[0].CARIADI,
              );
              await VeriIslemleri().logKayitEkle(logModel);
            }

          }else{
            hataTopla = hataTopla +
                  "\n" +
                  baslik[i][0] +
                  " Belge Tipine ait " +
                  fisEx.list_fis_gidecek[j].BELGENO.toString() +
                  " fatura numaralı belge gönderilemedi.\n Hata Mesajı : Zorunlu Ek Parametreler Boş";
          }

          }
          if (hataTopla != "") {
            await showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.left,
                    title: 'Hata',
                    message:
                        'Web Servise Veri Gönderilirken Bazı Hatalar İle Karşılaşıldı:\n' +
                            hataTopla,
                    onPres: () async {
                      Navigator.pop(context);
                    },
                    buttonText: 'Tamam',
                  );
                });
          } else {
            const snackBar1 = SnackBar(
              content: Text(
                'Veriler Başarılı Bir Şekilde Gönderildi',
                style: TextStyle(fontSize: 16),
              ),
              showCloseIcon: true,
              backgroundColor: Colors.blue,
              closeIconColor: Colors.white,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar1);
          }

          fisEx.list_fis_gidecek.clear();

          print(
              "Liste Temizlendi : " + fisEx.list_fis_gidecek.length.toString());
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  align: TextAlign.left,
                  title: 'Boş Liste',
                  message: '${baslik[i][0]} için gönderilecek Veri Yok',
                  onPres: () async {
                    Navigator.pop(context);
                  },
                  buttonText: 'Tamam',
                );
              });
        }
      } else {}

      //   String jsonFisListesi1 = jsonEncode(jsonListesi);
      //     postDataToWebsite(jsonFisListesi1);

      i++; // i değerini artır
      continue; // Döngünün başına dön
    }
    if (hicTrueGeldiMi == false) {
      await showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              align: TextAlign.left,
              title: 'Veri Seçilmemiş',
              message: 'Gönderilecek Veri Yok',
              onPres: () async {
                Navigator.pop(context);
              },
              buttonText: 'Tamam',
            );
          });
    }
    Navigator.pop(context);
  }

  void gonder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingSpinner(
          message: "İşlem Tamamlanıyor",
          color: Colors.green,
        );
      },
    );

    veriGonder();
    //burda akratımları true yap!!!!!!!!!!
    Navigator.of(context).pop();
  }

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
      appBar: MyAppBar(height: 50, title: "Veri Kayıt"),
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
                Icons.send,
                color: Colors.green,
                size: 32,
              ),
              label: "Seçili Verileri Gönder",
              onTap: () {
                veriGonder();
              })
        ],
      ),
      /*
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          gonder();
        },
        label: Text("Seçili Verileri Gönder"),
        icon: Icon(Icons.send),
      ),
      */
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: baslik.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Checkbox(
                            onChanged: (value) {
                              setState(() {
                                baslik[index][1] = value;
                              });
                            },
                            value: baslik[index][1],
                          ),
                          title: Text(baslik[index][0]),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  );
                }),
          ), /*
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue[100],
              ),
              child: GestureDetector(
                onTap: (() {}),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Cari Kayıtları Al"),
                    )
                  ],
                ),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}

showAlertDialog1(BuildContext context, String mesaj) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hatalı İşlem!"),
    content: Text(mesaj),
    actions: [
      okButton,
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
