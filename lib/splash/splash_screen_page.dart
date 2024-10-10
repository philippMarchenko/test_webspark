import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/splash/splash_view_model.dart';
import 'package:test_webspark/start/start_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);
  static const routeName = '/splash_screen_page';

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late SplashViewModel vm;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // Add this

    SchedulerBinding.instance?.addPostFrameCallback((_) async {
      Future.wait([
        getDelay(),
        vm.init(),
      ]).then((value) {
        Navigator.pushNamed(context, StartPage.routeName);
      });
    });
  }

  Future getDelay() {
    return Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    vm = Provider.of<SplashViewModel>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      home: Container(
          width: 250.0,
          child: Image.asset(
            "images/logo.png",
          )),
    );
  }
}
