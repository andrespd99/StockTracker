import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/services/stocks_bloc.dart';

class HeatmapPage extends StatefulWidget {
  HeatmapPage({Key key}) : super(key: key);

  @override
  _HeatmapPageState createState() => _HeatmapPageState();
}

class _HeatmapPageState extends State<HeatmapPage> {
  final List<StockDetails> list = [];

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<StocksBloc>(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Heatmap',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          toolbarHeight: kAppBarHeight,
          backgroundColor: kSecondaryColor,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: GridView.builder(
            itemCount: bloc.stocks.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: kDefaultPadding / 2,
              crossAxisSpacing: kDefaultPadding / 2,
            ),
            itemBuilder: (_, i) => GridItem(bloc.stocks[i]),
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem(this.stock, {Key key}) : super(key: key);

  final StockDetails stock;

  @override
  Widget build(BuildContext context) {
    double avgChange = 0.0;
    // Sum all pctOfChange.
    for (var i = 0; i < 5; i++) {
      avgChange += stock.candles.candles[i].pctOfChange;
    }
    // Calculate avgLenght
    avgChange = avgChange / stock.candles.candles.length;

    final textTheme = Theme.of(context).textTheme;

    return GridTile(
      child: Container(
        decoration: BoxDecoration(
            color: getTileColor(avgChange),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0.1, 0.1),
                blurRadius: 1.0,
              )
            ]),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${stock.symbol}',
                  style: textTheme.headline5
                      .copyWith(fontWeight: FontWeight.w900)),
              Text(
                '${avgChange.toStringAsFixed(2)}%',
                style:
                    textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getTileColor(double avg) {
    if (avg >= 3.0) {
      return Color(0xFF138F3E);
    } else if (avg >= 1.0) {
      return Color(0xFF3ae374);
    } else if (avg >= 0.0) {
      return Color(0xFF64FF9D);
    } else if (avg > -2.0) {
      return Color(0xFFFC6A6A);
    } else if (avg > -3.0) {
      return Color(0xFFff3838);
    } else {
      return Color(0xFF970F0F);
    }
  }
}
