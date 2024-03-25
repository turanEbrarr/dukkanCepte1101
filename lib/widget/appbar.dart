import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../webservis/base.dart';
import '../widget/hesap_makinesi.dart';
import '../widget/main_page.dart';
import '../widget/veriler/listeler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../webservis/kurModel.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/kullaniciModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../widget/ctanim.dart';
import '../tahsilat/deneme3.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  //const MyAppBar({super.key});
  final double height;
  final String title;
  Future<bool?> KDVDahilMiCek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? KDV = prefs.getBool('KDV');
    return KDV;
  }

  const MyAppBar({
    required this.height,
    required this.title,
  });
  // Double değerini SharedPreferences'e kaydetmek için metot
  static Future<void> kaydetDouble(double value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  // Kaydedilmiş Double değerini SharedPreferences'den çekmek için metot
  static Future<double?> getirDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  void getirKurVeKaydet(BuildContext context) async {
    BaseService bs = BaseService();
    bool hasInternet = await checkInternetConnectivity();
    if (!hasInternet) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('İnternet Bağlantısı Yok'),
            content: Text(
                'İnternet bağlantısı olmadığından kur verileri alınamadı. Kaydedilen Son Veriler Kullanılacak.'),
            actions: <Widget>[
              TextButton(
                child: Text('Tamam'),
                onPressed: () async {
                  await VeriIslemleri().kurGetir();

                  print(listeler.listKur.length);

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingSpinner(
            color: Colors.red,
            message: "Kur Verileri Alınıyor",
          );
        },
      );
      listeler.listKur.clear();
      await bs.getirKur();

      Navigator.of(context).pop();

      // Kur verilerini kullan
      if (listeler.listKur.isNotEmpty) {
        print("gelen");
        print(listeler.listKur[0].KUR!);
        print(listeler.listKur[1].KUR!);
        print(listeler.listKur[2].KUR!);

        // Değerleri kaydetmek için:
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text('Kur verileri alınamadı.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        /*
        leading: Ctanim.bekleyenBelgeVarMi == true
            ? creatBadge(
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                belgeTipi: "genel",
                top: 10,
                end: 15,
                size: 1)
            : IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              */
        title: Text(title),
        backgroundColor: Color.fromARGB(255, 30, 38, 45),
        actions: [
          Container(
            color: Color.fromARGB(255, 30, 38, 45),
            padding: EdgeInsets.all(5),
            child: Row(children: [
              IconButton(
                onPressed: () {
                  KDVDahilMiCek().then((value) {
                    print("abc" + value.toString());
                  });
                  showDialog(
                      context: context,
                      builder: (_) {
                        return const HesapMakinesi();
                      });
                },
                icon: const Icon(
                  Icons.calculate,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  getirKurVeKaydet(context);
                  // print(listeler.listCari);
                },
                icon: const Icon(
                  Icons.currency_lira_outlined,
                  color: Colors.white,
                ),
              ),
              // icon: Icon(Icons.home)),
            ]),
          )
        ]);
  }
}
