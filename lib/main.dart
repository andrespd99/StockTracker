import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/pages/home.dart';

import 'package:stock_tracker/src/services/candles_bloc.dart';
import 'package:stock_tracker/src/services/symbols_bloc.dart';
import 'package:stock_tracker/src/services/company_profile_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //TO-DO: Implement error screen.
          // if (snapshot.hasError) {
          //   return SomethingWentWrong();
          // }

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
                  headline1: textTheme.headline1.copyWith(color: Colors.white),
                  headline2: textTheme.headline2.copyWith(color: Colors.white),
                  headline3: textTheme.headline3.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  headline4: textTheme.headline4.copyWith(color: Colors.white),
                  headline5: textTheme.headline5.copyWith(color: Colors.white),
                  headline6: textTheme.headline6.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w300),
                ),
                // Headlines
              ),
              title: 'Stocks App',
              home: Material(child: HomePage()),
            ),
          );
        }
        //TO-DO:  Implement loading function
        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Container(
          // width: MediaQuery.of(context).size.width,
          color: kPrimaryColor,
          alignment: Alignment.center,
          child: Center(
            child: Text(
              'Stock Tracker',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.roboto().fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
