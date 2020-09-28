import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/models/symbol.dart';
export 'package:stock_tracker/src/models/symbol.dart';

class SymbolsBloc {
  String _apiKey = kApiKey;
  String _url = kUrl;

  List<Symbol> stockSymbols = [];

  final _symbolsStreamController = StreamController<List<Symbol>>.broadcast();
  Function(List<Symbol>) get symbolsSink => _symbolsStreamController.sink.add;
  Stream<List<Symbol>> get symbolsStream => _symbolsStreamController.stream;

  void dispose() {
    _symbolsStreamController?.close();
  }

  Future<List<Symbol>> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final symbols = stockSymbolFromJson(resp.body);

    return symbols;
  }

  Future<List<Symbol>> getStockSymbols() async {
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
