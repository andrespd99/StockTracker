import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_tracker/src/pages/index_page.dart';

import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/services/stocks/candles_bloc.dart';
import 'package:stock_tracker/src/services/stocks/search.dart';
import 'package:stock_tracker/src/services/stocks/stocks_bloc.dart';
import 'package:stock_tracker/src/services/stocks/symbols_bloc.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';
import 'package:stock_tracker/src/services/login/login_form_bloc.dart';
import 'package:stock_tracker/src/services/login/signup_form_bloc.dart';

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
              Provider<StocksBloc>(create: (_) => StocksBloc()),
              Provider<SymbolsBloc>(create: (_) => SymbolsBloc()),
              Provider<CandlesBloc>(create: (_) => CandlesBloc()),
              Provider<LoginFormBloc>(create: (_) => LoginFormBloc()),
              Provider<SignupFormBloc>(create: (_) => SignupFormBloc()),
              Provider<SearchAlgolia>(create: (_) => SearchAlgolia()),
              Provider<AuthBloc>(create: (_) => AuthBloc()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                cupertinoOverrideTheme: CupertinoThemeData(
                  primaryColor: kPrimaryColor,
                ),
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.white),
                  brightness: Brightness.dark,
                  elevation: 0.0,
                  color: kSecondaryColor,
                ),
                cursorColor: kPrimaryColor,
                buttonTheme: ButtonThemeData(
                  buttonColor: kPrimaryColor,
                  textTheme: ButtonTextTheme.primary,
                ),
                // Colors
                brightness: Brightness.dark,
                primaryColor: kSecondaryColor,
                accentColor: kPrimaryColor,
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
              home: Material(child: IndexPage()),
              routes: {
                'auth': (BuildContext context) => IndexPage(),
              },
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kSecondaryColor, kPrimaryColor],
          )),
          alignment: Alignment.center,
          child: Center(
            child: Text(''),
          ),
        ),
      ),
    );
  }
}
