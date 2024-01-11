import 'package:flutter/material.dart';

import '../widget/cari.dart';

class cari_cari_genel extends StatefulWidget {
    final Cari cariKart;

  const cari_cari_genel({super.key, required this.cariKart});
  @override
  State<cari_cari_genel> createState() => _cari_cari_genelState();

}

class _cari_cari_genelState extends State<cari_cari_genel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Satir(labelText: "Cari kodu: "+widget.cariKart.KOD.toString(),),
            Satir(labelText: "Cari Ünvan: "+widget.cariKart.ADI.toString()),
            Satir(labelText: "Vergi Dairesi: "+widget.cariKart.VERGIDAIRESI.toString()),
            Satir(labelText: "Vergi/TC No: "+widget.cariKart.VERGINO.toString()),
            Satir(labelText: "Bakiye: "+widget.cariKart.BAKIYE.toString()),
            Satir(labelText: "E-Fatura: "+widget.cariKart.EFATURAMI.toString()),
            Satir(labelText: "E-Mail: "+widget.cariKart.EMAIL.toString()),
          ],
        ),
      ),
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
            child: Center(
                child: Row(
              children: [
                SizedBox(
                  width:  MediaQuery.of(context).size.width * .9,
                  child: Text(
                    labelText,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ))),
      ),
    );
  }
}
