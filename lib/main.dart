import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/view/home_view.dart';

Future<void> main() async {

  await _init();

  runApp(EasyLocalization(
      supportedLocales: const [Locale("en", "US")],
      path: "assets/lang",
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      home: Home(),
    );
  }
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}
