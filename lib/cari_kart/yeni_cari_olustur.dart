import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/widget/appbar.dart';

class yeni_cari_olustur extends StatefulWidget {
  const yeni_cari_olustur({super.key});

  @override
  State<yeni_cari_olustur> createState() => _yeni_cari_olusturState();
}

class _yeni_cari_olusturState extends State<yeni_cari_olustur> {
  final List<String> countries = [
    'Türkiye',
    'Amerika Birleşik Devletleri',
    'Almanya',
    'Fransa',
    'İngiltere',
    // Diğer ülkeleri buraya ekleyebilirsiniz
  ];
  final List<String> sehir = [
    'İstanbul',
    'Ankara',
    'izmir',
    'Konya',
    'Bursa',
    // Diğer ülkeleri buraya ekleyebilirsiniz
  ];
  String? selectedCountry;
  String? sehirSec;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Cari Kayıt"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Müşteri Bilgileri",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Satir(labelText: "Müşteri/Şirket İsmi"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Satir(
            labelText: "Vergi Numarası/TC Kimlik No",
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Adres Bilgileri",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Ülke Seçiniz"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(
                  8.0), // İstediğiniz padding değerini belirleyin
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 247, 245, 245),
                // Kenarlık rengini ve kalınlığını ayarlayın
                borderRadius:
                    BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                        'Ülke Seçimi'), // Varsayılan olarak görüntülenecek metin
                    value: selectedCountry, // Seçili ülke değeri
                    onChanged: (newValue) {
                      setState(() {
                        selectedCountry = newValue;
                      });
                    },
                    items: countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Container(
            height: 120,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .45,
                              child: Text("Şehir Seçiniz")),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("İlçe Seçiniz"),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(
                              8.0), // İstediğiniz padding değerini belirleyin
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 247, 245, 245),
                            // Kenarlık rengini ve kalınlığını ayarlayın
                            borderRadius: BorderRadius.circular(
                                5), // Köşe yarıçapını ayarlayın
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text(
                                    'Şehir Seçimi'), // Varsayılan olarak görüntülenecek metin
                                value: sehirSec, // Seçili ülke değeri
                                onChanged: (newValue) {
                                  setState(() {
                                    sehirSec = newValue;
                                  });
                                },
                                items: sehir.map((String sehir) {
                                  return DropdownMenuItem<String>(
                                    value: sehir,
                                    child: Text(sehir),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            8.0), // İstediğiniz padding değerini belirleyin
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 247, 245, 245),
                          // Kenarlık rengini ve kalınlığını ayarlayın
                          borderRadius: BorderRadius.circular(
                              5), // Köşe yarıçapını ayarlayın
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text(
                                  'Şehir Seçimi'), // Varsayılan olarak görüntülenecek metin
                              value: sehirSec, // Seçili ülke değeri
                              onChanged: (newValue) {
                                setState(() {
                                  sehirSec = newValue;
                                });
                              },
                              items: sehir.map((String sehir) {
                                return DropdownMenuItem<String>(
                                  value: sehir,
                                  child: Text(sehir),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Satir(labelText: "Açık Adres Giriniz"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "İletişim Bilgileri",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Satir(labelText: "Cep Telefonu Giriniz"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Satir(labelText: "Sabit Telefon Giriniz"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Satir(labelText: "Fax Adresi Giriniz"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Satir(labelText: "E-Mail Adresi Giriniz"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Satir(labelText: "Web Adresi Giriniz"),
          Divider(
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Butonun arka plan rengi
                minimumSize:
                    Size(MediaQuery.of(context).size.width*.8, 48), // Butonun minimum genişlik ve yükseklik değeri
              ),
              onPressed: () {
                // Butona tıklandığında gerçekleştirilecek işlemler
              },
              child: Text(
                'Cari Kaydet',
                style: TextStyle(
                  color: Colors.white, // Buton metni rengi
                  fontSize: 16, // Buton metni font boyutu
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class Satir extends StatelessWidget {
  const Satir({
    super.key,
    required this.labelText,
  });
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding:
              EdgeInsets.all(8.0), 
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 245, 245),
            borderRadius: BorderRadius.circular(5), 
          ),
          child: TextFormField(
            cursorColor: Color.fromARGB(255, 60, 59, 59),
            decoration: InputDecoration(
                label: Text(
                  labelText,
                  style: TextStyle(
                      color: Color.fromARGB(255, 60, 59, 59), fontSize: 15),
                ),
                border: InputBorder.none),
          )),
    );
  }
}
