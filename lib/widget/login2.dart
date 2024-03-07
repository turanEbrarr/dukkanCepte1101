import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import '../widget/main_page.dart';
import '../widget/settings_page.dart';
import '../widget/veriler/listeler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../webservis/base.dart';
import '../controllers/cariController.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../main.dart';
import 'ctanim.dart';
import 'modeller/sharedPreferences.dart';
import '../webservis/kurModel.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/kullaniciModel.dart';
import '../widget/customAlertDialog.dart';
import '../controllers/fisController.dart';
import '../controllers/depoController.dart';
import '../controllers/tahsilatController.dart';
import '../widget/modeller/logModel.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title, this.sifre = ''}) : super(key: key);

  final String title;
  final String sifre;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class iskontoFiyat {
  double? fiyat;
  double? isk;
  iskontoFiyat(this.fiyat, this.isk);
}

class _LoginPageState extends State<LoginPage> {
  static FisController fisEx = Get.find();
  static TahsilatController tahsilatEx = Get.find();
  static SayimController sayimEx = Get.find();
  iskontoFiyat ornek1 = iskontoFiyat(0, 0);
  var abc = 0;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  BaseService bs = BaseService();
  //String _passwordKey = '123';
  SharedPreferences? _prefs;
  bool _beniHatirla = false;
  bool dis_kullanim = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  VeriIslemleri veriislemi = VeriIslemleri();
  final cariEx = Get.put(CariController());
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool sirketKayitliMi = true;

  @override
  void initState() {
    super.initState();
    _getSavedPassword();
    KullaniciModel.getUser().then((value) {
      if (value == null) {
        // showAlertDialog2(context, "İlk Girişte Kullanıcı Kaydı zorunludur.");
      } else {
        Ctanim.kullanici = value;
        _userNameController.text = Ctanim.kullanici!.KOD!;
      }
    });
    // ctanim şirketi doldurur
  }

  static Future<double?> getirDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  Future<void> hataGoster(
      {String? mesaj, bool? mesajVarMi, bool ikinciGeriOlsunMu = true}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          align: TextAlign.left,
          title: "Hata",
          message: mesajVarMi == true
              ? "Kullanıcı Parametrelerini Kontrol Ediniz.\n" + mesaj.toString()
              : "Kullanıcı Parametrelerini Kontrol Ediniz",
          onPres: () {
            Navigator.pop(context);
            if (ikinciGeriOlsunMu == true) {
              Navigator.pop(context);
            }
          },
          buttonText: 'Geri',
        );
      },
    );
  }

/*
  Future<bool?> KDVDahilMiCek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? KDV = prefs.getBool('KDV');

    return KDV;
  }

  Future<void> KDVDahilMiKaydet(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('KDV', value);
  }
*/
  bool paremetreHatasiVarMi = false;
  Future<void> click() async {
    _formKey.currentState!.save();

    if (Ctanim.kullanici != null) {
      await SharedPrefsHelper.sirketGetir();
      if (Ctanim.sirket == null || Ctanim.sirket == "") {
        hataGoster(
            mesajVarMi: true,
            mesaj: "Şirket İsmi Kaydedilmemiş",
            ikinciGeriOlsunMu: false);
      } else {
        await SharedPrefsHelper.IpGetir();
        String bankaHata = "";
        String bankaSozlesmeHata = "";
        
        String islemTipiHata = "";
        if (_passwordController.text == Ctanim.kullanici?.SIFRE &&
            _userNameController.text == Ctanim.kullanici!.KOD) {
          int value = await SharedPrefsHelper.faturaNumarasiGetir();
          if (value != -1) {
            Ctanim.faturaNumarasi = value;
          } else {
            if (Ctanim.kullanici!.FATNO == "0" &&
                Ctanim.kullanici!.FATURASERISERINO != "") {
              paremetreHatasiVarMi = true;
              print("fatNO");
            } else {
              Ctanim.faturaNumarasi =
                  int.parse(Ctanim.kullanici!.FATNO.toString());
              SharedPrefsHelper.faturaNumarasiKaydet(
                  int.parse(Ctanim.kullanici!.FATNO.toString()));
            }
          }
          int value1 = await SharedPrefsHelper.siparisNumarasiGetir();
          if (value1 != -1) {
            Ctanim.siparisNumarasi = value1;
          } else {
            Ctanim.siparisNumarasi = 1;
            SharedPrefsHelper.siparisNumarasiKaydet(Ctanim.siparisNumarasi);
          }
          int value2 = await SharedPrefsHelper.irsaliyeNumarasiGetir();
          if (value2 != -1) {
            Ctanim.irsaliyeNumarasi = value2;
          } else {
            if (Ctanim.kullanici!.IRSNO == "0" &&
                Ctanim.kullanici!.IRSALIYESERISERINO != "") {
              paremetreHatasiVarMi = true;
              print("ırsNO");
            } else {
              Ctanim.irsaliyeNumarasi =
                  int.parse(Ctanim.kullanici!.IRSNO.toString());
              SharedPrefsHelper.irsaliyeNumarasiKaydet(
                  int.parse(Ctanim.kullanici!.IRSNO.toString()));
            }
          }
          int value3 = await SharedPrefsHelper.eirsaliyeNumarasiGetir();
          if (value3 != -1) {
            Ctanim.eirsaliyeNumarasi = value3;
          } else {
            if (Ctanim.kullanici!.EIRSNO == "0" &&
                Ctanim.kullanici!.EIRSALIYESERINO != "" &&
                Ctanim.kullanici!.EIRSALIYE == "E") {
              paremetreHatasiVarMi = true;
              print("EirsNO");
            } else {
              Ctanim.eirsaliyeNumarasi =
                  int.parse(Ctanim.kullanici!.EIRSNO.toString());
              SharedPrefsHelper.eirsaliyeNumarasiKaydet(
                  int.parse(Ctanim.kullanici!.EIRSNO.toString()));
            }
          }
          int value4 = await SharedPrefsHelper.perakendeSatisNumGetir();
          if (value4 != -1) {
            Ctanim.perakendeSatisNumarasi = value4;
          } else {
            Ctanim.perakendeSatisNumarasi = 1;
            SharedPrefsHelper.perakendeSatisNumKaydet(
                Ctanim.perakendeSatisNumarasi);
          }
          int value5 = await SharedPrefsHelper.depoTransferNumGetir();
          if (value5 != -1) {
            Ctanim.depolarArasiTransfer = value5;
          } else {
            Ctanim.depolarArasiTransfer = 1;
            SharedPrefsHelper.depoTransferNumKaydet(
                Ctanim.depolarArasiTransfer);
          }
          int value6 = await SharedPrefsHelper.efaturaNumarasiGetir();
          if (value6 != -1) {
            Ctanim.eFaturaNumarasi = value6;
          } else {
            if (Ctanim.kullanici!.EFATNO == "0" &&
                Ctanim.kullanici!.EFATURASERINO != "" &&
                Ctanim.kullanici!.EFATURA == "E") {
              paremetreHatasiVarMi = true;
              print("EfatNO");
            } else {
              Ctanim.eFaturaNumarasi =
                  int.parse(Ctanim.kullanici!.EFATNO.toString());
              SharedPrefsHelper.efaturaNumarasiKaydet(
                  int.parse(Ctanim.kullanici!.EFATNO.toString()));
            }
          }
          int value7 = await SharedPrefsHelper.eArsivNumarasiGetir();
          if (value7 != -1) {
            Ctanim.eArsivNumarasi = value7;
          } else {
            if (Ctanim.kullanici!.EARSIVNO == "0" &&
                Ctanim.kullanici!.EARSIVSERINO != "" &&
                Ctanim.kullanici!.EARSIV == "E") {
              paremetreHatasiVarMi = true;
              print("EarsivNO");
            } else {
              Ctanim.eArsivNumarasi =
                  int.parse(Ctanim.kullanici!.EARSIVNO.toString());
              SharedPrefsHelper.eArsivNumarasiKaydet(
                  int.parse(Ctanim.kullanici!.EARSIVNO.toString()));
            }
          }
          int value8 = await SharedPrefsHelper.acikFaturaNumarasiGetir();
          if (value8 != -1) {
            Ctanim.acikFaturaNumrasi = value8;
          } else {
            if (Ctanim.kullanici!.FATACIKNO == "0" &&
                Ctanim.kullanici!.FATURAACIKSERI_SERINO != ""
                ) {
              paremetreHatasiVarMi = true;
              print("acikFatura");
            } else {
              Ctanim.acikFaturaNumrasi =
                  int.parse(Ctanim.kullanici!.FATACIKNO.toString());
              SharedPrefsHelper.acikFaturaNumarasiKaydet(
                  int.parse(Ctanim.kullanici!.FATACIKNO.toString()));
            }
          }

          if (_beniHatirla == true) {
            _savePassword();
          }
          // hangi fiyat iskonyo vs görebilsin?
          Ctanim.satisFiyatListesi.clear();
          if (Ctanim.kullanici!.SFIYAT1 == "E") {
            Ctanim.satisFiyatListesi.add("Fiyat1");
          }
          if (Ctanim.kullanici!.SFIYAT2 == "E") {
            Ctanim.satisFiyatListesi.add("Fiyat2");
          }
          if (Ctanim.kullanici!.SFIYAT3 == "E") {
            Ctanim.satisFiyatListesi.add("Fiyat3");
          }
          if (Ctanim.kullanici!.SFIYAT4 == "E") {
            Ctanim.satisFiyatListesi.add("Fiyat4");
          }
          if (Ctanim.kullanici!.SFIYAT5 == "E") {
            Ctanim.satisFiyatListesi.add("Fiyat5");
          }

          if (Ctanim.kullanici!.GISK1 == "E") {
            Ctanim.genelIskontoListesi.add("GISK1");
          }
          if (Ctanim.kullanici!.GISK2 == "E") {
            Ctanim.genelIskontoListesi.add("GISK2");
          }
          //GISK2 den sonrası alınmadı.

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingSpinner(
                color: Colors.black,
                message:
                    "Dükkan Cepte \'ye Hoşgeldiniz Uygulama Sizin İçin Hazırlanıyor...",
              );
            },
          );
          await SharedPrefsHelper.yetkiCek("yetkiler");

          List<bool> retrievedList = [];
          await SharedPrefsHelper.getList().then((value) {
            retrievedList = value;

            if (retrievedList.length == 0) {
              listeler.sayfaDurum.clear();
              for (var element in listeler.plasiyerYetkileri) {
                listeler.sayfaDurum.add(element);
              }
            } else {
              for (int i = 0; i < retrievedList.length; i++) {
                if (listeler.plasiyerYetkileri[i] == false &&
                    retrievedList[i] == true) {
                  retrievedList[i] == false;
                }
              }
              listeler.sayfaDurum = retrievedList;
            }
          });
          await SharedPrefsHelper.saveList(listeler.sayfaDurum);
          veriislemi.veriGetir().then((value) async {
            if (value == 0) {              print("Veri Tabanı yok.");
              // kontrol

              const snackBar1 = SnackBar(
                content: Text(
                  'Yerel Hafızada Veri Kaydı Yok Veriler Ana Makineden Çekilecek',
                  style: TextStyle(fontSize: 16),
                ),
                showCloseIcon: true,
                backgroundColor: Color.fromARGB(255, 66, 82, 97),
                closeIconColor: Colors.white,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar1);

              if (await Connectivity().checkConnectivity() ==
                  ConnectivityResult.none) {
                print("İnternet bağlantısı yok.");
                const snackBar = SnackBar(
                  content: Text(
                    'İnternet bağlantısı yok. Webservisten veri çekilemedi.',
                    style: TextStyle(fontSize: 16),
                  ),
                  showCloseIcon: true,
                  backgroundColor: Colors.blue,
                  closeIconColor: Colors.white,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                String genelHata = "";
                List<String?> hatalar = [];
                
                hatalar.add(await stokKartEx.servisStokGetir());
                hatalar.add(await cariEx.servisCariGetir());
             
                if (hatalar.length > 0) {
                  for (var element in hatalar) {
                    if (element != "") {
                      genelHata = genelHata + "\n" + element!;
                    }
                  }
                }
                if (genelHata != "") {
                  if (paremetreHatasiVarMi == false) {
                    LogModel log = LogModel(
                      TABLOADI: "LOGİN İLK GİRİŞ",
                      HATAACIKLAMA: genelHata,
                    );
                    await VeriIslemleri().logKayitEkle(log);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false,
                    );
                  } else {
                    hataGoster(
                        mesajVarMi: true,
                        mesaj:
                            "Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n" +
                                genelHata);
                  }
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false,
                  );
                }
              }
            } else {
              if (Ctanim.kullanici!.ONLINE == "H") {
                if (paremetreHatasiVarMi == true) {
                  hataGoster();
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false,
                  );
                }
              } else {
                showAlertDialogLogin(context, "Kullanıcının Ofline Giriş İzni Yok");
              }
            }
          });

          // Şifre doğru, giriş yapılıyor
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 40,
                          // color: Colors.red,
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.cancel))),
                      const Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Text("Şifre Hatalı. ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                      Text("Lütfen tekrar deneyin.")
                    ],
                  ),
                );
              });
        }
      }
    } else {
      showAlertDialogLogin1(context, "Kullanıcı Tanımı Yapılamış.");
    }
  }

  static Future<void> kaydetDouble(double value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _getSavedPassword() async {
    _prefs = await SharedPreferences.getInstance();
    final password = _prefs!.getString("sifre");
    if (password != null) {
      setState(() {
        _passwordController.text = password;
        _beniHatirla = true;
      });
    }
  }

  Future<void> _savePassword() async {
    if (_beniHatirla) {
      await _prefs!.setString("sifre", _passwordController.text);
    } else {
      await _prefs!.remove("sifre");
    }
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    double ekranYuksekligi = ekranBilgisi.size.height;
    double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => settings_page()),
          ),
          backgroundColor: Color.fromRGBO(181, 182, 184, 1),
          mini: true,
          child: const Icon(Icons.settings, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/sj.jpg"), fit: BoxFit.cover)),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: ekranYuksekligi / 2.2,
                          width: ekranGenisligi /1,
                          child: Image.asset('images/dk1.png')),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Container(
                          height: ekranYuksekligi / 2.1,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.5), // Şeffaf arka plan rengi
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                          ),
                          margin:
                              EdgeInsets.only(bottom: 0.0), // Kenar yuvarlatma

                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                          0.9), // Color.fromRGBO(181, 182, 184, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _userNameController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            //controller: _passwordController,
                                            // obscureText: !_isPasswordVisible,
                                            //focusNode: _passwordFocusNode,
                                            cursorColor:
                                                Color.fromARGB(255, 60, 59, 59),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value == "") {
                                                return "Bu Alan Boş Bırakılamaz";
                                              }
                                            },
                                            onSaved: (value) {},
                                            decoration: InputDecoration(
                                              labelText: "Kullanıcı Kodu",
                                              labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 60, 59, 59),
                                                fontSize: 15,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(
                                          0.9), // Color.fromRGBO(181, 182, 184, 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.lock,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textAlignVertical:
                                                TextAlignVertical.bottom,
                                            controller: _passwordController,
                                            obscureText: !_isPasswordVisible,
                                            //focusNode: _passwordFocusNode,
                                            cursorColor:
                                                Color.fromARGB(255, 60, 59, 59),
                                            onChanged: (value) {
                                              final currentPosition =
                                                  _passwordController.selection;
                                              _passwordController.text = value;
                                              _passwordController.selection =
                                                  currentPosition;
                                            },
                                            validator: (value) {
                                              if (value == "") {
                                                return "Bu Alan Boş Bırakılamaz";
                                              }
                                            },
                                            onSaved: (value) {},
                                            decoration: InputDecoration(
                                              labelText: "Parola",
                                              labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 60, 59, 59),
                                                fontSize: 15,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                          child: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      /*
                                      SizedBox(
                                        width: ekranGenisligi * .5,
                                        child: CheckboxListTile(
                                          activeColor:
                                              Color.fromRGBO(81, 82, 83, 1),

                                          title: const Text(
                                              "Dışarıda Kullanılacak",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                          //style: TextStyle(
                                          // color: Colors.white,)
                                          side: BorderSide(color: Colors.black),
                                          value: dis_kullanim,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (bool? veri) {
                                            print(
                                                "Dışarıdan kullanılabilir : $veri");
                                            setState(() {
                                              dis_kullanim = veri!;
                                            });
                                          },
                                        ),
                                      ),
                                      */
                                      SizedBox(
                                        width: ekranGenisligi * .5,
                                        child: CheckboxListTile(
                                          activeColor:
                                              Color.fromRGBO(81, 82, 83, 1),
                                          side: BorderSide(color: Colors.black),
                                          //child: Text(,
                                          title: Text("Şifremi Hatırla",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              )),
                                          value: _beniHatirla,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _beniHatirla = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(ekranYuksekligi / 80),
                                  child: SizedBox(
                                    width: ekranGenisligi / 1.5,
                                    height: ekranYuksekligi / 12,
                                    child: ElevatedButton(
                                        child: Text(
                                          "Giriş Yap",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Color.fromRGBO(
                                                192, 192, 192, 1),
                                            shadowColor: Colors.black,
                                            elevation: 20,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            )),
                                        onPressed: ()  {
                                          if (_formKey.currentState != null &&
                                              _formKey.currentState!
                                                  .validate()) {
                                                  
                                            click();
                                          }
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /*                  Padding(
                        padding: EdgeInsets.all(ekranYuksekligi / 30),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: _passwordController,
                          obscureText: true,
                          focusNode: _passwordFocusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Parola giriniz';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Parola giriniz',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            errorStyle: TextStyle(fontSize: 16.0),
                          ),
                          onSaved: (value) {
                            _passwordKey != value;
                            if (value != null) {
                              _passwordKey = value.toString();
                            }
                          },
                        ),
                      ),
                      */
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showAlertDialogLogin(BuildContext context, String mesaj) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
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

showAlertDialogLogin1(BuildContext context, String mesaj) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => settings_page()),
      );
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

showAlertDialogLogin2(BuildContext context, String mesaj) {
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
