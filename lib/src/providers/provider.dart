import 'package:flutter/material.dart';

import 'package:stock_tracker/src/providers/symbols_bloc.dart';
export 'package:stock_tracker/src/providers/symbols_bloc.dart';

class Provider extends InheritedWidget {
  final symbolsBloc = SymbolsBloc();

  Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().symbolsBloc;
  }
}
