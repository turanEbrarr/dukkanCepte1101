

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import '../controllers/fisController.dart';
import '../faturaFis/fis.dart';

class genel_belge_gecmis_satis_bilgileri extends StatefulWidget {

  
  genel_belge_gecmis_satis_bilgileri({super.key, });
  @override
  State<genel_belge_gecmis_satis_bilgileri> createState() =>
      siparis_fatura_expanded_widgetState();
}
FisController fisEx = Get.find();

class siparis_fatura_expanded_widgetState
    extends State<genel_belge_gecmis_satis_bilgileri> {
      var tipList;
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tipList = Ctanim().MapFisTip.keys.toList();
  }
    

    
 @override
  Widget build(BuildContext context) {

  double x= MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
         insetPadding: EdgeInsets.all(10),
      
        title: SizedBox(width: x*.8,
          child: Row(
            children: [
              const Text("Ürün Geçmiş Satış Bilgileri",style: TextStyle(fontSize: 16),),
              Spacer(),
              IconButton(onPressed:(){ Get.back();}, icon:const Icon(Icons.cancel,color: Colors.red,),iconSize: x*.1, )
            ],
          ),
        ),
        content: Container(
          height: 700,
          width: MediaQuery.of(context).size.width*.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fisEx.sonListem.isEmpty ? Center(child: Text('Stok Geçmişi Bulunamadı.')) 
                :ExpansionPanelList(
                  dividerColor: Colors.blue,
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      fisEx.sonListem[panelIndex].isExpanded = !isExpanded;
                     
                    });
                  },
                  children: fisEx.sonListem.map<ExpansionPanel>((Fis fis) {
                    return ExpansionPanel(
                      
                      //SELAM
                        headerBuilder: ((context, isExpanded) {
                          return  Container(
                           // decoration: BoxDecoration( border: Border(top: BorderSide(color: Colors.pink))),
                            width: MediaQuery.of(context).size.width,
                            
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0, bottom:2),
                                  child: Row(
                                    children: [
                                   
                                       SizedBox(width: MediaQuery.of(context).size.width*.16,
                                        child: const Text("Tarih:", style: TextStyle( fontSize: 12, color: Colors.blue,fontWeight:FontWeight.bold))), 
                                      const SizedBox(width: 5),
                                       SizedBox(width: MediaQuery.of(context).size.width*.35,
                                        child: Text( fis.TARIH!, style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold))),
                                    ],
                                  ),
                                ),
                                    
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Cari Adı:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12,fontWeight:FontWeight.bold))),
                                    const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child: Text(fis.CARIADI!, maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold),),
                               )
                               ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Belge Tipi:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12,fontWeight:FontWeight.bold))),
                                    const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child:  Text(tipList[fis.TIP!-1].toString(), maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold),),
                               )
                               ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Belge No:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12,fontWeight:FontWeight.bold))),
                                     const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child:  Text(fis.BELGENO!, maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold),),
                               )
                               ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 10),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Plasiyer:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12,fontWeight:FontWeight.bold))),
                                     const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child: const Text("Selman Kayacı", maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold),),
                               )
                               ]),
                              ),
                              ],
                            ),
                          );
                        }),
                        body:Container(
                          height: MediaQuery.of(context).size.height/2.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Divider(color: Colors.blue,),
                               Padding(
                                  padding: const EdgeInsets.only(top:2.0, bottom:2),
                                  child: Row(
                                    children: [
                                         
                                       SizedBox(width: MediaQuery.of(context).size.width*.16,
                                        child: const Text("Tarih:", style: TextStyle( fontSize: 12, color: Colors.blue))), 
                                      const SizedBox(width: 5),
                                       SizedBox(width: MediaQuery.of(context).size.width*.35,
                                        child: Text( fis.TARIH!, style: TextStyle(fontSize: 12))),
                                    ],
                                  ),
                                ),
                                    
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Cari Adı:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12))),
                                    const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child: Text(fis.CARIADI!, maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),
                               )
                               ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Belge Tipi:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12))),
                                    const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child:  Text(tipList[fis.TIP!-1].toString(), maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),
                               )
                               ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Belge No:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12))),
                                     const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child: const Text("SE4567", maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),
                               )
                               ]),
                              ),
                              Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Stok Adı:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12))),
                                     const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child:  Text(fis.fisStokListesi[0].STOKADI!, maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),
                               )
                               ]),
                              ),
                           /*   Padding(
                              padding: const EdgeInsets.only(top:2.0, bottom: 2),
                              child: Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*.16,
                                    child: const  Text("Plasiyer:" ,
                                    style: TextStyle(color: Colors.blue, fontSize: 12))),
                                     const SizedBox(width: 5),
                               SizedBox(width: MediaQuery.of(context).size.width*.35,
                               child: const Text("", maxLines: 6,
                                            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),
                               )
                               ]),
                              )*/ const Divider( thickness: 2,),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height*0.15,
                                    child: Row( 
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:MediaQuery.of(context).size.width*.35,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                                              
                                                rowTasarim("Giriş", "2",textSize: x*.15, karsiTextSize: x*.17),
                                                rowTasarim("Çıkış", "0",textSize: x*.15, karsiTextSize: x*.18),
                                                rowTasarim("Bakiye", fis.fisStokListesi[0].MIKTAR.toString(),textSize: x*.15, karsiTextSize: x*.18),
                                                rowTasarim("Birim", "ADET",textSize: x*.15, karsiTextSize: x*.18),
                                                rowTasarim("KDV", Ctanim. donusturMusteri(fis.fisStokListesi[0].KDVORANI.toString()),textSize: x*.15, karsiTextSize: x*.18),
                                                rowTasarim("Net Fiyat", Ctanim. donusturMusteri(fis.fisStokListesi[0].NETFIYAT.toString()),textSize: x*.15, karsiTextSize: x*.18),
                                                rowTasarim("Brüt Fiyat", Ctanim. donusturMusteri(fis.fisStokListesi[0].BRUTFIYAT.toString()),textSize: x*.15, karsiTextSize: x*.18),
                                               
                                                                                  
                                              ],
                                               
                                            ),
                                          ),
                                        ),
                                        const VerticalDivider(indent: 15,endIndent: 15, thickness: 2,),
                                       SizedBox(width:MediaQuery.of(context).size.width*.35,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                               rowTasarim("İsk. Düş. Fiyat",Ctanim. donusturMusteri( fis.fisStokListesi[0].NETFIYAT.toString()),textSize: x*.2, karsiTextSize: x*.14),
                                               rowTasarim("İsk Açıklama", fis.ACIKLAMA1.toString(), textSize: x*.2, karsiTextSize: x*.14,maxLines: 5),
                                               rowTasarim("KDV Dahil", Ctanim. donusturMusteri(fis.fisStokListesi[0].NETFIYAT.toString()),textSize: x*.2, karsiTextSize: x*.14),
                                               rowTasarim("İsk Toplam", Ctanim. donusturMusteri(fis.INDIRIM_TOPLAMI.toString()),textSize: x*.2, karsiTextSize: x*.14),
                                               rowTasarim("Toplam", Ctanim. donusturMusteri(fis.GENELTOPLAM.toString()),textSize: x*.2, karsiTextSize: x*.14),
                                               rowTasarim("Brüt Toplam", Ctanim. donusturMusteri(fis.TOPLAM.toString()),textSize: x*.2, karsiTextSize: x*.14,maxLines: 3),
          
                                              ],
                                                                                  
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
 
                             //Divider(color: Colors.red,)
                            ],
                          )
                        ),
                        isExpanded: fis.isExpanded!);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rowTasarim (String text, String karsiText,{ @required double? karsiTextSize, @required double? textSize,int? maxLines}){
   
    return Row(
          children: [
                   SizedBox(
                      width: textSize,
                      child: Text( text+":", style: TextStyle(color: Colors.blue, fontSize: 12),)),
                      SizedBox(width:MediaQuery.of(context).size.width*0.01),
                      SizedBox(
                      width: karsiTextSize,
                      child: Text( karsiText,maxLines: maxLines,style: TextStyle(fontSize: 12))),
            ],
      );
  }


 
}