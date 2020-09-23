import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/models/company_profile.dart';
import 'package:stock_tracker/src/models/stock_details.dart';

import 'package:stock_tracker/src/services/candles_bloc.dart';

import 'package:intl/intl.dart';
import 'package:stock_tracker/src/services/stocks_bloc.dart';

class StockDetailsPage extends StatelessWidget {
  const StockDetailsPage(this._profile, {Key key}) : super(key: key);

  final CompanyProfile _profile;

  @override
  Widget build(BuildContext context) {
    // Provider.of<CandlesBloc>(context).getStockCandles(_companyData.ticker);
    final bloc = Provider.of<StocksBloc>(context);

    bloc.getStock(_profile.ticker);

    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(textTheme),
      body: StreamBuilder(
        stream: bloc.detailsStream,
        builder: (context, AsyncSnapshot<StockDetails> snapshot) {
          return (snapshot.hasData)
              ? StockHistoric(snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  AppBar buildAppBar(TextTheme textTheme) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0.0,
      centerTitle: false,
      toolbarHeight: kAppBarHeight,
      backgroundColor: kSecondaryColor,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '${_profile.ticker}',
                style:
                    textTheme.headline5.copyWith(fontWeight: FontWeight.w800)),
            TextSpan(text: '     '),
            TextSpan(
              text: '${_profile.name}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class StockHistoric extends StatelessWidget {
  const StockHistoric(this.data, {Key key}) : super(key: key);

  final StockDetails data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (_, i) => StockDailyData(data.candles.candles[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: kQuotesRange,
    );
  }
}

class StockDailyData extends StatelessWidget {
  const StockDailyData(
    this.data, {
    Key key,
  }) : super(key: key);

  final StockCandle data;

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

  final StockCandle data;

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

  final StockCandle data;

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
