import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/widget/appbar.dart';

class sayim_fis_detay extends StatefulWidget {
  const sayim_fis_detay({super.key});

  @override
  State<sayim_fis_detay> createState() => _sayim_fis_detayState();
}

class _sayim_fis_detayState extends State<sayim_fis_detay> {
  bool? otomatik = false;
  bool? ayri_ekle = false;
  List<String> depolar = ["MERKEZ", "ŞUBE", ""];
  String? selectedItem = "MERKEZ";
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Sayım Fiş Detay"),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Color.fromARGB(255, 121, 184, 240),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                children: [
                  Text(
                    "Listelenen Stok Sayısı: ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: (() {}),
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.height / 20,
                    child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => satis_fatura_urun_ara()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Listele",
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .70,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Kod/ Ad/ Barkod",
                    ),
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  size: 30,
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 8)),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.photo_camera),
                color: Colors.orange,
                iconSize: 30,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Checkbox(
                    value: otomatik,
                    onChanged: (bool? value) {
                      setState(() {
                        otomatik = value;
                      });
                    },
                  ),
                ),
                Text("Otomatik Ekle"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                Checkbox(
                  value: ayri_ekle,
                  onChanged: (bool? value) {
                    setState(() {
                      ayri_ekle = value;
                    });
                  },
                ),
                Text("Ayrı Eklensin"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(children: [
              Text("Depo:   "),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Center(
                  child: SizedBox(
                    child: DropdownButton<String>(
                      value: selectedItem,
                      items: depolar
                          .map((e) => DropdownMenuItem<String>(
                              value: e, child: Text(e)))
                          .toList(),
                      onChanged: (e) => setState(() {
                        selectedItem = e;
                      }),
                    ),
                  ),
                ),
              ),
              Text("Tarih:  "),
              ElevatedButton(
                child:
                    Text('${dateTime.year}/${dateTime.month}/${dateTime.day}'),
                onPressed: () async {
                  final date = await pickDate();
                  if (date == null) return;
                  setState(() {
                    dateTime = date;
                  });
                },
              ),
            ]),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(children: [
                Text("Açıklama  "),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField()),
              ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Bakiye",
                    ),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "S. Miktar",
                    ),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Miktar",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Ekle"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        //locale: const Locale('tr','TR'),
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
}
