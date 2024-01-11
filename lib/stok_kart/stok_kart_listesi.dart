import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dukkan_cepte/controllers/stokKartController.dart';
import 'package:dukkan_cepte/localDB/veritabaniIslemleri.dart';
import 'package:dukkan_cepte/stok_kart/resim.dart';
import 'package:dukkan_cepte/stok_kart/stok_kart_detay_guncel.dart';
import 'package:dukkan_cepte/stok_kart/stok_kart_ekle.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/customAlertDialog.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';
import 'package:dukkan_cepte/stok_kart/stok_tanim.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/veriler/listeler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../localDB/databaseHelper.dart';
import '../widget/modeller/sharedPreferences.dart';
import 'Spinkit.dart';

enum SampleItem1 { itemOne, itemTwo, itemThere, itemFour, itemFife, itemSix }

enum SampleItem { itemOne, itemTwo, itemThere }

class stok_kart_listesi extends StatefulWidget {
  stok_kart_listesi({super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;

  @override
  State<stok_kart_listesi> createState() => _stok_kart_listesiState();
}

class _stok_kart_listesiState extends State<stok_kart_listesi> {
  Future<void> _showImageDialog(BuildContext context, Uint8List bytes) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.memory(bytes),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Kapat'),
            ),
            TextButton(
              onPressed: () {
                _showFullscreenImage(bytes);
              },
              child: Text('Tam Ekran Göster'),
            ),
          ],
        );
      },
    );
  }

  Widget _showFullscreenImage(Uint8List bytes) {
    return new Scaffold(
      body: new Image.memory(
        bytes,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }

  Color favIconColor = Colors.black;
  String _barcodeResults = '';
  late String alinanString;
  TextEditingController aramaCont = TextEditingController();

  bool isLoading = false;

  String newToOld = "Yeniden Eskiye";
  String aToZ = "A-Z İsme Göre";
  String zToA = "Z-A İsme Göre";
  String oldToNew = "Eskiden Yeniye";
  BaseService bs = BaseService();
  TextEditingController editingController = TextEditingController();
  TextStyle blackBold =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);
  TextStyle black = TextStyle(color: Colors.black, fontSize: 16);
  // List<StokKart> stokSearchList = StokKart.liststok_kartSabit;
  bool order = false;
  List<StokKart> tempTempStok = [];
  File? image;
  final StokKartController stokKartEx = Get.find();
  String result = '';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermananetly(image.path);
      setState(() {
        this.image = imagePermanent;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text("Failed to pick image"),
      );
    }
  }

  Future<File> saveImagePermananetly(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Future pickImageCam(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text("Failed to pick image"),
      );
    }
  }

  void zToASort() {
    Comparator<StokKart> sirala2 =
        (a, b) => b.ADI!.toLowerCase().compareTo(a.ADI!.toLowerCase());
    listeler.liststok.sort(sirala2);
  }

  List<String> markalar = [];
  @override
  void initState() {
    if (stokKartEx.searchList.length > 100) {
      for (int i = 0; i < 100; i++) {
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    } else {
      stokKartEx.tempList.addAll(stokKartEx.searchList);
    }
    tempTempStok.addAll(stokKartEx.tempList);
    for (var element in stokKartEx.searchList) {
      if (!markalar.contains(element.MARKA) && element.MARKA != "") {
        markalar.add(element.MARKA!);
        Ctanim.seciliMarkalarFiltreMap.add({false: element.MARKA!});
      }
    }
  }

  Future<void> hataGoster(
      {String? mesaj,
      bool? mesajVarMi,
      bool ikinciGeriOlsunMu = true,
      BuildContext? context1}) async {
    await showDialog(
      context: context1!,
      builder: (context) {
        return CustomAlertDialog(
          align: TextAlign.left,
          title: "Hata",
          message: "Stok için resim bulunamadı.",
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Ctanim.secililiMarkalarFiltre.clear();
    Ctanim.seciliMarkalarFiltreMap.clear();
   stokKartEx.searchB("");
  }

  SampleItem? selectedMenu;
  SampleItem1? selectedMenu1;
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
        appBar: MyAppBar(
          height: 50,
          title: "Stok Kart Listesi",
        ),
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
                  Icons.refresh,
                  color: Colors.green,
                  size: 32,
                ),
                label: "Stokları Güncelle (" +
                    stokKartEx.searchList.length.toStringAsFixed(2) +
                    ")",
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return LoadingSpinner(
                        color: Colors.black,
                        message:
                            "Stoklar güncelleniyor. Bu işlem biraz zaman alabilir...",
                      );
                    },
                  );
                  await stokKartEx.servisStokGetir();
                  Ctanim.secililiMarkalarFiltre.clear();
                  Ctanim.seciliMarkalarFiltreMap.clear();
                  markalar.clear();
                  for (var element in stokKartEx.searchList) {
                    if (!markalar.contains(element.MARKA) &&
                        element.MARKA != "") {
                      markalar.add(element.MARKA!);
                      Ctanim.seciliMarkalarFiltreMap
                          .add({false: element.MARKA!});
                    }
                  }
                  Navigator.pop(context);

                  setState(() {});
                  //stokKartEx.servisStokGetir();  //servisten stokları çekip günceller
                }),
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 32,
                ),
                label: "Yeni Stok Ekle",
                onTap: () async {
                  Get.to(stok_kart_olustur());
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      onChanged: ((value) {
                       
                        stokKartEx.searchB(result);
                        // setState(() {});
                      }),
                      controller: editingController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Aranacak kelime (İsim/Kod/Marka)",
                          hintStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .1,
                  child: IconButton(
                      onPressed: () async {
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                            ));
                        setState(() {
                          if (res is String) {
                            result = res;
                            editingController.text = result;
                          }
                          
                        stokKartEx.searchB(result);
                        });
                      },
                      icon: Icon(Icons.camera_alt)
                      //    height: 60, width: 60),
                      ),
                ),
                PopupMenuButton<SampleItem1>(
                  icon: Icon(Icons.filter_list),
                  onOpened: () {},
                  initialValue: selectedMenu1,
                  // Callback that sets the selected popup menu item.
                  onSelected: (SampleItem1 item) {
                    setState(() {
                      selectedMenu1 = item;
                    });
                  },

                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SampleItem1>>[
                    PopupMenuItem<SampleItem1>(
                      value: SampleItem1.itemOne,
                      onTap: () {
                        stokKartEx.tempList
                            .sort((a, b) => b.BAKIYE!.compareTo(a.BAKIYE!));
                        setState(() {});
                      },
                      child: Text('Bakiye Azalan'),
                    ),
                    PopupMenuItem<SampleItem1>(
                      value: SampleItem1.itemTwo,
                      child: Text('Bakiye Artan'),
                      onTap: () {
                        stokKartEx.tempList
                          ..sort((a, b) => a.BAKIYE!.compareTo(b.BAKIYE!));
                      },
                    ),
                    PopupMenuItem<SampleItem1>(
                      value: SampleItem1.itemThere,
                      child: Text('Bakiyesi Eksi Olanlar'),
                      onTap: () {
                        stokKartEx.tempList.clear();
                        stokKartEx.tempList.addAll(tempTempStok);
                        stokKartEx.tempList
                            .removeWhere((cari) => cari.BAKIYE! >= 0);
                        setState(() {});
                      },
                    ),
                    PopupMenuItem<SampleItem1>(
                      value: SampleItem1.itemFour,
                      child: Text('Bakiyesi Artı Olanlar'),
                      onTap: () {
                        stokKartEx.tempList.clear();
                        stokKartEx.tempList.addAll(tempTempStok);
                        stokKartEx.tempList
                            .removeWhere((cari) => cari.BAKIYE! < 0);
                        setState(() {});
                      },
                    ),
                    PopupMenuItem<SampleItem1>(
                      value: SampleItem1.itemSix,
                      child: Text('Marka Filtresi Uygula'),
                      onTap: () {
                     

                        showDialog(
                            context: context,
                            builder: (context) {
                              return markaFiltre(
                            
                                  cariKod: "",
                                  aramaCont: aramaCont,
                                  markalar: Ctanim.seciliMarkalarFiltreMap);
                            });
                      },
                    ),
                  ],
                ),
                /*
                Container(
                  width: 30,
                  child: IconButton(
                      onPressed: pickImage, icon: Icon(Icons.image_outlined)
                      //    height: 60, width: 60),
                      ),
                ),
                */
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .75,
              child: Obx(
                () => Scrollbar(
                  thickness: 10,
                  //isAlwaysShown: true,
                  child: ListView.builder(
                      itemCount: stokKartEx.tempList.length,
                      itemBuilder: (context, index) {
                        StokKart stokKart = stokKartEx.tempList[index];
                        String doviz = "-";
                        if (stokKart.SATDOVIZ != "") {
                          doviz = stokKart.SATDOVIZ!;
                        }
                        return Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text(
                                      stokKart.ADI! + " (" + doviz + ")",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16.0),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: EdgeInsets.all(16.0),
                                            /*  height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,*/
                                              child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    thickness: 3,
                                                    indent: 150,
                                                    endIndent: 150,
                                                    color: Colors.grey,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await fisEx
                                                          .listFisStokHareketGetir(
                                                              stokKartEx
                                                                  .tempList[
                                                                      index]
                                                                  .KOD!);
                                                      Future.delayed(
                                                          Duration.zero,
                                                          () => showDialog(
                                                              context: context,
                                                              builder: (_) {
                                                                return genel_belge_gecmis_satis_bilgileri();
                                                              }));
                                                    },
                                                    child: ListTile(
                                                      title: Text(
                                                          "Geçmiş Satışlar"),
                                                      leading: Icon(
                                                        Icons.history,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Future.delayed(
                                                          Duration.zero,
                                                          () => showDialog(
                                                              context: context,
                                                              builder: (_) {
                                                                return stok_kart_detay_guncel(
                                                                  stokKart:
                                                                      stokKart,
                                                                );
                                                              }));
                                                    },
                                                    child: ListTile(
                                                      title: Text("Stok Detay"),
                                                      leading: Icon(
                                                        Icons.search,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (await Connectivity()
                                                              .checkConnectivity() ==
                                                          ConnectivityResult
                                                              .none) {
                                                        print("internet yok");
                                                        const snackBar =
                                                            SnackBar(
                                                          content: Text(
                                                            'İnternet bağlantısı yok.',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                          showCloseIcon: true,
                                                          backgroundColor:
                                                              Colors.blue,
                                                          closeIconColor:
                                                              Colors.white,
                                                        );
                                                        ScaffoldMessenger.of(context
                                                                as BuildContext)
                                                            .showSnackBar(
                                                                snackBar);
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return LoadingSpinner(
                                                              color:
                                                                  Colors.black,
                                                              message:
                                                                  "Stok Resmi Getiriliyor...",
                                                            );
                                                          },
                                                        );

                                                        List<dynamic> donen =
                                                            await bs.getirStokResim(
                                                                sirket: Ctanim
                                                                    .sirket!,
                                                                stokKod:
                                                                    stokKart
                                                                        .KOD!);
                                                        if (donen[0] == true) {
                                                          hataGoster(
                                                              context1: context,
                                                              mesaj: donen[1],
                                                              ikinciGeriOlsunMu:
                                                                  true);
                                                        } else {
                                                          Uint8List bytes =
                                                              base64Decode(
                                                                  donen[1]);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      ((context) =>
                                                                          resim(
                                                                            stokKart:
                                                                                stokKart,
                                                                            bytes:
                                                                                bytes,
                                                                          ))));
                                                        }
                                                      }
                                                    },
                                                    child: ListTile(
                                                      title: Text("Stok Resim"),
                                                      leading: Icon(
                                                        Icons.image,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Kodu",
                                          ),
                                          subtitle: Text(
                                            stokKart.KOD!,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.barcode_reader,
                                            color: Colors.green,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Marka"),
                                          subtitle: Text(
                                            stokKart.MARKA!,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.shopping_bag_rounded,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("KDV"),
                                          subtitle: Text(
                                            "%" +
                                                stokKart.SATIS_KDV!
                                                    .toStringAsFixed(2),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.receipt_long,
                                            color: Colors.red,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("KDV Dahil"),
                                          subtitle: Text(
                                            stokKart.SFIYAT1!
                                                    .toStringAsFixed(2) +
                                                " " +
                                                doviz,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.price_change,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Bakiye "),
                                          subtitle: Text(
                                            stokKart.BAKIYE!.toStringAsFixed(2),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.assignment_outlined,
                                            color: Colors.purple,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ));
                      }),
                ),
              ),
            )
          ]),
        ));
  }

/* void searchB(String query) {
    final suggestion = StokKart.liststok_kartSabit.where((s1) {
      final stitle = s1.sAdi?.toLowerCase();
      final skod = s1.sKodu?.toLowerCase();
      final input = query.toLowerCase();
      return stitle!.contains(input) || skod!.contains(input);
    }).toList();

/*    setState(() {
      stokSearchList.stokKartList. = suggestion;
    });*/
  }*/
}

class markaFiltre extends StatefulWidget {
  const markaFiltre({
    super.key,
    required this.aramaCont,
    required this.markalar,
    required this.cariKod,

  });

  final TextEditingController aramaCont;
  final List<Map<bool, String>>? markalar;
  final String cariKod;
 
  @override
  State<markaFiltre> createState() => _markaFiltreState();
}

class _markaFiltreState extends State<markaFiltre> {
  List<Map<bool, String>> markaIceri = [];
  List<bool> markaIceriBool = [];
  @override
  void initState() {
    // TODO: implement initState
    if (widget.markalar != null) {
      markaIceri.addAll(widget.markalar!);
      for (var element in widget.markalar!) {
        if (element.keys.first == true) {
          seciliMarkalarWidget.add(itemOlustur(element.values.first));
          seciliMarkalarString.add(element.values.first);
        }
      }
    }

    super.initState();
  }

  void searchB(String query) {
    markaIceri.clear();
    if (query.isEmpty) {
      if (widget.markalar != null) {
        markaIceri.addAll(widget.markalar!);
      }
    } else {
      markaIceri = widget.markalar!
          .where((map) =>
              map.values.first.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  List<Widget> seciliMarkalarWidget = [];
  List<String> seciliMarkalarString = [];
  Widget itemOlustur(String adi) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              adi,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 12,
            color: Colors.white,
            onPressed: () {
              seciliMarkalarString.remove(adi);
              int ii = 0;
              setState(() {
                removeCard(adi);
                for (int i = 0; i < widget.markalar!.length; i++) {
                  if (widget.markalar![i].values.first == adi) {
                    ii = i;
                  }
                }
                widget.markalar!.removeAt(ii);
                widget.markalar!.insert(ii, {false: adi});
                markaIceri.clear();
                markaIceri.addAll(widget.markalar!);
              });
            },
          ),
        ],
      ),
    );
  }

  void removeCard(String targetText) {
    setState(() {
      seciliMarkalarWidget.removeWhere((widget) {
        if (widget is Card && widget.child is Row) {
          Row rowWidget = widget.child as Row;
          if (rowWidget.children.length == 3) {
            if (rowWidget.children[0] is Padding &&
                rowWidget.children[2] is IconButton) {
              Padding paddingWidget = rowWidget.children[0] as Padding;
              Text textWidget = paddingWidget.child as Text;
              return textWidget.data == targetText;
            }
          }
        }
        return false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      insetPadding: EdgeInsets.zero,
      title: Text(
        "   Marka Filtresi Uygula",
        style: TextStyle(fontSize: 17),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              seciliMarkalarWidget.length > 0
                  ? SizedBox(
                      height: 50,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: seciliMarkalarWidget.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            return seciliMarkalarWidget[index];
                          },
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: widget.aramaCont,
                  onChanged: (value) {
                    searchB(value);
                    setState(() {});
                  },
                  cursorColor: Color.fromARGB(255, 30, 38, 45),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        color: Color.fromARGB(255, 30, 38, 45),
                        onPressed: () {},
                        icon: Icon(Icons.clear)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Color.fromARGB(255, 30, 38, 45))),
                    hintText: 'Marka Arayanız',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: ListView.builder(
                  itemCount: markaIceri.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isChecked = markaIceri[index].keys.first;
                    String text = markaIceri[index].values.first;
                    return Container(
                      //ASDFDFSDF
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              int ii = 0;

                              setState(() {
                                for (int i = 0;
                                    i < widget.markalar!.length;
                                    i++) {
                                  if (widget.markalar![i].values.first ==
                                      text) {
                                    ii = i;
                                  }
                                }

                                widget.markalar!.removeAt(ii);
                                widget.markalar!.insert(ii, {value!: text});
                                Ctanim.seciliMarkalarFiltreMap.removeAt(ii);
                                Ctanim.seciliMarkalarFiltreMap
                                    .insert(ii, {value: text});
                                markaIceri.clear();

                                markaIceri.addAll(widget.markalar!);

                                if (value == true) {
                                  if (!seciliMarkalarString.contains(text)) {
                                    seciliMarkalarString.add(text);
                                    seciliMarkalarWidget.add(itemOlustur(text));
                                  }
                                } else {
                                  if (seciliMarkalarString.contains(text)) {
                                    seciliMarkalarString.remove(text);
                                    removeCard(text);
                                  }
                                }
                              });
                            },
                          ),
                          Text(text),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: ElevatedButton(
                          child: Text(
                            "Tamam",
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color.fromARGB(255, 30, 38, 45),
                              shadowColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              )),
                          onPressed: () {
                            Ctanim.secililiMarkalarFiltre.clear();
                            Ctanim.secililiMarkalarFiltre
                                .addAll(seciliMarkalarString);
                           stokKartEx.searchB("");
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
