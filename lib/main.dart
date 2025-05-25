import 'package:device_preview/device_preview.dart';
import 'package:eventsolutions/services/token_storage.dart';
import 'package:eventsolutions/view/home_page.dart';

import 'package:eventsolutions/view/loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(DevicePreview(
      enabled: kDebugMode,
      builder: (BuildContext context) => ProviderScope(child: Home())));
  // runApp(ProviderScope(child: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  Future<bool?> isLoggedIn() async {
    final token = await TokenStorage().getAccessToken();
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Color(0xffF4F4F4),
          appBarTheme: AppBarTheme(color: Color(0xffF4F4F4))),
      home: FutureBuilder(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return HomePage();
            }
            return LoginPage();
          }),

      // home: HomePage(),
    );
  }
}
