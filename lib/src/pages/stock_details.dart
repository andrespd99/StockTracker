import 'package:flutter/material.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/text_styles.dart';

class StockDetails extends StatelessWidget {
  const StockDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: buildAppBar(textTheme),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
            StockDailyData(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(TextTheme textTheme) {
    return AppBar(
      centerTitle: false,
      toolbarHeight: 70.0,
      backgroundColor: kSecondaryColor,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'AAPL',
                style:
                    textTheme.headline5.copyWith(fontWeight: FontWeight.w800)),
            TextSpan(text: '  '),
            TextSpan(text: 'Apple Inc.'),
          ],
        ),
      ),
    );
  }
}

class StockDailyData extends StatelessWidget {
  const StockDailyData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                'September 20',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: kDefaultPadding / 4),
            Row(
              children: [
                AtCloseInfobar(),
                Container(width: 0.2, color: Colors.grey),
                Expanded(child: AtOpenInfobar()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AtCloseInfobar extends StatelessWidget {
  const AtCloseInfobar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '196.84',
                style: textTheme.headline6
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Text(
                'At close',
                style: textTheme.subtitle1
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.grey),
              )
            ],
          ),
          SizedBox(width: kDefaultPadding / 2),
          Text(
            '-3,87%',
            style: textTheme.subtitle1.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AtOpenInfobar extends StatelessWidget {
  const AtOpenInfobar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '196.84',
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
          Text(
            '-3,87%',
            style: textTheme.subtitle1.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
