import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_finder/services/webservice.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';

class PlaceListViewModel extends ChangeNotifier {
  var places = <PlaceViewModel>[];
  var mapType = MapType.normal;
  void toggleMapType() {
    this.mapType = this.mapType == MapType.normal ? MapType.satellite : MapType.normal;
    notifyListeners();
  }

  Future<void> fetchPlacesByKeywordAndPosition(String keyword, double latitude, double longitude) async {
    final results = await Webservice().fetchPlacesByKeywordAndPosition(keyword, latitude, longitude);
    places = results.map((place) => PlaceViewModel(place)).toList();
    notifyListeners();
  }
}
