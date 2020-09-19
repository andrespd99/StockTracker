// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// import 'package:stock_tracker/constants.dart';
// import 'package:stock_tracker/src/pages/stock_details.dart';
// import 'package:stock_tracker/src/services/symbols_bloc.dart';

// class SearchStocksPage extends StatelessWidget {
//   const SearchStocksPage({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final textTheme = Theme.of(context).textTheme;

//     final symbolsBloc = Provider.of<SymbolsBloc>(context);

//     symbolsBloc.getStockSymbols();

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//       width: w,
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             HomeAppBar(textTheme: textTheme),
//             SizedBox(height: kDefaultPadding),
//             StreamBuilder(
//               stream: symbolsBloc.symbolsStream,
//               // initialData: initialData ,
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<StockSymbol>> snapshot) {
//                 return snapshot.hasData
//                     ? StockCards(snapshot.data)
//                     : Center(child: CircularProgressIndicator());
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeAppBar extends StatelessWidget {
//   const HomeAppBar({
//     Key key,
//     @required this.textTheme,
//   }) : super(key: key);

//   final TextTheme textTheme;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Stocks', style: textTheme.headline3),
//           Text(getTodayDate(),
//               style: textTheme.headline4
//                   .copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold)),
//           // RaisedButton(onPressed: null),
//           SizedBox(height: kDefaultPadding / 2),
//           SearchBox(),
//         ],
//       ),
//     );
//   }

//   String getTodayDate() {
//     var date = DateTime.now();
//     var formatter = DateFormat('MMMMd');
//     var dateFormatted = formatter.format(date);

//     return dateFormatted;
//   }
// }

// class StockCards extends StatelessWidget {
//   const StockCards(this.stockSymbols, {Key key}) : super(key: key);

//   final List<StockSymbol> stockSymbols;
//   final int _count = 50;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.separated(
//         separatorBuilder: (context, index) => Divider(),
//         itemCount: _count,
//         itemBuilder: (context, i) => StockCard(stockSymbols[i]),
//       ),
//     );
//   }
// }

// class StockCard extends StatelessWidget {
//   const StockCard(
//     this.data, {
//     Key key,
//   }) : super(key: key);

//   final StockSymbol data;

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final textTheme = Theme.of(context).textTheme;
//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context, MaterialPageRoute(builder: (context) => StockDetails(data))),
//       child: Container(
//         color: Colors.transparent,
//         padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
//         width: w,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: buildSymbolAndName(data, textTheme),
//             ),
//             Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('\$258.00', style: textTheme.headline5),
//                   buildPercentageOfChangeBox(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Column buildSymbolAndName(StockSymbol data, TextTheme textTheme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           "${data.symbol}",
//           style: textTheme.headline4.copyWith(fontWeight: FontWeight.w500),
//         ),
//         Text(
//           "${data.description}",
//           style: textTheme.headline6,
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         )
//       ],
//     );
//   }

//   Container buildPercentageOfChangeBox() {
//     return Container(
//       margin: EdgeInsets.only(top: kDefaultPadding / 4),
//       width: 80.0,
//       height: 30.0,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.all(Radius.circular(4.0)),
//       ),
//       child: Text('-3.85%'),
//     );
//   }
// }

// class SearchBox extends StatelessWidget {
//   const SearchBox({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 55.0,
//         decoration: BoxDecoration(
//           color: kSecondaryColor,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         alignment: Alignment.centerLeft,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//           child: Text(
//             'Search Stocks',
//             style: TextStyle(color: kSearchText, fontSize: 15.0),
//           ),
//         ),
//       ),
//     );
//   }
// }
