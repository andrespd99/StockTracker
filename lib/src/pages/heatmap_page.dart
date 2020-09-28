import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/pages/stock_details_page.dart';
import 'package:stock_tracker/src/services/stocks/stocks_bloc.dart';

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
    // Sort list by percentage of change.
    bloc.stocks.sort((a, b) => b.pctChange5.compareTo(a.pctChange5));

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last 5 days change'.toUpperCase(),
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bloc.stocks.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: kDefaultPadding / 2,
                    crossAxisSpacing: kDefaultPadding / 2,
                  ),
                  itemBuilder: (_, i) => GridItem(bloc.stocks[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem(this.stockDetails, {Key key}) : super(key: key);

  final StockDetails stockDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StockDetailsPage(details: stockDetails))),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              color: getTileColor(stockDetails.pctChange5),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0.1, 0.1),
                  blurRadius: 1.0,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${stockDetails.symbol}',
                  style: textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        offset: Offset(0.1, 0.3),
                        blurRadius: 3.0,
                      )
                    ],
                  )),
              Text(
                '${stockDetails.pctChange5.toStringAsFixed(2)}%',
                style: textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      offset: Offset(0.1, 0.3),
                      blurRadius: 3.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getTileColor(double avg) {
    if (avg >= 3.0) {
      return Colors.green.shade900;
    } else if (avg >= 1.0) {
      return Colors.green;
    } else if (avg >= 0.0) {
      return Colors.green.shade300;
    } else if (avg > -2.0) {
      return Colors.red.shade300;
    } else if (avg > -3.0) {
      return Colors.red;
    } else {
      return Colors.red.shade900;
    }
  }
}
