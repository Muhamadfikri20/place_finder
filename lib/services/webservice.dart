import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:place_finder/utils/urlHelper.dart';

class Webservice {
  void fetchPlacesByKeywordAndPosition(String keyword, double latitude, double longitude) async {
    final url = UrlHelper.urlForPlaceKeywordAndLocation(keyword, latitude, longitude);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final Iterable results = jsonResponse["results"];
    }
  }
}
