// import 'dart:async';

// import 'package:http/http.dart' as http;
// import 'package:stock_tracker/constants.dart';

// import 'package:stock_tracker/src/models/company_profile.dart';
// import 'package:stock_tracker/src/models/stock_candles.dart';
// export 'package:stock_tracker/src/models/company_profile.dart';

// class CompanyProfileBloc {
//   String _apiKey = kApiKey;
//   String _url = kUrl;

//   List<CompanyProfile> _companiesCache = [];

//   final _companiesStreamController =
//       StreamController<List<CompanyProfile>>.broadcast();

//   Function(List<CompanyProfile>) get companiesSink =>
//       _companiesStreamController.sink.add;

//   Stream<List<CompanyProfile>> get companiesStream =>
//       _companiesStreamController.stream;

//   void dispose() {
//     _companiesStreamController?.close();
//   }

//   Future<CompanyProfile> _processResponseCompany(Uri url) async {
//     final resp = await http.get(url);
//     final company = companyProfileFromJson(resp.body);

//     return company;
//   }

//   Future<StockCandles> _processResponseCandles(Uri url) async {
//     final resp = await http.get(url);
//     final candles = stockCandlesFromJson(resp.body);

//     return candles;
//   }

//   Future<CompanyProfile> getCompany(String symbol) async {
//     // Check whether stock was already loaded or not.
//     if (_companiesCache.isNotEmpty) {
//       for (var i = 0; i < _companiesCache.length; i++) {
//         if (_companiesCache[i].ticker == symbol) {
//           //If is loaded, do nothing.
//           return _companiesCache[i];
//         }
//       }
//     }

//     final url = Uri.https(_url, '/api/v1/stock/profile2', {
//       'symbol': symbol,
//       'token': _apiKey,
//     });

//     final resp = await _processResponseCompany(url);

//     _companiesCache.add(resp);
//     companiesSink(_companiesCache);
//     return resp;
//   }

//   Future<StockCandles> getStockCandles(String symbol) async {
//     // Construct the API's URL link.
//     final url = Uri.https(_url, '/api/v1/stock/candle', {
//       'symbol': symbol,
//       'resolution': 'D', // D to get data in days.
//       'from': getXDaysBackToUnix(kQuotesRange + 10).toString(),
//       'to': getTodayDateToUnix().toString(),
//       'token': _apiKey,
//     });

//     // Process URL and convert the results to an Object.
//     final resp = await _processResponseCandles(url);

//     return resp;
//   }

//   // Get X days back in UNIX datetime,
//   int getXDaysBackToUnix(int i) {
//     final iDaysBack =
//         DateTime.now().subtract(Duration(days: i)).millisecondsSinceEpoch /
//             1000;
//     return iDaysBack.toInt();
//   }

//   // Get todays date in UNIX datetime.
//   int getTodayDateToUnix() {
//     final now = DateTime.now().millisecondsSinceEpoch / 1000;
//     return now.toInt();
//   }
// }
