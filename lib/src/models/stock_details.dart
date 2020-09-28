import 'package:stock_tracker/src/models/candles.dart';

class StockDetails {
  StockDetails({
    this.candles,
    this.currency,
    this.description,
    this.displaySymbol,
    this.latestUpdate,
    this.symbol,
    this.type,
  }) {
    double p1 = candles.candles[4].close; // Closing price 5 days ago.
    double p2 = candles.candles[0].close; // Last closing price.
    this.pctChange5 = 100 * (p2 - p1) / p1;
  }

  Candles candles;
  String currency;
  String description;
  String displaySymbol;
  DateTime latestUpdate;
  String symbol;
  String type;
  double pctChange5; //Percentage of change in last 5 days.

}
