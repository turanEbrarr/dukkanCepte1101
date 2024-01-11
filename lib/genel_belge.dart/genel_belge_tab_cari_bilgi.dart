import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/controllers/fisController.dart';

import '../widget/cari.dart';

class genel_belge_tab_cari_bilgi extends StatefulWidget {
  genel_belge_tab_cari_bilgi({super.key, required this.cariKart});
  Cari cariKart;

  @override
  State<genel_belge_tab_cari_bilgi> createState() =>
      _genel_belge_tab_cari_bilgiState();
}

FisController fisEx = Get.find();

class _genel_belge_tab_cari_bilgiState
    extends State<genel_belge_tab_cari_bilgi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
                child: ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .30,
                        child: const Text(
                          "CARİ KODU",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                          width: 4,
                          child: Text(
                            ":",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .55,
                            child: Text(widget.cariKart.KOD.toString())),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 13,
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .30,
                        child: const Text(
                          "CARİ ÜNVAN",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    SizedBox(
                        width: 4,
                        child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .55,
                          child: Text(widget.cariKart.ADI.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: const Text(
                        "VERGİ DAİRESİ",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                        width: 4,
                        child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * .55,
                          child: Text(widget.cariKart.VERGIDAIRESI.toString() ==
                                      "null" ||
                                  widget.cariKart.VERGIDAIRESI == null
                              ? ""
                              : widget.cariKart.VERGIDAIRESI.toString())),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: const Text(
                        "VERGİ/TC NO",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                        width: 4,
                        child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * .55,
                          child: Text(
                              fisEx.fis!.value.cariKart.VERGINO.toString())),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: const Text(
                        "BAKİYE",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                        width: 4,
                        child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * .55,
                          child: Text(
                              fisEx.fis!.value.cariKart.BAKIYE.toString())),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Text(
                        "E-FATURA",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                        width: 4,
                        child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .55,
                            child: Text(fisEx.fis!.value.cariKart.EFATURAMI
                                        .toString() ==
                                    false
                                ? "Hayır"
                                : "Evet"))),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              child: ListTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: const Text(
                        "E-MAİL",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                        width: 4,
                        child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * .55,
                            child: Text(
                                fisEx.fis!.value.cariKart.EMAIL.toString())))
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
