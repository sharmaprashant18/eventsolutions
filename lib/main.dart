// ignore_for_file: use_build_context_synchronously

import 'package:eventsolutions/provider/auth_provider/auth_status_provider.dart';
import 'package:eventsolutions/services/token_storage.dart';
import 'package:eventsolutions/view/home_page.dart';

import 'package:eventsolutions/view/loginpage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // runApp(DevicePreview(
  //     enabled: kDebugMode,
  //     builder: (BuildContext context) => ProviderScope(child: Home())));
  runApp(ProviderScope(child: Home()));
}

class Home extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStatusProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Color(0xffF4F4F4),
          appBarTheme: AppBarTheme(color: Color(0xffF4F4F4))),
      // home: FutureBuilder(
      //     future: isLoggedIn(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Scaffold(
      //           body: Center(child: CircularProgressIndicator()),
      //         );
      //       }
      //       if (snapshot.hasData && snapshot.data == true) {
      //         return HomePage();
      //       }
      //       return LoginPage();
      //     }),
      home: authStatus.when(
        data: (isLoggedIn) => isLoggedIn ? HomePage() : LoginPage(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          body: Center(child: Text("Error: $err")),
        ),
      ),
    );
  }
}
