import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/pages/heatmap.dart';

import 'package:stock_tracker/src/services/company_profile_bloc.dart';

import 'package:stock_tracker/src/pages/stock_details.dart';
import 'package:stock_tracker/src/models/company_profile.dart';
import 'package:stock_tracker/src/services/stocks_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  List<String> pinnedStocks = [
    'AAPL',
    'GOOGL',
    'NKE',
    'SBUX',
    'EBAY',
    'V',
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    final stocksBloc = Provider.of<StocksBloc>(context);
    Provider.of<StocksBloc>(context).getStocks(pinnedStocks);

    // pinnedStocks.forEach((element) => companiesBloc.getCompany(element));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      width: w,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppBar(textTheme: textTheme),
            SizedBox(height: kDefaultPadding),
            StreamBuilder(
              stream: stocksBloc.stocksStream,
              // initialData: stocksList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<StockDetails>> snapshot) {
                return snapshot.hasData
                    ? StockCards(snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            Center(
              child: RaisedButton(
                  color: kPrimaryColor,
                  child: Text(
                    'SEE HEATMAP',
                    style: TextStyle(color: kSecondaryColor),
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HeatmapPage()))),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key key,
    @required this.textTheme,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stocks', style: textTheme.headline3),
          Text(getTodayDate(),
              style: textTheme.headline4
                  .copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold)),
          // RaisedButton(onPressed: null),
          SizedBox(height: kDefaultPadding / 2),
          SearchBox(),
        ],
      ),
    );
  }

  String getTodayDate() {
    var date = DateTime.now();
    var formatter = DateFormat('MMMMd');
    var dateFormatted = formatter.format(date);

    return dateFormatted;
  }
}

class StockCards extends StatelessWidget {
  const StockCards(this.stockDetails, {Key key}) : super(key: key);

  final List<StockDetails> stockDetails;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: stockDetails.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, i) {
          return StockCard(stockDetails[i]);
        },
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  const StockCard(
    this.stockDetails, {
    Key key,
  }) : super(key: key);

  final StockDetails stockDetails;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StockDetailsPage(stockDetails.profile))),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildSymbolAndName(stockDetails.profile, textTheme),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      '${stockDetails.candles.candles[0].close.toStringAsFixed(2)}',
                      style: textTheme.headline5
                          .copyWith(fontWeight: FontWeight.w300)),
                  buildPctOfChangeBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildSymbolAndName(CompanyProfile profile, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${profile.ticker}",
          style: textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "${profile.name}",
          style: textTheme.headline6,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }

  Container buildPctOfChangeBox() {
    final pctChange = stockDetails.candles.candles[0].pctOfChange;
    return Container(
      margin: EdgeInsets.only(top: kDefaultPadding / 4),
      width: 80.0,
      height: 30.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (pctChange >= 0) ? Colors.green : Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Text('${pctChange.toStringAsFixed(2)}%'),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 55.0,
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            'Search Stocks',
            style: TextStyle(color: kSearchText, fontSize: 15.0),
          ),
        ),
      ),
    );
  }
}
