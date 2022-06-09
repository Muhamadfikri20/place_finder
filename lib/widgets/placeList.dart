import 'package:flutter/material.dart';
import 'package:place_finder/utils/urlHelper.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';

class PlaceList extends StatelessWidget {
  final List<PlaceViewModel> places;

  PlaceList({required this.places});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.places.length,
      itemBuilder: (context, index) {
        final place = this.places[index];

        return ListTile(title: Text(place.name));
      },
    );
  }
}
