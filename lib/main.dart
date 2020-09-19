import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stock_tracker/src/providers/provider.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:stock_tracker/src/pages/home.dart';
import 'package:stock_tracker/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Colors
          brightness: Brightness.dark,
          primaryColor: kPrimaryColor,
          accentColor: kSecondaryColor,
          // Fonts
          textTheme: TextTheme(
            // Headlines
            headline1: textTheme.headline1.copyWith(color: Colors.white),
            headline2: textTheme.headline2.copyWith(color: Colors.white),
            headline3: textTheme.headline3
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            headline4: textTheme.headline4.copyWith(color: Colors.white),
            headline5: textTheme.headline5.copyWith(color: Colors.white),
            headline6: textTheme.headline6
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w300),
          ),
        ),
        title: 'Stocks App',
        home: Material(child: HomePage()),
      ),
    );
  }
}
