import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:stock_tracker/src/pages/home.dart';
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/services/candles_bloc.dart';
import 'package:stock_tracker/src/services/company_profile_bloc.dart';
import 'package:stock_tracker/src/services/symbols_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MultiProvider(
      providers: [
        Provider<SymbolsBloc>(create: (_) => SymbolsBloc()),
        Provider<CompanyProfileBloc>(create: (_) => CompanyProfileBloc()),
        Provider<CandlesBloc>(create: (_) => CandlesBloc()),
      ],
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
