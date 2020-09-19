// To parse this JSON data, do
//
//     final stockCandles = stockCandlesFromJson(jsonString);

import 'dart:convert';

StockCandles stockCandlesFromJson(String str) =>
    StockCandles.fromJson(json.decode(str));

String stockCandlesToJson(StockCandles data) => json.encode(data.toJson());

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
  double percentageOfChange = 0.0;
}

class StockCandles {
  StockCandles({
    this.closes,
    this.highs,
    this.lows,
    this.opens,
    this.timestamps,
    this.volumes,
  });

  List<double> closes;
  List<double> highs;
  List<double> lows;
  List<double> opens;
  List<int> timestamps;
  List<int> volumes;
  List<StockCandle> quotes;

  factory StockCandles.fromJson(Map<String, dynamic> json) {
    final stock = StockCandles(
      closes: List<double>.from(json["c"].map((x) => x.toDouble())),
      highs: List<double>.from(json["h"].map((x) => x.toDouble())),
      lows: List<double>.from(json["l"].map((x) => x.toDouble())),
      opens: List<double>.from(json["o"].map((x) => x.toDouble())),
      timestamps: List<int>.from(json["t"].map((x) => x)),
      volumes: List<int>.from(json["v"].map((x) => x)),
    );

    // Auxiliar reversed list.
    List<StockCandle> reversedList = [];

    // Populate auxiliar list.
    for (var i = 0; i < stock.closes.length; i++) {
      final stockData = StockCandle(
        close: stock.closes[i],
        high: stock.highs[i],
        low: stock.lows[i],
        open: stock.opens[i],
        timestamp: stock.timestamps[i],
        volume: stock.volumes[i],
      );
      reversedList.add(stockData);
      if (i > 0) {
        final p1 = reversedList[i - 1].close;
        final p2 = reversedList[i].close;
        reversedList[i].percentageOfChange = 100 * (p2 - p1) / p1;
      }
    }

    // Save stock data "unreversed" to show it from newest to oldest data.
    stock.quotes = new List.from(reversedList.reversed);

    return stock;
  }

  Map<String, dynamic> toJson() => {
        "c": List<dynamic>.from(closes.map((x) => x)),
        "h": List<dynamic>.from(highs.map((x) => x)),
        "l": List<dynamic>.from(lows.map((x) => x)),
        "o": List<dynamic>.from(opens.map((x) => x)),
        "t": List<dynamic>.from(timestamps.map((x) => x)),
        "v": List<dynamic>.from(volumes.map((x) => x)),
      };
}
