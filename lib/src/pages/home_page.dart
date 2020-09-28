import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/pages/new_heatmap_page.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';
import 'package:stock_tracker/src/widgets/common.dart';
import 'package:stock_tracker/src/widgets/drawer.dart';
import 'package:stock_tracker/src/widgets/searcher.dart';

import 'package:stock_tracker/src/services/stocks/stocks_bloc.dart';

import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/pages/stock_details_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      future: Provider.of<AuthBloc>(context).loadUserProfile(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> profile) {
        if (profile.hasData) {
          loadPinnedStocks(profile.data['pinnedStocks']);
          return Scaffold(
            drawer: CustomDrawer(onAdmin: false),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeAppBar(textTheme: textTheme),
                    SizedBox(height: kDefaultPadding),
                    StockCards(),
                    Divider(),
                    _createHeatmapButton(context),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createHeatmapButton(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: kDefaultPadding / 3),
        child: RaisedButton(
            padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 2.5, vertical: kDefaultPadding),
            child: Text(
              'SEE HEATMAP',
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => NewHeatmapPage()))),
      ),
    );
  }

  void loadPinnedStocks(List data) {
    final authBloc = Provider.of<AuthBloc>(context);
    final stocksBloc = Provider.of<StocksBloc>(context);

    final pinnedStocks = List.castFrom<dynamic, String>(data).toList();
    authBloc.pinnedStocks = pinnedStocks;
    authBloc.pinnedStocksSink(pinnedStocks);
    stocksBloc.loadStocks(pinnedStocks);
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key key, @required this.textTheme}) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.menu),
            color: Colors.white,
            iconSize: 30.0,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Text('Home', style: textTheme.headline3),
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
  const StockCards({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AuthBloc>(context);
    return StreamBuilder(
        stream: bloc.pinnedStocksStream,
        builder: (_, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, i) {
                    return StockCard(snapshot.data[i]);
                  },
                ),
              );
            } else {
              return Expanded(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No stocks selected.'),
                    SizedBox(height: kDefaultPadding / 2),
                    GestureDetector(
                      onTap: () => showSearch(
                        context: context,
                        delegate: Searcher(),
                      ),
                      child: Text(
                        'Start searching',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                )),
              );
            }
          } else {
            return Expanded(child: Container());
          }
        });
  }
}

class StockCard extends StatelessWidget {
  const StockCard(this.symbol, {Key key}) : super(key: key);

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      future: Provider.of<StocksBloc>(context).getStock(symbol),
      builder: (context, AsyncSnapshot<StockDetails> snapshot) {
        if (snapshot.hasData) {
          final StockDetails stockDetails = snapshot.data;
          final latestClose = stockDetails.candles.candles[0].close;
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StockDetailsPage(details: stockDetails))),
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildSymbolAndName(stockDetails, textTheme),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${latestClose.toStringAsFixed(2)}',
                            style: textTheme.headline5
                                .copyWith(fontWeight: FontWeight.w300)),
                        buildPctOfChangeBox(stockDetails),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return buildLoadingStockCard();
        }
      },
    );
  }

  Container buildLoadingStockCard() {
    return Container(
      padding: EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getLoadingPlaceholder(90, 30),
              SizedBox(height: 10),
              getLoadingPlaceholder(140, 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              getLoadingPlaceholder(70, 23),
              SizedBox(height: 10),
              getLoadingPlaceholder(80, 30),
            ],
          )
        ],
      ),
    );
  }

  Column buildSymbolAndName(StockDetails stock, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${stock.symbol}",
          style: textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "${stock.description}",
          style: textTheme.headline6,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }

  Container buildPctOfChangeBox(StockDetails stockDetails) {
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
      child: Text((pctChange >= 0)
          ? '+${pctChange.toStringAsFixed(2)}%'
          : '${pctChange.toStringAsFixed(2)}%'),
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
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: Searcher(),
          );
        },
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
      ),
    );
  }
}
