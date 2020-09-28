import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';
import 'package:stock_tracker/src/models/candles.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/services/stocks/candles_bloc.dart';

class StocksBloc {
  final _stocksController = BehaviorSubject<List<StockDetails>>();

  /* DEPRECATED */
  // final _detailsController = StreamController<StockDetails>.broadcast();
  // Function(StockDetails) get detailsSink => _detailsController.add;
  // Stream<StockDetails> get detailsStream => _detailsController.stream;
  /* DEPRECATED */

  Function(List<StockDetails>) get stocksSink => _stocksController.add;
  Stream<List<StockDetails>> get stocksStream => _stocksController.stream;

  List<String> stockSymbols = [];

  void dispose() {
    // _detailsController?.close(); // DEPRECATED
    _stocksController?.close();
  }

  /*
  *   Loads stock details and returns a list of it.
  */
  Future<List<StockDetails>> loadStocks(List<String> stocksList) async {
    List<StockDetails> stocks = [];

    for (var stockId in stocksList) {
      StockDetails stock = await getStock(stockId);
      if (stock != null && stock.candles != null) {
        if (stocks.every((e) => e.symbol != stockId)) {
          stocks.add(stock);
          stockSymbols.add(stock.symbol);
        } else {
          print("Stock $stockId already listed. Ignoring request.");
        }
      } else {
        print("Stock does not exists or is not available from API.");
      }
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
    Candles latestCandles;
    // CompanyProfile latestProfile;

    return await FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          // Save today's date and the last date document was updated.
          int now = _daysInEpoch(todaysTimestamp);
          int previous;
          if (snapshot.data().containsKey('latestUpdate'))
            previous = _daysInEpoch(snapshot.data()['latestUpdate']);

          /* Update information if:
          * - there is not 'latestUpdate' in document, which means it's never been filled.
          * - now date is different from previous date, meaning data is old.
          */
          if (!snapshot.data().containsKey('latestUpdate')) {
            previous = _daysInEpoch(todaysTimestamp);
            print('Creating latestUpdate.');
            transaction
                .update(documentReference, {'latestUpdate': todaysTimestamp});
          }

          if (!snapshot.data().containsKey('candles') || now != previous) {
            print('Data is old or not in database. Retrieving from API...');
            // Get latest candles and profile from API.
            latestCandles =
                await CandlesBloc().getStockCandles(stockId) ?? null;
            // latestProfile = await CompanyProfileBloc().getCompany(stockId);
            // Save todays timestamp to mark stock as up to date.
            latestTimestamp = todaysTimestamp;
            // Update stock document.
            print('Updating document...');
            transaction.update(
              documentReference,
              {
                'candles': latestCandles.toMap(),
                'latestUpdate': todaysTimestamp,
              },
            );
            print('Document updated successfuly.');
          } else {
            // Get information directly from Firebase, as it is up to date.
            latestCandles = Candles.fromMap(snapshot.data()['candles']);
            latestTimestamp = snapshot.data()['latestUpdate'];
          }
          // Create an object from stock document.
          stock = StockDetails(
            candles: latestCandles,
            latestUpdate: latestTimestamp.toDate(),
            currency: snapshot.data()['currency'],
            description: snapshot.data()['description'],
            displaySymbol: snapshot.data()['displaySymbol'],
            symbol: snapshot.data()['symbol'],
            type: snapshot.data()['type'],
          );
          // this.detailsSink(stock); //DEPRECATED
          // Return the stock.
          return stock;
        })
        .then((value) => print("Succesfully loaded ${value.symbol} details."))
        .catchError((error) => print("Failed to get stock. $error"))
        .then((value) => stock);
  }

// Get todays date in UNIX datetime.
  int _daysInEpoch(Timestamp date) {
    // Traslate date to days.
    final dateInDays =
        (date.millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor();

    return dateInDays;
  }
}
