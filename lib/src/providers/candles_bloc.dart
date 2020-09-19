import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/models/stock_candles.dart';
export 'package:stock_tracker/src/models/stock_candles.dart';

class CandlesBloc {
  String _apiKey = kApiKey;
  String _url = kUrl;

  bool _loading = false;

  // List<StockCandles> _stockCandles = [];
  List<StockCandles> _stockCandles = [];

  final _candlesStreamController =
      StreamController<List<StockCandles>>.broadcast();
  Function(List<StockCandles>) get candlesSink =>
      _candlesStreamController.sink.add;
  Stream<List<StockCandles>> get candlesStream =>
      _candlesStreamController.stream;

  void dispose() {
    _candlesStreamController?.close();
  }

  // Process the response of URL results.
  Future<StockCandles> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final candles = stockCandlesFromJson(resp.body);

    return candles;
  }

  // Get daily data from today to X days back of a stock.
  Future<StockCandles> getStockCandles(String symbol) async {
    if (_loading) return null;

    _loading = true;

    // Construct the API's URL link.
    final url = Uri.https(_url, '/api/v1/stock/candle', {
      'symbol': symbol,
      'resolution': 'D', // D to get data in days.
      'from': getXDaysBackToUnix(5).toString(),
      'to': getTodayDateToUnix().toString(),
      'token': _apiKey,
    });

    // Process URL and convert the results to an Object.
    final resp = await _processResponse(url);

    // Cache results in a list.
    _stockCandles.add(resp);
    // Sink results to the stream.
    candlesSink(_stockCandles);

    _loading = false;
    return resp;
  }

  // Get X days back in UNIX datetime,
  int getXDaysBackToUnix(int i) {
    final iDaysBack =
        DateTime.now().subtract(Duration(days: 5)).millisecondsSinceEpoch /
            1000;
    return iDaysBack.toInt();
  }

  // Get todays date in UNIX datetime.
  int getTodayDateToUnix() {
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    return now.toInt();
  }
}
