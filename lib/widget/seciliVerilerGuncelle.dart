import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dukkan_cepte/controllers/cariController.dart';
import 'package:dukkan_cepte/controllers/stokKartController.dart';
import 'package:dukkan_cepte/webservis/base.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/customAlertDialog.dart';
import '../widget/veriler/listeler.dart';

class seciliVerilerWidget extends StatefulWidget {
  const seciliVerilerWidget({
    super.key,
  });

  @override
  State<seciliVerilerWidget> createState() => _seciliVerilerWidgetState();
}

class _seciliVerilerWidgetState extends State<seciliVerilerWidget> {
  BaseService bs = BaseService();
  CariController cariEx = Get.find();
  StokKartController stokKartEx = Get.find(); // final koyulabilir.
  @override
  void initState() {
    super.initState();
  }

  List baslik = [
    "Stok Kart", // 0
    "Cari Kart", // 1
    "Raf", // 2
    "Ölçü Birim", // 3
    "Şube Depo", // 4

    "Kur", // 8
    
    "Plasiyer Banka", // 10
    "Plasiyer Banka Sözleşme", // 11

    "Plasiyer Yetkileri \n(Yeniden başlatma gerekir.)", // 14

    "Noktadan Sonra Haneler", // 16
    "Şube Depo Bilgileri", // 17
    "Stok Depo Bakiyeler", // 18

  ];
  List<bool> checkBoxValue = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
    
  ];
  bool loading = false;
  double progress = 0.0;

  String genelHata = "";
  Future<bool> loadData() async {
    int totalOperations = checkBoxValue
        .where((value) => value)
        .length; // Sadece seçili işlemlerin sayısı

    double completedOperations = 0; // Tamamlanan işlemlerin sayısı
    setState(() {
      loading = true;
    });
   

    List<String?> hatalar = [];
       if(checkBoxValue[17] == true){
      hatalar.add(await bs.getirSubeDepo(
          sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
           if(checkBoxValue[19] == true){
      hatalar.add(await bs.getirFisEkParam(
          sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if(checkBoxValue[14] == true){
      hatalar.add(await bs.getKullanicilar(kullaniciKodu: Ctanim.kullanici!.KOD!, sirket: Ctanim.sirket!, IP: Ctanim.IP));
      hatalar.add(await bs.getirPlasiyerYetki(
          sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD!,IP: Ctanim.IP));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
        if(checkBoxValue[16] == true){
         hatalar.add(await bs.getirOndalikParam(subeId: int.parse(Ctanim.kullanici!.YERELSUBEID!), sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }

    if (checkBoxValue[2] == true) {
      hatalar.add(await bs.getirRaf(sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if (checkBoxValue[3] == true) {
      hatalar.add(await bs.getirOlcuBirim(sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if (checkBoxValue[4] == true) {
      hatalar.add(await bs.getirSubeDepo(sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }

    if (checkBoxValue[8] == true) {
      hatalar.add(await bs.getirKur(sirket: Ctanim.sirket!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
 
    if (checkBoxValue[10] == true) {
      hatalar.add(await bs.getirPlasiyerBanka(
          sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if (checkBoxValue[11] == true) {
      hatalar.add(await bs.getirPlasiyerBankaSozlesme(
          sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }

    if (checkBoxValue[0] == true) {
      hatalar.add(await stokKartEx.servisStokGetir());
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if (checkBoxValue[1] == true) {
      hatalar.add(await cariEx.servisCariGetir());
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if(checkBoxValue[18] == true){
         hatalar.add(await bs.getirStokDepo(sirket: Ctanim.sirket!,plasiyerKod: Ctanim.kullanici!.KOD!));
      completedOperations++;
      updateProgress(completedOperations / totalOperations);
    }
    if (hatalar.length > 0) {
      for (var element in hatalar) {
        if (element != "") {
          genelHata = genelHata + "\n" + "• "+element!;
        }
      }
    }
    if (genelHata != "") {
      setState(() {
        loading = false;
      });
      return true;
    } else {
      setState(() {
        loading = false;
      });
      return false;
    }
  }

  void updateProgress(double percentage) {
    setState(() {
      progress = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      insetPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(
            "Veri Güncelleme",
            style: TextStyle(fontSize: 17, color: Colors.green),
          ),
          Spacer(),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close,color: Colors.red,))
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              loading == false
                  ? Text(
                      "Güncellenecek verileri seçiniz.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.left,
                    )
                  : LinearProgressIndicator(
                    color: Colors.green,
                  ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: ListView.builder(
                  itemCount: baslik.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isChecked = checkBoxValue[index];
                    String text = baslik[index];
                    return Container(
                      //ASDFDFSDF
                      child: Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                checkBoxValue[index] = value!;
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
                      child: 
                      
                      loading == false ?
                      ElevatedButton(
                        
                          child: Text(
                            "Güncelle",
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
                              
                          onPressed: () async {
                            bool hataVarMi = await loadData();
                            if (hataVarMi == false) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      align: TextAlign.left,
                                      title: 'Başarılı',
                                      textColor: Colors.green,
                                      message: 'Seçili başarıyla güncellendi.',
                                      onPres: () async {
                                        Navigator.pop(context);
                                      },
                                      buttonText: 'Devam Et',
                                    );
                                  });
                            } else {
                             showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      align: TextAlign.left,
                                      title: 'Uyarı!',
                                      message:
                                          'Veriler getirilirken bazı hatalar ile karşılaşıldı ya da istenilen veri mevcut değil:\n' +
                                              genelHata,
                                      onPres: () async {
                                        Navigator.pop(context);
                                        genelHata = "";
                                      },
                                      buttonText: 'Devam Et',
                                    );
                                  });
                            
                            }
                            //Navigator.pop(context);
                          }):Container(),
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
