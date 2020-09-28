import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/services/login/authenticate_bloc.dart';

import 'package:stock_tracker/src/services/stocks/candles_bloc.dart';

import 'package:intl/intl.dart';
import 'package:stock_tracker/src/services/stocks/stocks_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockDetailsPage extends StatefulWidget {
  StockDetailsPage({this.details, this.stockId, Key key}) : super(key: key);

  final StockDetails details;
  final String stockId;

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = Provider.of<StocksBloc>(context);

    bool isSelected;

    if (widget.stockId != null) {
      isSelected =
          Provider.of<AuthBloc>(context).pinnedStocks.contains(widget.stockId);
      print(isSelected);
    } else if (widget.details != null) {
      isSelected = Provider.of<AuthBloc>(context)
          .pinnedStocks
          .contains(widget.details.symbol);
      print(isSelected);
    }

    /* We have two use-cases. We either
    *   - Get stock details, which means it was already fetched.
    *   - We only get stockId, which means details will be fetched on demand.
    */

    //First use-case: only stockId provided.
    if (widget.details == null && widget.stockId != null) {
      return Material(
        child: FutureBuilder(
          future: bloc.getStock(widget.stockId),
          builder: (context, AsyncSnapshot<StockDetails> snapshot) {
            return (!snapshot.hasData)
                ? Center(child: CircularProgressIndicator())
                : Scaffold(
                    appBar: buildAppBar(
                        textTheme, snapshot.data, context, isSelected),
                    body: (!snapshot.hasData)
                        ? Expanded(
                            child: Center(child: CircularProgressIndicator()))
                        : ListView(
                            children: [
                              StockHistoric(snapshot.data),
                              StockChart(snapshot.data),
                            ],
                          ),
                  );
          },
        ),
      );
      //Second use-case: details is provided.
    } else if (widget.details != null) {
      return Scaffold(
        appBar: buildAppBar(textTheme, widget.details, context, isSelected),
        body: ListView(
          children: [
            StockHistoric(widget.details),
            StockChart(widget.details),
          ],
        ),
      );
      //Third use-case: none is given. Should never happen.
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: Expanded(child: Center(child: Text('No data! Go back.'))),
      );
    }
  }

  AppBar buildAppBar(TextTheme textTheme, StockDetails details,
      BuildContext context, bool isSelected) {
    return AppBar(
      centerTitle: false,
      toolbarHeight: kAppBarHeight,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: RichText(
              overflow: TextOverflow.fade,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '${details.symbol}',
                      style: textTheme.headline5
                          .copyWith(fontWeight: FontWeight.w800)),
                  TextSpan(text: '     '),
                  TextSpan(
                    text: '${details.description}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: (isSelected) ? Icon(Icons.check) : Icon(Icons.add),
              color: kPrimaryColor,
              onPressed: (isSelected)
                  ? () => deleteStock(context, details.symbol, isSelected)
                  : () {
                      addStock(context, details.symbol, isSelected);
                    },
            ),
          ),
        ],
      ),
    );
  }

  void addStock(BuildContext context, String symbol, bool isSelected) async {
    final bloc = Provider.of<AuthBloc>(context, listen: false);
    bloc.addPinnedStocks(symbol);
    setState(() {});
  }

  void deleteStock(BuildContext context, String symbol, bool isSelected) async {
    final bloc = Provider.of<AuthBloc>(context, listen: false);
    bloc.removePinnedStocks(symbol);
    setState(() {});
  }
}

class StockHistoric extends StatelessWidget {
  const StockHistoric(this.data, {Key key}) : super(key: key);

  final StockDetails data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemCount: kQuotesRange,
      shrinkWrap: true,
      itemBuilder: (_, i) => StockDailyData(data.candles.candles[i]),
      separatorBuilder: (_, i) => Divider(),
    );
  }
}

class StockDailyData extends StatelessWidget {
  const StockDailyData(
    this.data, {
    Key key,
  }) : super(key: key);

  final Candle data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                getDateFromUnix(data.timestamp),
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: kDefaultPadding / 4),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AtOpenInfobar(data),
                SizedBox(width: kDefaultPadding),
                Container(width: 0.5, height: 50.0, color: Colors.grey),
                SizedBox(width: kDefaultPadding),
                AtCloseInfobar(data),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getDateFromUnix(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toUtc();
    final formatter = DateFormat('EEEE, MMMM d');
    final dateFormated = formatter.format(date);

    return dateFormated;
  }
}

class AtCloseInfobar extends StatelessWidget {
  const AtCloseInfobar(
    this.data, {
    Key key,
  }) : super(key: key);

  final Candle data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final closingPrice = data.close.toStringAsFixed(2);
    final changePctg = data.pctOfChange.toStringAsFixed(2);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$closingPrice',
                  style: textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Text(
                  'At close',
                  style: textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.grey),
                )
              ],
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              (data.pctOfChange > 0) ? '+$changePctg%' : '$changePctg%',
              style: textTheme.subtitle1.copyWith(
                  color: (data.pctOfChange >= 0) ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AtOpenInfobar extends StatelessWidget {
  const AtOpenInfobar(
    this.data, {
    Key key,
  }) : super(key: key);

  final Candle data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final openingPrice = data.open.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$openingPrice',
                style: textTheme.headline6
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Text(
                'At opening',
                style: textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.grey),
              )
            ],
          ),
          SizedBox(width: kDefaultPadding / 2),
        ],
      ),
    );
  }
}

class StockChart extends StatelessWidget {
  const StockChart(this._details, {Key key}) : super(key: key);

  final StockDetails _details;

  @override
  Widget build(BuildContext context) {
    final prices = _details.candles.candles;

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(enable: true),

        // Initialize category axis
        title: ChartTitle(
          text: '${_details.symbol} prices in the last ${prices.length} days',
          alignment: ChartAlignment.far,
          borderWidth: kDefaultPadding / 2.5,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        primaryXAxis: CategoryAxis(labelRotation: 50),
        primaryYAxis: NumericAxis(labelFormat: '{value} \$', maximumLabels: 1),

        series: <LineSeries<Candle, String>>[
          LineSeries<Candle, String>(
            name: '${_details.symbol} Serie',
            color: kPrimaryColor,
            markerSettings:
                MarkerSettings(isVisible: true, color: kPrimaryColor),
            enableTooltip: true,
            // Bind data source
            dataSource: prices.reversed.toList(),
            xValueMapper: (Candle candle, _) =>
                getDateToString(candle.timestamp),
            yValueMapper: (Candle candle, _) => candle.close,
          )
        ],
      ),
    );
  }

  getDateToString(int timestamp) {
    timestamp = timestamp + 60 * 60 * 24;
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formatter = DateFormat('MM/d');
    final formated = formatter.format(date);
    return formated;
  }
}
