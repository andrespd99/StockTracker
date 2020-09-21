// To parse this JSON data, do
//
//     final stockCandles = stockCandlesFromJson(jsonString);

import 'dart:convert';

class StockCandle {
  StockCandle({
    this.close,
    this.high,
    this.low,
    this.open,
    this.timestamp,
    this.volume,
  });

  double close;
  double high;
  double low;
  double open;
  int timestamp;
  int volume;
  double pctOfChange = 0.0;
}

StockCandles stockCandlesFromJson(String str) =>
    StockCandles.fromJson(json.decode(str));

String stockCandlesToJson(StockCandles data) => json.encode(data.toJson());

class StockCandles {
  StockCandles(
    this._closes,
    this._highs,
    this._lows,
    this._opens,
    this._timestamps,
    this._volumes,
  );

  // List of all data structured in StockCandle objects.
  List<StockCandle> quotes;

  // Data of all prices.
  List<double> _closes;
  List<double> _highs;
  List<double> _lows;
  List<double> _opens;
  List<int> _timestamps;
  List<int> _volumes;

  factory StockCandles.fromJson(Map<String, dynamic> json) {
    final stock = StockCandles(
      List<double>.from(json["c"].map((x) => x.toDouble())),
      List<double>.from(json["h"].map((x) => x.toDouble())),
      List<double>.from(json["l"].map((x) => x.toDouble())),
      List<double>.from(json["o"].map((x) => x.toDouble())),
      List<int>.from(json["t"].map((x) => x)),
      List<int>.from(json["v"].map((x) => x)),
    );

    // Auxiliar reversed list.
    List<StockCandle> reversedList = [];

    // Populate auxiliar list.
    for (var i = 0; i < stock._closes.length; i++) {
      final stockData = StockCandle(
        close: stock._closes[i],
        high: stock._highs[i],
        low: stock._lows[i],
        open: stock._opens[i],
        timestamp: stock._timestamps[i],
        volume: stock._volumes[i],
      );
      reversedList.add(stockData);
      if (i > 0) {
        final p1 = reversedList[i - 1].close;
        final p2 = reversedList[i].close;
        reversedList[i].pctOfChange = 100 * (p2 - p1) / p1;
      }
    }

    // Save stock data "unreversed" to show it from newest to oldest data.
    stock.quotes = new List.from(reversedList.reversed);

    return stock;
  }

  Map<String, dynamic> toJson() => {
        "c": List<dynamic>.from(_closes.map((x) => x)),
        "h": List<dynamic>.from(_highs.map((x) => x)),
        "l": List<dynamic>.from(_lows.map((x) => x)),
        "o": List<dynamic>.from(_opens.map((x) => x)),
        "t": List<dynamic>.from(_timestamps.map((x) => x)),
        "v": List<dynamic>.from(_volumes.map((x) => x)),
      };
}
