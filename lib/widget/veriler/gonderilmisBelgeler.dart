import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../appbar.dart';
import '../../controllers/fisController.dart';
import '../../faturaFis/fis.dart';
import '../../faturaFis/fisHareket.dart';
import '../veriler/listeler.dart';
import '../../widget/ctanim.dart';
import 'gonderilmisBelgelerDetay.dart';
import 'package:intl/intl.dart';
import '../../widget/customAlertDialog.dart';

class gonderilmisBelgeler extends StatefulWidget {
  final List<Fis> gidenFisler;
  const gonderilmisBelgeler({super.key, required this.gidenFisler});

  @override
  State<gonderilmisBelgeler> createState() => _gonderilmisBelgelerState();
}

class _gonderilmisBelgelerState extends State<gonderilmisBelgeler> {
  FisController fisEx = Get.find();
  Future<String> pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      locale: const Locale('tr', 'TR'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      return formattedDate;
    } else {
      return ''; // Eğer tarih seçilmediyse boş bir değer döndürebilirsiniz.
    }
  }

  FocusNode _startDateFocusNode = FocusNode();
  FocusNode _endDateFocusNode = FocusNode();
  bool startSecili = true;
  bool endSecili = false;
  bool isLoading = false;

  String basTar = "";
  String bitTar = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Gönderilmiş Belgeler"),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          String date = await pickDate();
                          if (date == "") return;
                          setState(() {
                            basTar = date;
                            print(basTar);
                          });
                        },
                        child: Text(
                            basTar != "" ? basTar : "Başlangıç Tarihi Seçiniz"),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          String date = await pickDate();
                          if (date == "") return;
                          setState(() async {
                            bitTar = date;
                            print(bitTar);
                            print("bitti ara");
                            isLoading = true;
                             widget.gidenFisler.clear();
                            setState(() {});
                            List<Fis> gidenTarihliFisler = [];
                            try {
                              gidenTarihliFisler = await fisEx
                                  .listTarihliGidenFisleriGetir(basTar, bitTar);
                             
                              widget.gidenFisler.addAll(gidenTarihliFisler);
                              isLoading = false;
                              setState(() {});
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        child: Text(
                            bitTar != "" ? bitTar : "Bitiş Tarihi Seçiniz"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isLoading == false
              ? Expanded(
                  child: widget.gidenFisler.length > 0
                      ? ListView.builder(
                          itemCount: widget.gidenFisler.length,
                          itemBuilder: (context, index) {
                            String gidenSube = "";
                            String gidenDepo = "";

                            Fis fis = widget.gidenFisler[index];
                            if (fis.CARIADI == "") {
                              for (var element in listeler.listSubeDepoModel) {
                                if (fis.GIDENSUBEID == element.SUBEID) {
                                  gidenSube = element.SUBEADI!;
                                }
                                if (fis.GIDENDEPOID == element.DEPOID) {
                                  gidenDepo = element.DEPOADI!;
                                }
                              }
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    title: fis.CARIADI != ""
                                        ? Text(
                                            fis.CARIADI! +
                                                " (" +
                                                Ctanim()
                                                    .MapFisTipTers[fis.TIP]
                                                    .toString() +
                                                ")",
                                            style: TextStyle(fontSize: 14),
                                          )
                                        : Text(
                                            gidenSube +
                                                "/" +
                                                gidenDepo +
                                                " (" +
                                                Ctanim()
                                                    .MapFisTipTers[fis.TIP]
                                                    .toString() +
                                                ")",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                    subtitle: fis.CARIADI != ""
                                        ? Text(
                                            "Tutar: " +
                                                Ctanim.donusturMusteri(fis
                                                    .GENELTOPLAM!
                                                    .toString()),
                                          )
                                        : Text(
                                            "Tarih :" + fis.TARIH!,
                                          ),
                                    trailing:
                                       IconButton(
                                            icon:
                                                Icon(Icons.arrow_right_rounded),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          gonderilmisBelgelerDetay(
                                                            fis: fis,
                                                          ))));
                                            },
                                          )
                                        
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            );
                          },
                        )
                      : Center(
                          child: Text("Veri Bulunamadı"),
                        ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
