import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/models/candles.dart';
export 'package:stock_tracker/src/models/candles.dart';

class CandlesBloc {
  String _apiKey = kApiKey;
  String _url = kUrl;

  bool _loading = false;

  // List<StockCandles> _stockCandles = [];
  List<Candles> _stockCandles = [];

  final _candlesStreamController = StreamController<Candles>.broadcast();
  Function(Candles) get candlesSink => _candlesStreamController.sink.add;
  Stream<Candles> get candlesStream => _candlesStreamController.stream;

  void dispose() {
    _candlesStreamController?.close();
  }

  // Process the response of URL results.
  Future<dynamic> _processResponse(Uri url) async {
    final resp = await http.get(url);
    if (resp.body == 'You don\'t have access to this resource.') return false;
    final candles = stockCandlesFromJson(resp.body);

    return candles;
  }

  // Get daily data from today to X days back of a stock.
  Future<dynamic> getStockCandles(String symbol) async {
    // Construct the API's URL link.
    final url = Uri.https(_url, '/api/v1/stock/candle', {
      'symbol': symbol,
      'resolution': 'D', // D to get data in days.
      'from': getXDaysBackToUnix(kQuotesRange * 2).toString(),
      'to': getTodayDateToUnix().toString(),
      'token': _apiKey,
    });

    // Process URL and convert the results to an Object.
    final resp = await _processResponse(url);

    // Cache results in a list.
    if (resp.runtimeType == bool) {
      return false;
    }
    _stockCandles.add(resp);
    // Sink results to the stream.
    candlesSink(resp);

    return resp;
  }

  // Get X days back in UNIX datetime,
  int getXDaysBackToUnix(int i) {
    final iDaysBack =
        DateTime.now().subtract(Duration(days: i)).millisecondsSinceEpoch /
            1000;
    return iDaysBack.toInt();
  }

  // Get todays date in UNIX datetime.
  int getTodayDateToUnix() {
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    return now.toInt();
  }
}
