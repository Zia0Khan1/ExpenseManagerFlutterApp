import 'package:expensemanager/pages/splash.dart';
import 'package:expensemanager/static.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  await Hive.initFlutter();
  await Hive.openBox('money');

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Expense Manager',
      // darkTheme: ThemeData.dark(),
      theme: myTheme,
      home: const Splash(),
    );
  }

}

