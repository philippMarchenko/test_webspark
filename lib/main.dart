import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/process/process_view_model.dart';
import 'package:test_webspark/result/result_view_model.dart';
import 'package:test_webspark/result/result_details_page.dart';
import 'package:test_webspark/result/result_list_page.dart';
import 'package:test_webspark/splash/splash_screen_page.dart';
import 'package:test_webspark/splash/splash_view_model.dart';
import 'package:test_webspark/start/start_page.dart';
import 'package:test_webspark/start/start_view_model.dart';

import 'di/service_locator.dart';
import 'process/process_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator().then((e){
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Container(),
      routes: {
        SplashScreenPage.routeName: (context) => ChangeNotifierProvider(
          create: (context) => SplashViewModel(),
          child: const SplashScreenPage(),
        ),
        StartPage.routeName: (context) => ChangeNotifierProvider(
          create: (context) => StartPageViewModel(),
          child: const StartPage(),
        ),
        ProcessPage.routeName: (context) => ChangeNotifierProvider(
          create: (context) => ProcessViewModel(),
          child: const ProcessPage(),
        ),
        ResultListPage.routeName: (context) => ChangeNotifierProvider(
          create: (context) => ResultViewModel(),
          child: const ResultListPage(),
        ),
        ResultDetailsPage.routeName: (context) => ChangeNotifierProvider(
          create: (context) => ResultViewModel(),
          child: const ResultDetailsPage(),
        ),
      },
      initialRoute: SplashScreenPage.routeName,
    );
  }
}


