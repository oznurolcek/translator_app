import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/core/init/lang/locale_keys.g.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LocaleKeys.history.tr()),
        backgroundColor: Color(0xFFFBADAFF),
      ),
    );
  }
}