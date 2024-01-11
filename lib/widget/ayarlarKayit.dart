import 'package:shared_preferences/shared_preferences.dart';

class Ayarlar {
  static final String _beniHatirlaKey = 'beniHatirla';
  static final String _parolaKey = 'parola';

static Future<bool> beniHatirlaGet () async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_beniHatirlaKey) ?? false;
}

static Future<void>beniHatirlaSet (bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_beniHatirlaKey, value);
}


//kullanıcının giriş bilgilerini kaydeder
  Future<void> parolaKaydet( String parola) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_parolaKey, parola);
  }

//kullanıcının giriş bilgilierini yükler
Future<String?> parolaYukle() async{
  final prefs = await SharedPreferences.getInstance();
 return prefs.getString(_parolaKey);

}

}