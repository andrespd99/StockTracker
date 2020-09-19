// To parse this JSON data, do
//
//     final quote = quoteFromJson(jsonString);

import 'dart:convert';

Quote quoteFromJson(String str) => Quote.fromJson(json.decode(str));

String quoteToJson(Quote data) => json.encode(data.toJson());

class Quote {
  Quote({
    this.currentPrice,
    this.high,
    this.low,
    this.open,
    this.previousClose,
    this.t,
  });

  double currentPrice;
  double high;
  double low;
  double open;
  double previousClose;
  int t;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        currentPrice: json["current_price"].toDouble(),
        high: json["high"].toDouble(),
        low: json["low"].toDouble(),
        open: json["open"].toDouble(),
        previousClose: json["previous_close"].toDouble(),
        t: json["t"],
      );

  Map<String, dynamic> toJson() => {
        "current_price": currentPrice,
        "high": high,
        "low": low,
        "open": open,
        "previous_close": previousClose,
        "t": t,
      };
}
