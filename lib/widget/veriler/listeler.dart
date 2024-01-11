import 'package:dukkan_cepte/faturaFis/fisEkParam.dart';
import 'package:dukkan_cepte/stok_kart/stokDepoMode.dart';

import '../../faturaFis/fis.dart';
import '../../webservis/kurModel.dart';
import '../../stok_kart/stok_tanim.dart';
import '../cari.dart';
import '../cariAltHesap.dart';
import '../../Depo Transfer/subeDepoModel.dart';

import '../modeller/logModel.dart';
import '../modeller/olcuBirimModel.dart';
import '../modeller/rafModel.dart';
import '../../webservis/kullaniciYetki.dart';
import '../../webservis/bankaModel.dart';
import '../../webservis/bankaSozlesmeModel.dart';



class listeler {
  static List<StokKart> liststok = [];
  static List<StokKart> listlocalstok = [];
  static List<Cari> listCari = [];
  static List<Fis> listFis = [];
  static List<bool> sayfaDurum = [];
  static List<KurModel> listKur = [];
  static List<CariAltHesap> listCariAltHesap = [];
  static List<SubeDepoModel> listSubeDepoModel = [];
 
  static List<LogModel> listLog = [];
  static List<OlcuBirimModel> listOlcuBirim = [];
  static List<RafModel> listRaf = [];
  static List<KullaniciYetki> yetki = [];
  static List<BankaModel> listBankaModel = [];
  static List<BankaSozlesmeModel> listBankaSozlesmeModel = [];

  static List<StokDepoModel> listStokDepo = [];
  static List<FisEkParam> listFisEkParam = [];
  static List<int> listFisEkParamZorunluID = [];
  static List<bool> plasiyerYetkileri = [
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
    false,
    false,
    false
  ];
  static bool ust = false;
  //
  // static List<DepoModel> depolar = [DepoModel(1, "Merkez"),DepoModel(2, "Selçuklu")];
  //
}
