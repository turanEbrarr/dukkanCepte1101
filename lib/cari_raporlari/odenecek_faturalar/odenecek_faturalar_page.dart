import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dukkan_cepte/cari_kart/yeni_cari_olustur.dart';
import 'package:dukkan_cepte/widget/appbar.dart';
import 'package:dukkan_cepte/widget/cari.dart';

class odenecek_faturalar_page extends StatefulWidget {
  const odenecek_faturalar_page({super.key});

  @override
  State<odenecek_faturalar_page> createState() => _odenecek_faturalar_pageState();
}

class _odenecek_faturalar_pageState extends State<odenecek_faturalar_page> {
    List<Cari> carikayit = [];

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: MyAppBar(
        title: "Cari Seçimi",
        height: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Color.fromARGB(255, 121, 184, 240),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Listelenen Cari:  ${carikayit.length}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                    ),
                    IconButton( onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>yeni_cari_olustur()));
                    },
                      icon: Icon(
                        Icons.add_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 12.0),
                      child: Icon(
                        Icons.published_with_changes_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      // labelText: "Listeyi ara",
                      hintText: "Aranacak kelime (Ünvan/Kod)",
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      iconColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
             //       onChanged: searchB,
                  ),
                ),
                  /*
                  Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset("images/slider.png",
                            height: 60, width: 60),
                      )),
                      */
              ],
            ),
            SizedBox(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*.70,
                  child: ListView.builder(
                    itemCount: carikayit.length,
                    itemBuilder: (context, index) {
                      final c1 = carikayit[index];
                      return Card(
                        // color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 10,
                        color: Colors.blue[70],
                        child: Column(
                          children: [
                            ListTile(
                           /*   leading: Icon(
                                carikayit[index].icon,
                                color: Color(0xFF2494f4),
                                size: 40,
                              ),*/
                              title: Text(
                                carikayit[index].ADI!,
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              onTap: (() {
                                
                              })
                            ),
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Text(
                                  "Kodu:   " + carikayit[index].KOD!,
                                  style:
                                      TextStyle(color: Colors.red, fontSize: 15),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Text(
                                    "Bakiye:      " + carikayit[index].BAKIYE!.toString(),
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }


}
