import 'package:algolia/algolia.dart';

class SearchAlgolia {
  static final Algolia _algolia = Algolia.init(
    applicationId: '7UEI80QR2J',
    apiKey: '97f0fd4ea9f52e4ed21ac982996b92a3',
  );

  // Algolia algolia = _algolia.instance;

  Future<List<AlgoliaObjectSnapshot>> getAlgoliaSnapshots(String query) async {
    AlgoliaQuery algQuery = _algolia.index('dev_STOCKS_FINAL').search(query);
    AlgoliaQuerySnapshot snapshot = await algQuery.getObjects();
    return snapshot.hits;
  }

  Future<List<AlgoliaObjectSnapshot>> getAlgoliaResults(
      String query, int searchPage) async {
    AlgoliaQuery algQuery =
        _algolia.index('dev_STOCKS_FINAL').search(query).setPage(searchPage);
    AlgoliaQuerySnapshot snapshot = await algQuery.getObjects();
    return snapshot.hits;
  }
}
