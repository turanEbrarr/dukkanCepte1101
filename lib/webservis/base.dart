import 'dart:convert';
import 'dart:io';
// turan

import 'dart:math';
//import 'dart:js_util'; //??????
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dukkan_cepte/Depo%20Transfer/subeDepoModel.dart';
import 'package:dukkan_cepte/faturaFis/fisEkParam.dart';
import 'package:dukkan_cepte/stok_kart/stokDepoMode.dart';
import 'package:dukkan_cepte/webservis/bankaModel.dart';
import 'package:dukkan_cepte/webservis/kullaniciYetki.dart';
import 'package:dukkan_cepte/webservis/kurModel.dart';

import 'package:dukkan_cepte/widget/cari.dart';
import 'package:dukkan_cepte/widget/cariAltHesap.dart';
import 'package:dukkan_cepte/widget/ctanim.dart';
import 'package:dukkan_cepte/widget/kullaniciModel.dart';

import 'package:dukkan_cepte/widget/modeller/ondalikModel.dart';
import 'package:dukkan_cepte/widget/modeller/rafModel.dart';

import 'package:xml/xml.dart' as xml;
import '../localDB/veritabaniIslemleri.dart';
import '../localDB/databaseHelper.dart';
import '../stok_kart/stok_tanim.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/olcuBirimModel.dart';
import 'bankaSozlesmeModel.dart';

class BaseService {
  var _Result;
  String mac = "";

  get Result => _Result;

  set Result(value) {
    _Result = value;
  }

  String temizleKontrolKarakterleri1(String metin) {
    final kontrolKarakterleri = RegExp(r'[\x00-\x1F\x7F]');

    final int chunkSize =
        1024; // Metni kaç karakterlik parçalara böleceğimizi belirtiyoruz.
    final int length = metin.length;
    final StringBuffer result = StringBuffer();

    for (int i = 0; i < length; i += chunkSize) {
      int end = (i + chunkSize < length) ? i + chunkSize : length;
      String chunk = metin.substring(i, end);
      result.write(chunk.replaceAll(kontrolKarakterleri, ''));
    }

    return result.toString();
  }

  Future<List<String>> lisansSorgula(String lisansNumarasi) async {
    var url = Uri.parse('http://94.54.108.179:8187/WebService1.asmx');
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/LisansSorgula'
    };

    String body = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <LisansSorgula xmlns="http://tempuri.org/">
      <lisansNo>$lisansNumarasi</lisansNo>
    </LisansSorgula>
  </soap:Body>
</soap:Envelope>''';

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);

        var jsonData = [];
        try {
          var tt = temizleKontrolKarakterleri1(parsedXml.innerText);
          jsonData = json.decode(tt);
        } catch (e) {
          print(e);
        }
        List<String> ipList = [];

        ipList.add(jsonData[0]['ICIP']);
        ipList.add(jsonData[0]['DISIP']);

        return ipList;
        // }
      } else {
        print('SOAP isteği başarısız: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  Future<String> getKullanicilar({
    required String kullaniciKodu,
  }) async {
    var url = Uri.parse(
        "http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/KullaniciGetir'
    };

    String body = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <KullaniciGetir xmlns="http://tempuri.org/">
      <kullaniciKodu>$kullaniciKodu</kullaniciKodu>
    </KullaniciGetir>
  </soap:Body>
</soap:Envelope>''';

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
            xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);

        var jsonData = [];
        try {
          var tt = temizleKontrolKarakterleri1(parsedXml.innerText);
          jsonData = json.decode(tt);
        } catch (e) {
          print(e);
        }
        Ctanim.kullanici = KullaniciModel.fromjson(jsonData[0]);
     
        return "";
      } else { 
        print('SOAP isteği başarısız: ${response.statusCode}');
        return " Kullanıcı Bilgileri Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      print('Hata: $e' );
      return " Kullanıcı bilgiler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirPlasiyerYetki() async {
    var url = Uri.parse(
        "http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/KullaniciYetkiGetir'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <KullaniciYetkiGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
           xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);

        var jsonData = [];
        try {
          var tt = temizleKontrolKarakterleri1(parsedXml.innerText);
          jsonData = json.decode(tt);
        } catch (e) {
          print(e);
        }
   
          listeler.yetki.clear();

          listeler.yetki = List<KullaniciYetki>.from(
              jsonData.map((model) => KullaniciYetki.fromJson(model)));

          for (var element in listeler.yetki) {
            print(element);
            bool sonBool;
            if (element.deger == "False") {
              sonBool = false;
            } else {
              sonBool = true;
            }
            listeler.plasiyerYetkileri.removeAt(element.sira!);
            listeler.plasiyerYetkileri.insert(element.sira!, sonBool);
          }
          await SharedPrefsHelper.yetkiKaydet(
              listeler.plasiyerYetkileri, "yetkiler");

          return "";
        
      } else {
        Exception(
            'Plasiyer Yetki Alınamadı. StatusCode: ${response.statusCode}');

        return 'Plasiyer Yetki Alınamadı. StatusCode: ${response.statusCode}';
      }
    } catch (e) {
      Exception('Hata: $e');

      return "Plasiyer Yetki için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirStoklar() async {
    var url = Uri.parse(
        "http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/StoklariGetir'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <StoklariGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';

    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      listeler.liststok = [];
      return "İnternet Yok";
    }

    List<StokKart> tt = [];
    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonAl(response);
        List<StokKart> liststokTemp = [];

        liststokTemp = List<StokKart>.from(
            jsonData.map((model) => StokKart.fromJson(model)));
        listeler.liststok.clear();
        await VeriIslemleri().stokTabloTemizle();

        liststokTemp.forEach((webservisStok) async {
          await VeriIslemleri().stokEkle(webservisStok);
        });

        await VeriIslemleri().stokGetir();
        return "";
        // }
      } else {
        return " Stok Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } on PlatformException catch (e) {
      return "Stoklar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  List<dynamic> jsonAl(http.Response response) {
    xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
    var jsonData = [];
    try {
      var tt = temizleKontrolKarakterleri1(parsedXml.innerText);
      jsonData = json.decode(tt);
    } catch (e) {
      print(e);
    }
    return jsonData;
  }

  String temizleKontrolKarakterleri(String metin) {
    final kontrolKarakterleri = RegExp(r'[\x00-\x1F\x7F]');
    return metin.replaceAll(kontrolKarakterleri, '');
  }

////webservisteki carileri getirir
  Future<String> getirCariler() async {
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx");
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/CarileriGetir'
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CarileriGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';

    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      listeler.listCari = [];
      return "İnternet Yok";
    }
    List<Cari> ttcari = [];
    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
        var jsonData = [];
        try {
          var tt = temizleKontrolKarakterleri1(parsedXml.innerText);
          jsonData = json.decode(tt);
        } catch (e) {
          print(e);
        }
        List<Cari> listCariTemp = [];

        listCariTemp =
            List<Cari>.from(jsonData.map((model) => Cari.fromJson(model)));

        listeler.listCari.clear();
        await VeriIslemleri().cariTabloTemizle();

        listCariTemp.forEach((webservisStok) async {
          await VeriIslemleri().cariEkle(webservisStok);
          await VeriIslemleri().cariAltHesapEkle(CariAltHesap(
              KOD: webservisStok.KOD,
              ALTHESAP: "NORMAL",
              DOVIZID: 1,
              VARSAYILAN: "E"));
        });

        await VeriIslemleri().cariGetir();
        return "";
        // }
      } else {
        return " Cariler Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }

      // databaseden veri getirir
    } on Exception catch (e) {
      listeler.listCari = ttcari;
      return "Cariler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirKur() async {
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx");
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/KurGetir'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <KurGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
          List<dynamic> jsonData = jsonAl(response);
     
          listeler.listKur.clear();
          await VeriIslemleri().kurTemizle();

    

          listeler.listKur =
              List<KurModel>.from(jsonData.map((model) => KurModel.fromJson(model)));

          for (var element in listeler.listKur) {
            await VeriIslemleri().kurEkle(element);
          }
          return "";
        
      } else {
        Exception('Kur verisi alınamadı. StatusCode: ${response.statusCode}');
        return " Kurlar Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Kurlar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }
  
  Future<String> getirOlcuBirim() async {
   var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx");
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/OlcuBirimGetir'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <OlcuBirimGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonAl(response);
        
          await VeriIslemleri().olcuBirimTemizle();
          listeler.listOlcuBirim.clear();
          
          listeler.listOlcuBirim = List<OlcuBirimModel>.from(
              jsonData.map((model) => OlcuBirimModel.fromJson(model)));

          listeler.listOlcuBirim.forEach((webservisCariStokKosul) async {
            await VeriIslemleri().olcuBirimEkle(webservisCariStokKosul);
          });
          return "";
        
      } else {
        Exception(
            'Ölçü Birim verisi alınamadı. StatusCode: ${response.statusCode}');
        return 'Ölçü Birim Verisi Alınamadı. StatusCode: ${response.statusCode}';
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Ölçü Birim için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirSubeDepo() async {
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx");// dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/SubeDepoGetir'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SubeDepoGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
         List<dynamic> jsonData = jsonAl(response);
          List<SubeDepoModel> tempList = [];
          jsonData.forEach((element) {
            // int ID = int.parse(element['ID'].toString());
            int SUBEID = int.parse(element['SUBEID'].toString());
            int DEPOID = int.parse(element['DEPOID'].toString());
            String SUBEADI = element['SUBEADI'];
            String DEPOADI = element['DEPOADI'];

            tempList.add(SubeDepoModel(
                SUBEID: SUBEID,
                DEPOID: DEPOID,
                SUBEADI: SUBEADI,
                DEPOADI: DEPOADI));
          });
          tempList.forEach((webservisSubeDepo) async {
            int Index = listeler.listSubeDepoModel.indexWhere(
                (element) => element.SUBEID == webservisSubeDepo.SUBEID);
            if (Index > -1) {
              SubeDepoModel localSubeDepo =
                  listeler.listSubeDepoModel.firstWhere(
                (element) => element.SUBEID == webservisSubeDepo.SUBEID,
              );
              webservisSubeDepo.ID = localSubeDepo.ID;
              await VeriIslemleri().subeDepoGuncelle(webservisSubeDepo);
            } else {
              await VeriIslemleri().subeDepoEkle(webservisSubeDepo);
            }
          });
          await VeriIslemleri().subeDepoGetir();
          return "";
        
      } else {
        Exception(
            'Sube-Depo verisi alınamadı. StatusCode: ${response.statusCode}');
        return " Şube_Depo Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      Exception('Hata: $e');
      return " Şube_Depo için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  List<String> parseSoapResponse(String soapResponse) {
    var document = xml.XmlDocument.parse(soapResponse);
    var envelope = document.findAllElements('soap:Envelope').single;
    var body = envelope.findElements('soap:Body').single;
    var response = body.findElements('GetirAPKServisIPResponse').single;
    var result = response.findElements('GetirAPKServisIPResult').single;
    List<String> donecek = result.text.split("|");
    return donecek;
  }

  Future<String> test(String IP) async {
    // dış ve iç denecek;
    var url = Uri.parse(IP);
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/WebServisTest'
    };

    String body = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <WebServisTest xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>''';

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          String modelNode = gelenHata.HataMesaj!;
          List<dynamic> parsedList = json.decode(modelNode);

          Map<String, dynamic> kullaniciJson = parsedList[0];
          Ctanim.kullanici = KullaniciModel.fromjson(kullaniciJson);
          return "";
        }
      } else {
        print('SOAP isteği başarısız: ${response.statusCode}');
        return " Kullanıcı Bilgileri Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      print('Hata: $e');
      return " Kullanıcı bilgiler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,1000}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<SHataModel> ekleFatura(
      {required String sirket,
      required Map<String, dynamic> jsonDataList}) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx");
    print("PARAMETRE GELEN"); 
    printWrapped(jsonDataList.toString());

    jsonString = jsonEncode(jsonDataList);
      print("PARAMETRE Oluşan"); 
    printWrapped(jsonString);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/FisEkle',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <FisEkle xmlns="http://tempuri.org/">
      <jsonData>$jsonString</jsonData>
    </FisEkle>
  </soap:Body>
</soap:Envelope>
''';

    printWrapped(jsonString);
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        return gelenHata;
      } else {
        Exception(
            'Fatura Verisi Gönderilemedi. StatusCode: ${response.statusCode}');
        return hata;
      }
    } catch (e) {
      Exception('Hata: $e');
      return hata;
    }
  }



  Future<SHataModel> ekleTahsilat(
      {required String sirket,
      required Map<String, dynamic> jsonDataList}) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;

    jsonString = jsonEncode(jsonDataList);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/TahsilatOdemeEkle',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <TahsilatOdemeEkle xmlns="http://tempuri.org/">
      <jsonData>$jsonString</jsonData>
    </TahsilatOdemeEkle>
  </soap:Body>
</soap:Envelope>
''';
    print("Tahsilat Ekleme");
    printWrapped(jsonString);
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        return gelenHata;
      } else {
        Exception(
            'Tahsilat Verisi Gönderilemedi. StatusCode: ${response.statusCode}');
        return hata;
      }
    } catch (e) {
      Exception('Hata: $e');
      return hata;
    }
  }


  Future<SHataModel> ekleSayim(
      {required String sirket,
      required Map<String, dynamic> jsonDataList}) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;

    jsonString = jsonEncode(jsonDataList);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/SayimEkle',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SayimEkle xmlns="http://tempuri.org/">
      <jsonData>$jsonString</jsonData>
    </SayimEkle>
  </soap:Body>
</soap:Envelope>
''';
    printWrapped(jsonString);
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        return gelenHata;
      } else {
        Exception(
            'Sayım Verisi Gönderilemedi. StatusCode: ${response.statusCode}');
        return hata;
      }
    } catch (e) {
      Exception('Hata: $e');
      return hata;
    }
  }
  Future<SHataModel> ekleStok(
      {required String sirket,
      required Map<String, dynamic> jsonDataList}) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;
    var url = Uri.parse("http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;

    jsonString = jsonEncode(jsonDataList);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/StokEkle',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <StokEkle xmlns="http://tempuri.org/">
      <jsonData>$jsonString</jsonData>
    </StokEkle>
  </soap:Body>
</soap:Envelope>
''';
    printWrapped(jsonString);
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        return gelenHata;
      } else {
        Exception(
            'Yeni Stok Verisi Gönderilemedi. StatusCode: ${response.statusCode}');
        return hata;
      }
    } catch (e) {
      Exception('Hata: $e');
      return hata;
    }
  }

  Future<List<List<dynamic>>> getirGenelRapor(
      {required String sirket,
      required String kullaniciKodu,
      required String fonksiyonAdi}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/$fonksiyonAdi'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <$fonksiyonAdi xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
    </$fonksiyonAdi>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return [
            [gelenHata.HataMesaj],
            []
          ];
        } else {
          List<DataColumn> kolonlar = [];
          List<String> satirlar = [];
          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));
          try {
            if (jsonData.isNotEmpty) {
              jsonData[0].forEach((key, value) {
                kolonlar.add(DataColumn(label: Text(key)));
              });
              for (int i = 0; i < jsonData.length; i++) {
                jsonData[i].forEach((key, value) {
                  satirlar.add(value.toString());
                });
              }
            }
          } catch (e) {
            print(e);
          }

          print(kolonlar.length);
          print(satirlar.length);

          return [satirlar, kolonlar];
        }
      } else {
        Exception(fonksiyonAdi.toString() +
            'için Genel Rapor Bilgisi Alınamadı. StatusCode: ${response.statusCode}');

        return [
          [
            fonksiyonAdi.toString() +
                'için Genel Rapor Bilgisi Alınamadı. StatusCode: ${response.statusCode}'
          ],
          []
        ];
      }
    } catch (e) {
      Exception('Hata: $e');

      return [
        [
          fonksiyonAdi.toString() +
              " için  Webservisten veri çekilemedi. Hata Mesajı : " +
              e.toString()
        ],
        []
      ];
    }
  }

  Future<List<List<dynamic>>> getirCariEkstre({
    required String sirket,
    required String cariKodu,
  }) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/RaporCariEkstre'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <RaporCariEkstre xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Cari_Kod>$cariKodu</Cari_Kod>
    </RaporCariEkstre>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return [
            [gelenHata.HataMesaj],
            []
          ];
        } else {
          List<DataColumn> kolonlar = [];
          List<String> satirlar = [];

          if (gelenHata.Hata == "false" && gelenHata.HataMesaj == "") {
            return [
              ["Veri Bulunamadı"],
              []
            ];
          }

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));

          try {
            if (jsonData.isNotEmpty) {
              jsonData[0].forEach((key, value) {
                kolonlar.add(DataColumn(label: Text(key)));
              });
              for (int i = 0; i < jsonData.length; i++) {
                jsonData[i].forEach((key, value) {
                  satirlar.add(value.toString());
                });
              }
            }
          } catch (e) {
            print(e);
          }

          print(kolonlar.length);
          print(satirlar.length);

          return [satirlar, kolonlar];
        }
      } else {
        Exception(
            'CARİ EXTRE Rapor Alınamadı. StatusCode: ${response.statusCode}');

        return [
          ['CARİ EXTRE Rapor Alınamadı. StatusCode: ${response.statusCode}'],
          []
        ];
      }
    } catch (e) {
      Exception('Hata: $e');

      return [
        [
          "CARİ EXTRE Rapor için Webservisten veri çekilemedi. Hata Mesajı : " +
              e.toString()
        ],
        []
      ];
    }
  }

  Future<List<List<dynamic>>> getirCariEkstreDetay({
    required String sirket,
    required String faturaID,
  }) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/RaporCariEkstreDetay'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <RaporCariEkstreDetay xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <FaturaId>$faturaID</FaturaId>
    </RaporCariEkstreDetay>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return [
            [gelenHata.HataMesaj],
            []
          ];
        } else {
          List<DataColumn> kolonlar = [];
          List<String> satirlar = [];

          if (gelenHata.Hata == "false" && gelenHata.HataMesaj == "") {
            return [
              ["Veri Bulunamadı"],
              []
            ];
          }

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));

          try {
            if (jsonData.isNotEmpty) {
              jsonData[0].forEach((key, value) {
                kolonlar.add(DataColumn(label: Text(key)));
              });
              for (int i = 0; i < jsonData.length; i++) {
                jsonData[i].forEach((key, value) {
                  satirlar.add(value.toString());
                });
              }
            }
          } catch (e) {
            print(e);
          }

          print(kolonlar.length);
          print(satirlar.length);

          return [satirlar, kolonlar];
        }
      } else {
        Exception(
            'CariEkstreDetay Rapor Alınamadı. StatusCode: ${response.statusCode}');

        return [
          [
            'CariEkstreDetay Rapor Alınamadı. StatusCode: ${response.statusCode}'
          ],
          []
        ];
      }
    } catch (e) {
      Exception('Hata: $e');

      return [
        [
          "CariEkstreDetay Rapor için Webservisten veri çekilemedi. Hata Mesajı : " +
              e.toString()
        ],
        []
      ];
    }
  }


  Future<String> getirStokDepo({required sirket, required plasiyerKod}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStokDepoBakiye'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirStokDepoBakiye xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$plasiyerKod</PlasiyerKod>
    </GetirStokDepoBakiye>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          listeler.listStokDepo.clear();
          await VeriIslemleri().stokDepoTemizle();

          String modelNode = gelenHata.HataMesaj!;
          Iterable l = json.decode(modelNode);

          listeler.listStokDepo = List<StokDepoModel>.from(
              l.map((model) => StokDepoModel.fromJson(model)));

          for (var element in listeler.listStokDepo) {
            await VeriIslemleri().stokDepoEkle(element);
          }
          return "";
        }
      } else {
        Exception(
            'Stok Depo verisi alınamadı. StatusCode: ${response.statusCode}');
        return " Stokların Depo Bakiyeleri Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Stoklar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<void> testTuran() async {
    var url = Uri.parse(
        "http://94.54.108.179:8187/WebService1.asmx"); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/StoklariGetir'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <StoklariGetir xmlns="http://tempuri.org/" />
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        printWrapped(parsedXml.innerText);
        List<dynamic> jsonData = json.decode(parsedXml.innerText);
        print(jsonData.length);
      } else {
        Exception('HATA. StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      Exception('Hata: $e');
      print(e);
    }
  }

  Future<List<List<dynamic>>> getirAlisFaturaRapor({
    required String sirket,
    required String cariKodu,
    required String basTar,
    required String bitTar,
  }) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/RaporAlisFaturaListesi'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <RaporAlisFaturaListesi xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Cari_Kodu>$cariKodu</Cari_Kodu>
      <Bastar>$basTar</Bastar>
      <Bittar>$bitTar</Bittar>
    </RaporAlisFaturaListesi>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return [
            [gelenHata.HataMesaj],
            []
          ];
        } else {
          List<DataColumn> kolonlar = [];
          List<String> satirlar = [];

          if (gelenHata.Hata == "false" && gelenHata.HataMesaj == "") {
            return [
              ["Veri Bulunamadı"],
              []
            ];
          }

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));

          try {
            if (jsonData.isNotEmpty) {
              jsonData[0].forEach((key, value) {
                kolonlar.add(DataColumn(label: Text(key)));
              });
              for (int i = 0; i < jsonData.length; i++) {
                jsonData[i].forEach((key, value) {
                  satirlar.add(value.toString());
                });
              }
            }
          } catch (e) {
            print(e);
          }

          print(kolonlar.length);
          print(satirlar.length);

          return [satirlar, kolonlar];
        }
      } else {
        Exception(
            'Alis Fatura Rapor Alınamadı. StatusCode: ${response.statusCode}');

        return [
          ['Alis Fatura Rapor  Alınamadı. StatusCode: ${response.statusCode}'],
          []
        ];
      }
    } catch (e) {
      Exception('Hata: $e');

      return [
        [
          "Alis Fatura Rapor  için Webservisten veri çekilemedi. Hata Mesajı : " +
              e.toString()
        ],
        []
      ];
    }
  }

  Future<List<List<dynamic>>> getirSatisFaturaRapor(
      {required String sirket,
      required String cariKodu,
      required String basTar,
      required String bitTar}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/RaporSatisFaturaListesi'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <RaporSatisFaturaListesi xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Cari_Kodu>$cariKodu</Cari_Kodu>
      <Bastar>$basTar</Bastar>
      <Bittar>$bitTar</Bittar>
    </RaporSatisFaturaListesi>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return [
            [gelenHata.HataMesaj],
            []
          ];
        } else {
          List<DataColumn> kolonlar = [];
          List<String> satirlar = [];

          if (gelenHata.Hata == "false" && gelenHata.HataMesaj == "") {
            return [
              ["Veri Bulunamadı"],
              []
            ];
          }

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));

          try {
            if (jsonData.isNotEmpty) {
              jsonData[0].forEach((key, value) {
                kolonlar.add(DataColumn(label: Text(key)));
              });
              for (int i = 0; i < jsonData.length; i++) {
                jsonData[i].forEach((key, value) {
                  satirlar.add(value.toString());
                });
              }
            }
          } catch (e) {
            print(e);
          }

          print(kolonlar.length);
          print(satirlar.length);

          return [satirlar, kolonlar];
        }
      } else {
        Exception(
            'Satis Fatura Rapor Alınamadı. StatusCode: ${response.statusCode}');

        return [
          ['Satis Fatura Rapor Alınamadı. StatusCode: ${response.statusCode}'],
          []
        ];
      }
    } catch (e) {
      Exception('Hata: $e');

      return [
        [
          "Satis Fatura Rapor için Webservisten veri çekilemedi. Hata Mesajı : " +
              e.toString()
        ],
        []
      ];
    }
  }

  Future<List<List<dynamic>>> getirFaturaDetayRapor({
    required String sirket,
    required String faturaID,
  }) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/RaporFaturaListesiDetay'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <RaporFaturaListesiDetay xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Fatura>$faturaID</Fatura>
    </RaporFaturaListesiDetay>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return [
            [gelenHata.HataMesaj],
            []
          ];
        } else {
          List<DataColumn> kolonlar = [];
          List<String> satirlar = [];

          if (gelenHata.Hata == "false" && gelenHata.HataMesaj == "") {
            return [
              ["Veri Bulunamadı"],
              []
            ];
          }

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));

          try {
            if (jsonData.isNotEmpty) {
              jsonData[0].forEach((key, value) {
                kolonlar.add(DataColumn(label: Text(key)));
              });
              for (int i = 0; i < jsonData.length; i++) {
                jsonData[i].forEach((key, value) {
                  satirlar.add(value.toString());
                });
              }
            }
          } catch (e) {
            print(e);
          }

          print(kolonlar.length);
          print(satirlar.length);

          return [satirlar, kolonlar];
        }
      } else {
        Exception(
            'Fatura Detay Rapor Alınamadı. StatusCode: ${response.statusCode}');

        return [
          ['Fatura Detay Rapor  Alınamadı. StatusCode: ${response.statusCode}'],
          []
        ];
      }
    } catch (e) {
      Exception('Hata: $e');

      return [
        [
          "Fatura Detay Rapor  için Webservisten veri çekilemedi. Hata Mesajı : " +
              e.toString()
        ],
        []
      ];
    }
  }
}
