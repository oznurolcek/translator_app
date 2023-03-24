import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/init/lang/locale_keys.g.dart';
import 'package:translation_app/view/history_view.dart';
import 'package:translator/translator.dart';

import '../core/components/button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController fromText = TextEditingController();
  TextEditingController toText = TextEditingController();
  String? _dropDownValue;

  GoogleTranslator translator = GoogleTranslator();

  String? languageCode;

  String translatedText = "";

  final items = [
    "Turkish",
    "English",
    "Spanish",
    "French",
    "Italian",
    "German"
  ];

  void translate(locale) {
    translator.translate(fromText.text, to: locale).then((output) async {
      setState(() {
        toText.text = output.toString();
      });
      translatedText = toText.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString("text");
    });
  }

  void clearText() {
    fromText.clear();
    toText.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Translate App'),
        centerTitle: true,
        backgroundColor: Color(0xFFFBADAFF),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => History()));},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: buildDropDownMenu(),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        textToBeTranslatedCard(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                            buildClearButton(context),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                            buildTranslateButton(context),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        translatedTextCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildDropDownMenu() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFFBADAFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        hint: _dropDownValue == null
            ? Text(
                LocaleKeys.select_language.tr(),
                style: TextStyle(color: Colors.white),
              )
            : Text(
                _dropDownValue!,
                style: TextStyle(color: Colors.white),
              ),
        items: items.map(buildMenuItem).toList(),
        onChanged: (newValue) {
          setState(() {
            _dropDownValue = newValue;
          });
          if (_dropDownValue == "Turkish") {
            languageCode = 'tr';
          } else if (_dropDownValue == "English") {
            languageCode = 'en';
          } else if (_dropDownValue == "Spanish") {
            languageCode = 'es';
          } else if (_dropDownValue == "French") {
            languageCode = 'fr';
          } else if (_dropDownValue == "Italian") {
            languageCode = 'it';
          } else if (_dropDownValue == "German") {
            languageCode = 'de';
          }
        },
        style: TextStyle(color: Colors.white),
        dropdownColor: Color(0xFFFBADAFF),
      ),
    );
  }

  Card textToBeTranslatedCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Color(0xFFFBADAFF),
      elevation: 20,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: fromText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintText: LocaleKeys.enter_text.tr(),
                    ),
                    minLines: 4,
                    maxLines: null,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Button buildClearButton(BuildContext context) {
    return Button(
      color: Color(0xFFFBADAFF),
      press: () {
        clearText();
      },
      text: LocaleKeys.clear.tr(),
    );
  }

  Button buildTranslateButton(BuildContext context) {
    return Button(
      color: Color(0xFFFBADAFF),
      press: () {
        translate(languageCode);
      },
      text: LocaleKeys.translate.tr(),
    );
  }

  Card translatedTextCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Color(0xFFFBADAFF),
      elevation: 20,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    enabled: false,
                    controller: toText,
                    decoration: InputDecoration(border: InputBorder.none),
                    maxLines: null,
                  ),
                ),
                buildCopyButton(),
                buildShareButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildShareButton() {
    return IconButton(
      onPressed: () async {
        await Share.share(toText.text);
      },
      icon: Icon(Icons.share),
      iconSize: 20,
    );
  }

  IconButton buildCopyButton() {
    return IconButton(
      onPressed: () async {
        await FlutterClipboard.copy(toText.text);
        Fluttertoast.showToast(
            msg: LocaleKeys.copied_toast_message.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xFFFBADAFF),
            textColor: Colors.white);
      },
      icon: Icon(Icons.copy),
      iconSize: 20,
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );
}
