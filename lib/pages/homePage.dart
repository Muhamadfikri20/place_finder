import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_finder/viewmodels/placeListViewModel.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';
import 'package:place_finder/widgets/placeList.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
  }

  Set<Marker> _getPlaceMarkers(List<PlaceViewModel> places) {
    return places.map((place) {
      return Marker(
          markerId: MarkerId(place.placeId), icon: BitmapDescriptor.defaultMarker, infoWindow: InfoWindow(title: place.name), position: LatLng(place.latitude, place.longitude));
    }).toSet();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    final _currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 14)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaceListViewModel>(context);
    print(vm.places);
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
          markers: _getPlaceMarkers(vm.places),
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 14),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                vm.fetchPlacesByKeywordAndPosition(value, _currentPosition!.latitude, _currentPosition!.longitude);
              },
              decoration: InputDecoration(labelText: "Search here", fillColor: Colors.white, filled: true),
            ),
          ),
        ),
        Visibility(
          visible: vm.places.length > 0 ? true : false,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FlatButton(
                  child: Text("Show List", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => PlaceList(
                              places: vm.places,
                            ));
                  },
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
