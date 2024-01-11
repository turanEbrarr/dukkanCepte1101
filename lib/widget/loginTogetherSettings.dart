import 'package:flutter/material.dart';
import '../widget/login2.dart';
import '../widget/settings_page.dart';

class loginTogetherSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resim Kaydırma Uygulaması',
      home: Scaffold(
        body: PageView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return LoginPage(title: '',);
            } else if (index == 1) {
              return settings_page();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
