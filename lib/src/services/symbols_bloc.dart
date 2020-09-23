import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/models/stock_symbol.dart';
export 'package:stock_tracker/src/models/stock_symbol.dart';

class SymbolsBloc {
  String _apiKey = kApiKey;
  String _url = kUrl;

  List<StockSymbol> stockSymbols = [];

  final _symbolsStreamController =
      StreamController<List<StockSymbol>>.broadcast();
  Function(List<StockSymbol>) get symbolsSink =>
      _symbolsStreamController.sink.add;
  Stream<List<StockSymbol>> get symbolsStream =>
      _symbolsStreamController.stream;

  void dispose() {
    _symbolsStreamController?.close();
  }

  Future<List<StockSymbol>> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final symbols = stockSymbolFromJson(resp.body);

    return symbols;
  }

  Future<List<StockSymbol>> getStockSymbols() async {
    final url = Uri.https(_url, '/api/v1/stock/symbol', {
      'exchange': 'US',
      'token': _apiKey,
    });

    final resp = await _processResponse(url);

    stockSymbols.addAll(resp);
    symbolsSink(stockSymbols);
    return resp;
  }
}
