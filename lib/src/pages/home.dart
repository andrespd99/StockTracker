import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/services/company_profile_bloc.dart';

import 'package:stock_tracker/src/pages/stock_details.dart';
import 'package:stock_tracker/src/models/company_profile.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  List<String> pinnedStocks = ['AAPL', 'GOOGL', 'NKE', 'SBUX'];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    final companiesBloc = Provider.of<CompanyProfileBloc>(context);

    pinnedStocks.forEach((element) => companiesBloc.getCompany(element));

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
              stream: companiesBloc.companiesStream,
              // initialData: initialData ,
              builder: (BuildContext context,
                  AsyncSnapshot<List<CompanyProfile>> snapshot) {
                return snapshot.hasData
                    ? StockCards(snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
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
  const StockCards(this.companies, {Key key}) : super(key: key);

  final List<CompanyProfile> companies;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: companies.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, i) {
          return StockCard(companies[i]);
        },
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  const StockCard(
    this.company, {
    Key key,
  }) : super(key: key);

  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => StockDetails(company))),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2.5),
        width: w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildSymbolAndName(company, textTheme),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${company.candles.quotes[0].close.toStringAsFixed(2)}',
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

  Column buildSymbolAndName(CompanyProfile companyData, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "${companyData.ticker}",
          style: textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "${companyData.name}",
          style: textTheme.headline6,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }

  Container buildPctOfChangeBox() {
    return Container(
      margin: EdgeInsets.only(top: kDefaultPadding / 4),
      width: 80.0,
      height: 30.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: (company.candles.quotes[0].pctOfChange >= 0)
            ? Colors.green
            : Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child:
          Text('${company.candles.quotes[0].pctOfChange.toStringAsFixed(2)}%'),
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
