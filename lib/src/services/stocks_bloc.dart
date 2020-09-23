import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_tracker/src/models/company_profile.dart';
import 'package:stock_tracker/src/models/stock_candles.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/services/candles_bloc.dart';
import 'package:stock_tracker/src/services/company_profile_bloc.dart';

class StocksBloc {
  final _detailsController = StreamController<StockDetails>.broadcast();
  final _allStocksController = StreamController<List<StockDetails>>.broadcast();

  Function(StockDetails) get detailsSink => _detailsController.add;
  Stream<StockDetails> get detailsStream => _detailsController.stream;

  Function(List<StockDetails>) get stocksSink => _allStocksController.add;
  Stream<List<StockDetails>> get stocksStream => _allStocksController.stream;

  List<StockDetails> stocks = [];

  void dispose() {
    _detailsController?.close();
    _allStocksController?.close();
  }

  Future<List<StockDetails>> getStocks(List<String> stocksList) async {
    for (var stockId in stocksList) {
      StockDetails stock = await getStock(stockId);
      stocks.add(stock);
    }
    stocksSink(stocks);
    return stocks;
  }

  Future<StockDetails> getStock(String stockId) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('symbols').doc(stockId);

    StockDetails stock; // New stock.
    Timestamp todaysTimestamp = Timestamp.now();
    Timestamp latestTimestamp;
    StockCandles latestCandles;
    CompanyProfile latestProfile;

    await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          // Save today's date and the last date document was updated.
          int now = daysInEpoch(todaysTimestamp);
          int previous;
          if (snapshot.data().containsKey('latestUpdate'))
            previous = daysInEpoch(snapshot.data()['latestUpdate']);

          /* Update information if:
          * - there is not 'latestUpdate' in document, which means it's never been filled.
          * - now date is different from previous date, meaning data is old.
          */
          if (!snapshot.data().containsKey('latestUpdate')) {
            previous = daysInEpoch(todaysTimestamp);
            print('Creating latestUpdate.');
            transaction
                .update(documentReference, {'latestUpdate': todaysTimestamp});
          }

          if (!snapshot.data().containsKey('candles') || now != previous) {
            print('Data is old or not in database. Retrieving from API...');
            // Get latest candles and profile from API.
            latestCandles = await CandlesBloc().getStockCandles(stockId);
            latestProfile = await CompanyProfileBloc().getCompany(stockId);
            // Save todays timestamp to mark stock as up to date.
            latestTimestamp = todaysTimestamp;
            // Update stock document.
            print('Updating document...');
            transaction.update(
              documentReference,
              {
                'profile': latestProfile.toMap(),
                'candles': latestCandles.toMap(),
                'latestUpdate': todaysTimestamp,
              },
            );
            print('Document updated successfuly.');
          } else {
            // Get information directly from Firebase, as it is up to date.
            latestProfile = CompanyProfile.fromMap(snapshot.data()['profile']);
            latestCandles = StockCandles.fromMap(snapshot.data()['candles']);
            latestTimestamp = snapshot.data()['latestUpdate'];
          }
          // Create an object from stock document.
          stock = StockDetails(
            candles: latestCandles,
            profile: latestProfile,
            latestUpdate: latestTimestamp.toDate(),
            currency: snapshot.data()['currency'],
            description: snapshot.data()['description'],
            displaySymbol: snapshot.data()['displaySymbol'],
            symbol: snapshot.data()['symbol'],
            type: snapshot.data()['type'],
          );
          this.detailsSink(stock);
          // Return the stock.
          return stock;
        })
        .then((value) => print("Succesfully loaded ${value.symbol} details."))
        .catchError((error) => print("Failed to get stock: $error"));
    return stock;
  }

// Get todays date in UNIX datetime.
  int daysInEpoch(Timestamp date) {
    // Traslate date to days.
    final dateInDays =
        (date.millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor();

    return dateInDays;
  }
}
