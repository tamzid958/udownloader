import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:udownloader/src/layout/home.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U Downloader',
      theme: ThemeData(
        accentColor: kPrimaryColor,
        canvasColor: kOptionalColor,
        appBarTheme: AppBarTheme(color: kPrimaryColor),
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
