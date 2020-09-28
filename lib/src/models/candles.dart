// To parse this JSON data, do
//
//     final stockCandles = stockCandlesFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Candle {
  Candle({
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

Candles stockCandlesFromJson(String str) => Candles.fromJson(json.decode(str));

String stockCandlesToJson(Candles data) => json.encode(data.toJson());

class Candles {
  Candles(
    this._closes,
    this._highs,
    this._lows,
    this._opens,
    this._timestamps,
    this._volumes,
  );

  // List of all data structured in StockCandle objects.
  List<Candle> candles;

  // Data of all prices.
  List<double> _closes;
  List<double> _highs;
  List<double> _lows;
  List<double> _opens;
  List<int> _timestamps; // In seconds.
  List<int> _volumes;

  factory Candles.fromJson(Map<String, dynamic> json) {
    final stock = Candles(
      List<double>.from(json["c"].map((x) => x.toDouble())),
      List<double>.from(json["h"].map((x) => x.toDouble())),
      List<double>.from(json["l"].map((x) => x.toDouble())),
      List<double>.from(json["o"].map((x) => x.toDouble())),
      List<int>.from(json["t"].map((x) => x)),
      List<int>.from(json["v"].map((x) => x)),
    );
    // Save stock data "unreversed" to show it from newest to oldest data.
    stock.candles = _getCandles(stock);

    return stock;
  }

  factory Candles.fromMap(Map<String, dynamic> map) {
    List<double> closes =
        List.castFrom<dynamic, double>(map['closes']).toList();
    List<double> highs = List.castFrom<dynamic, double>(map['highs']).toList();
    List<double> lows = List.castFrom<dynamic, double>(map['lows']).toList();
    List<double> opens = List.castFrom<dynamic, double>(map['opens']).toList();
    List<int> volumes = List.castFrom<dynamic, int>(map['volumes']).toList();
    List timestamps = map['timestamps'];

    final stock = Candles(
      closes,
      highs,
      lows,
      opens,
      timestamps
          .map<int>((e) => (e.millisecondsSinceEpoch ~/ 1000).toInt())
          .toList(),
      volumes,
    );
    // // Save stock data "unreversed" to show it from newest to oldest data.
    stock.candles = _getCandles(stock);

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

  Map<String, dynamic> toMap() => {
        "closes": _closes,
        "highs": _highs,
        "lows": _lows,
        "opens": _opens,
        "timestamps": _timestamps
            .map((e) => Timestamp.fromMillisecondsSinceEpoch(e * 1000))
            .toList(),
        "volumes": _volumes,
      };

  static List<Candle> _getCandles(Candles stock) {
    // Auxiliar reversed list.
    List<Candle> reversedList = [];

    // Populate auxiliar list.
    for (var i = 0; i < stock._closes.length; i++) {
      final stockData = Candle(
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

    return List.from(reversedList.reversed);
  }
}
