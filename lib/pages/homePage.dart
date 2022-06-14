import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:place_finder/viewmodels/placeListViewModel.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';
import 'package:place_finder/widgets/placeList.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart' as prefix0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  static const String _kLocationServicesDisabledMessage = 'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage = 'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    GoogleMapController? controller;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //nothing
    }
    _controller.complete(controller);
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 14)));
    print(_currentPosition);
  }

  Set<Marker> _getPlaceMarkers(List<PlaceViewModel> places) {
    return places.map((place) {
      return Marker(
          markerId: MarkerId(place.placeId), icon: BitmapDescriptor.defaultMarker, infoWindow: InfoWindow(title: place.name), position: LatLng(place.latitude, place.longitude));
    }).toSet();
  }

  Future getMaps() async {
    await GeolocatorPlatform.instance.getCurrentPosition();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    final _currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 14)));
  }

  Future<void> _openMapsFor(PlaceViewModel vm) async {
    bool isGoogleMaps = await MapLauncher.isMapAvailable(prefix0.MapType.google) ?? false;
    if (isGoogleMaps) {
      await MapLauncher.showMarker(mapType: prefix0.MapType.google, coords: Coords(vm.latitude, vm.longitude), title: vm.name, description: vm.name);
    } else {
      await MapLauncher.showMarker(mapType: prefix0.MapType.apple, coords: Coords(vm.latitude, vm.longitude), title: vm.name, description: vm.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaceListViewModel>(context);
    print(vm.places);
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
          mapType: vm.mapType,
          markers: _getPlaceMarkers(vm.places),
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 14),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) async {
                final _currentPosition = await GeolocatorPlatform.instance.getCurrentPosition();
                vm.fetchPlacesByKeywordAndPosition(value, _currentPosition.latitude, _currentPosition.longitude);
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
                              onSelected: _openMapsFor,
                            ));
                  },
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: 10,
          child: FloatingActionButton(
              onPressed: () {
                vm.toggleMapType();
              },
              child: Icon(Icons.map)),
        )
      ]),
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
