import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dukkan_cepte/cari_kart/genel_cari_rapor.dart';

import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import '../cari_kart/yeni_cari_olustur.dart';
import '../fatura_raporlari/fatura_raporlari_main_page.dart';

import '../stok_kart/Spinkit.dart';
import '../widget/cari.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';

class cari_cari_rapor extends StatefulWidget {
  final Cari cariKart;
  const cari_cari_rapor({super.key, required this.cariKart});

  @override
  State<cari_cari_rapor> createState() => _cari_cari_raporState();
}

class _cari_cari_raporState extends State<cari_cari_rapor> {
  Future<void> hataGoster(List<List<dynamic>> donen) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          align: TextAlign.left,
          title:
              donen[0][0] == "Veri Bulunamadı" ? "Kayıtlı Belge Yok" : 'Hata',
          message: donen[0][0] == "Veri Bulunamadı"
              ? 'İstenilen Belge Mevcut Değil'
              : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                  donen[0][0],
          onPres: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          buttonText: 'Geri',
        );
      },
    );
  }

  BaseService bs = BaseService();
  @override
  Widget build(BuildContext context) {
    final List rapor = [
      "Cari Hesap Ektresi",

      //"Stoklu Cari Hesap Ekstresi",

      //"Bekleyen Siparişler",
      "Faturalar",

      //"Yapılacak Tahsilatlar",
      //  "Yapılacak Ödemeler",
   
      // "En Çok Tercih Edilen Ürünler(Satış)",
      //"En Çok Tercih Edilen Ürünler(Alış)"
    ];

    return Center(
        child: ListView.builder(
            itemCount: rapor.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        child: ListTile(
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/veri.png'),
                          ),
                          title: Text(
                            ' ${rapor[index]}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            List<List<dynamic>> donen = [];
                            if (rapor[index] == "Cari Hesap Ektresi") {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return LoadingSpinner(
                                    color: Colors.black,
                                    message:
                                        "Cari Ekstre Raporu Hazırlanıyor...",
                                  );
                                },
                              );
                              List<bool> cek =
                                  await SharedPrefsHelper.filtreCek(
                                      "cariEkstreRapor");
                              donen = await bs.getirCariEkstre(
                                  sirket: Ctanim.sirket!,
                                  cariKodu: widget.cariKart.KOD!);
                              if (donen[0].length == 1 &&
                                  donen[1].length == 0) {
                                hataGoster(donen);
                              } else {
                                // gelenlerden colon kaldırıldıysa veya eklendiyse favorileri temizle
                                if (donen[1].length != cek.length) {
                                  cek.clear();
                                  for (var i = 0; i < donen[1].length; i++) {
                                    cek.add(true);
                                  }
                                }
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => genel_cari_rapor(
                                            gelenBakiyeRapor: donen,
                                            gelenFiltre: cek,
                                            cariKart: widget.cariKart,
                                            raporAdi: 'Cari Hesap Ektresi',
                                          )),
                                );
                              }
                            }  else if (rapor[index] == "Siparişler") {
                             
                            } else if (rapor[index] == "Faturalar") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          fatura_raporlari_main_page(
                                            widgetListBelgeSira: 19,
                                            cariGonderildiMi: true,
                                            cariKart: widget.cariKart,
                                          ))));
                            } else if (rapor[index] == "İrsaliyeler") {
                            
                            } 
                          },
                        ),
                      )),
                  Divider(
                    thickness: 2,
                  )
                ],
              );
            })));
  }
}
