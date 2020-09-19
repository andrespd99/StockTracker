// To parse this JSON data, do
//
//     final stockCandles = stockCandlesFromJson(jsonString);

import 'dart:convert';

StockCandles stockCandlesFromJson(String str) =>
    StockCandles.fromJson(json.decode(str));

String stockCandlesToJson(StockCandles data) => json.encode(data.toJson());

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

  factory StockCandles.fromJson(Map<String, dynamic> json) => StockCandles(
        closes: List<double>.from(json["closes"].map((x) => x.toDouble())),
        highs: List<double>.from(json["highs"].map((x) => x.toDouble())),
        lows: List<double>.from(json["lows"].map((x) => x.toDouble())),
        opens: List<double>.from(json["opens"].map((x) => x.toDouble())),
        timestamps: List<int>.from(json["timestamps"].map((x) => x)),
        volumes: List<int>.from(json["volumes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "closes": List<dynamic>.from(closes.map((x) => x)),
        "highs": List<dynamic>.from(highs.map((x) => x)),
        "lows": List<dynamic>.from(lows.map((x) => x)),
        "opens": List<dynamic>.from(opens.map((x) => x)),
        "timestamps": List<dynamic>.from(timestamps.map((x) => x)),
        "volumes": List<dynamic>.from(volumes.map((x) => x)),
      };
}
