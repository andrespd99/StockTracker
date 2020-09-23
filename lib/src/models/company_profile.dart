// To parse this JSON data, do
//
//     final companyProfile = companyProfileFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_tracker/src/models/stock_candles.dart';

CompanyProfile companyProfileFromJson(String str) =>
    CompanyProfile.fromJson(json.decode(str));

String companyProfileToJson(CompanyProfile data) => json.encode(data.toJson());

class CompanyProfile {
  CompanyProfile({
    this.country,
    this.currency,
    this.exchange,
    this.finnhubIndustry,
    this.ipo,
    this.logo,
    this.marketCapitalization,
    this.name,
    this.phone,
    this.shareOutstanding,
    this.ticker,
    this.weburl,
  });

  String country;
  String currency;
  String exchange;
  String finnhubIndustry;
  DateTime ipo;
  String logo;
  double marketCapitalization;
  String name;
  String phone;
  double shareOutstanding;
  String ticker;
  String weburl;

  factory CompanyProfile.fromJson(Map<String, dynamic> json) => CompanyProfile(
        country: json["country"],
        currency: json["currency"],
        exchange: json["exchange"],
        finnhubIndustry: json["finnhubIndustry"],
        ipo: DateTime.parse(json["ipo"]),
        logo: json["logo"],
        marketCapitalization: json["marketCapitalization"].toDouble(),
        name: json["name"],
        phone: json["phone"],
        shareOutstanding: json["shareOutstanding"].toDouble(),
        ticker: json["ticker"],
        weburl: json["weburl"],
      );

  factory CompanyProfile.fromMap(Map<String, dynamic> map) {
    String country = map['country'];
    String currency = map['currency'];
    String exchange = map['exchange'];
    String finnhubIndustry = map['finnhubIndustry'];
    DateTime ipo = map['ipo'].toDate();
    String logo = map['logo'];
    double marketCapitalization = map['marketCapitalization'].toDouble();
    String name = map['name'];
    String phone = map['phone'];
    double shareOutstanding = map['shareOutstanding'].toDouble();
    String ticker = map['ticker'];
    String weburl = map['weburl'];

    return CompanyProfile(
      country: country,
      currency: currency,
      exchange: exchange,
      finnhubIndustry: finnhubIndustry,
      ipo: ipo,
      logo: logo,
      marketCapitalization: marketCapitalization,
      name: name,
      phone: phone,
      shareOutstanding: shareOutstanding,
      ticker: ticker,
      weburl: weburl,
    );
  }

  Map<String, dynamic> toJson() => {
        "country": country,
        "currency": currency,
        "exchange": exchange,
        "finnhubIndustry": finnhubIndustry,
        "ipo":
            "${ipo.year.toString().padLeft(4, '0')}-${ipo.month.toString().padLeft(2, '0')}-${ipo.day.toString().padLeft(2, '0')}",
        "logo": logo,
        "marketCapitalization": marketCapitalization,
        "name": name,
        "phone": phone,
        "shareOutstanding": shareOutstanding,
        "ticker": ticker,
        "weburl": weburl,
      };

  Map<String, dynamic> toMap() => {
        "country": country,
        "currency": currency,
        "exchange": exchange,
        "finnhubIndustry": finnhubIndustry,
        "ipo": Timestamp.fromDate(ipo),
        "logo": logo,
        "marketCapitalization": marketCapitalization,
        "name": name,
        "phone": phone,
        "shareOutstanding": shareOutstanding,
        "ticker": ticker,
        "weburl": weburl,
      };
}
