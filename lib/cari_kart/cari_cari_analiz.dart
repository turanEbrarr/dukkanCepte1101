import 'package:flutter/material.dart';
//au

import '../widget/cari.dart';
//DENEYİNCE ANLARSINIZ:)
class cari_cari_iletisim extends StatelessWidget {
  final Cari cariKart;
  const cari_cari_iletisim({super.key, required this.cariKart});
//bitti valla ! mustafa turan azk hadiiiii
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Satir(
              labelText: "Adres: " + cariKart.ADRES.toString(),
              icon: Icon(Icons.map_outlined)),
          Satir(
              labelText: "Telefon: " + cariKart.TELEFON.toString(),
              icon: Icon(Icons.phone_android)),
          Satir(
              labelText: "Fax: " + cariKart.FAX.toString(),
              icon: Icon(Icons.fax)),
        ],
      ),
    );
  }
}

class Satir extends StatelessWidget {
  const Satir({
    super.key,
    required this.labelText,
    required this.icon,
  });
  final String labelText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .95,
        height: 50,
        child: Container(
            padding:
                EdgeInsets.all(8.0), // İstediğiniz padding değerini belirleyin
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 247, 245, 245),
              // Kenarlık rengini ve kalınlığını ayarlayın
              borderRadius:
                  BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
            ),
            child: ListTile(
              title: Text(
                labelText,
                style: TextStyle(fontSize: 15),
              ),
              leading: icon,
            )),
      ),
    );
  }
}
