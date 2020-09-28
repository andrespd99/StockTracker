import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker/constants.dart';
import 'package:stock_tracker/src/models/stock_details.dart';
import 'package:stock_tracker/src/pages/stock_details_page.dart';
import 'package:stock_tracker/src/services/stocks/search.dart';

class Searcher extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    /* Acciones de nuestro AppBar */
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    /* Icono a la izquierda del AppBar */
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return _getQueryResults(context);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return _getQuerySnapshots(context);
    }
  }

  FutureBuilder<List<AlgoliaObjectSnapshot>> _getQuerySnapshots(
      BuildContext context) {
    return FutureBuilder(
      future: Provider.of<SearchAlgolia>(context).getAlgoliaSuggestions(query),
      builder: (context, AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
        return (!snapshot.hasData)
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (_, i) => Divider(
                      color: kSecondaryColor,
                      thickness: 0.7,
                      indent: kDefaultPadding,
                      endIndent: kDefaultPadding,
                    ),
                itemBuilder: (_, i) {
                  final String stockId = snapshot.data[i].data['symbol'];
                  final String companyName =
                      snapshot.data[i].data['description'];

                  return ListTile(
                    title: Text(stockId),
                    subtitle: Text(companyName),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StockDetailsPage(stockId: stockId),
                      ),
                    ),
                  );
                });
      },
    );
  }

  FutureBuilder<List<AlgoliaObjectSnapshot>> _getQueryResults(
      BuildContext context) {
    final searchPage = 0;

    return FutureBuilder(
      future: Provider.of<SearchAlgolia>(context)
          .getAlgoliaResults(query, searchPage),
      builder: (context, AsyncSnapshot<List<AlgoliaObjectSnapshot>> snapshot) {
        return (!snapshot.hasData)
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (_, i) => Divider(
                  color: kSecondaryColor,
                  thickness: 0.7,
                  indent: kDefaultPadding,
                  endIndent: kDefaultPadding,
                ),
                itemBuilder: (_, i) {
                  return GestureDetector(
                    child: ListTile(
                      title: Text(snapshot.data[i].data['symbol']),
                      subtitle: Text(snapshot.data[i].data['description']),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StockDetailsPage(
                                stockId: snapshot.data[i].data['symbol']),
                          )),
                    ),
                  );
                },
              );
      },
    );
  }
}
