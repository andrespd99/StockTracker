import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:stock_tracker/constants.dart';

import 'package:stock_tracker/src/models/company_profile.dart';
export 'package:stock_tracker/src/models/company_profile.dart';

class CompanyProfileBloc {
  String _apiKey = kApiKey;
  String _url = kUrl;

  bool _loading = false;

  List<CompanyProfile> _companiesCache = [];

  final _companiesStreamController =
      StreamController<List<CompanyProfile>>.broadcast();

  Function(List<CompanyProfile>) get companiesSink =>
      _companiesStreamController.sink.add;

  Stream<List<CompanyProfile>> get companiesStream =>
      _companiesStreamController.stream;

  void dispose() {
    _companiesStreamController?.close();
  }

  Future<CompanyProfile> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final company = companyProfileFromJson(resp.body);

    return company;
  }

  Future<CompanyProfile> getCompany(String symbol) async {
    // Check whether the company selected was already loaded and cached.
    bool isLoaded =
        _companiesCache.every((element) => element.ticker == symbol);
    //If is loaded, do nothing.
    if (isLoaded) return null;

    final url = Uri.https(_url, '/api/v1/stock/profile2', {
      'symbol': symbol,
      'token': _apiKey,
    });

    final resp = await _processResponse(url);

    _companiesCache.add(resp);
    companiesSink(_companiesCache);

    return resp;
  }
}
