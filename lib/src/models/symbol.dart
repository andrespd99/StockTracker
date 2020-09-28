// To parse this JSON data, do
//
//     final stockSymbol = stockSymbolFromJson(jsonString);

import 'dart:convert';

List<Symbol> stockSymbolFromJson(String str) =>
    List<Symbol>.from(json.decode(str).map((x) => Symbol.fromJson(x)));

String stockSymbolToJson(List<Symbol> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Symbol {
  Symbol({
    this.currency,
    this.description,
    this.displaySymbol,
    this.symbol,
    this.type,
  });

  Currency currency;
  String description;
  String displaySymbol;
  String symbol;
  Type type;

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        currency: currencyValues.map[json["currency"]],
        description: json["description"],
        displaySymbol: json["displaySymbol"],
        symbol: json["symbol"],
        type: typeValues.map[json["type"]],
      );

  Map<String, dynamic> toJson() => {
        "currency": currencyValues.reverse[currency],
        "description": description,
        "displaySymbol": displaySymbol,
        "symbol": symbol,
        "type": typeValues.reverse[type],
      };
}

enum Currency { USD, EMPTY }

final currencyValues = EnumValues({"": Currency.EMPTY, "USD": Currency.USD});

enum Type { EQS, ETF, DR, EMPTY, UNT, STP, WAR, PRF, BND, TRT, SP, PFS }

final typeValues = EnumValues({
  "BND": Type.BND,
  "DR": Type.DR,
  "": Type.EMPTY,
  "EQS": Type.EQS,
  "ETF": Type.ETF,
  "PFS": Type.PFS,
  "PRF": Type.PRF,
  "SP": Type.SP,
  "STP": Type.STP,
  "TRT": Type.TRT,
  "UNT": Type.UNT,
  "WAR": Type.WAR
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
