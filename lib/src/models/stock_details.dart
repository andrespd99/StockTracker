import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stock_tracker/src/models/stock_candles.dart';
import 'package:stock_tracker/src/models/company_profile.dart';

class StockDetails {
  StockDetails({
    this.candles,
    this.profile,
    this.currency,
    this.description,
    this.displaySymbol,
    this.latestUpdate,
    this.symbol,
    this.type,
  });

  StockCandles candles;
  CompanyProfile profile;
  String currency;
  String description;
  String displaySymbol;
  DateTime latestUpdate;
  String symbol;
  String type;

  // factory StockDetails.fromSnapshot(DocumentSnapshot snapshot) => StockDetails(
  //       candles: StockCandles.fromMap(snapshot.data()['candles']),
  //       profile: CompanyProfile.fromMap(snapshot.data()['companyProfile']),
  //       currency: snapshot.data()['currency'],
  //       description: snapshot.data()['description'],
  //       displaySymbol: snapshot.data()['displaySymbol'],
  //       latestUpdate: snapshot.data()['latestUpdate'].toDate(),
  //       symbol: snapshot.data()['symbol'],
  //       type: snapshot.data()['type'],
  //     );
}
