import 'package:flutter/material.dart';
import 'package:place_finder/pages/homePage.dart';
import 'package:place_finder/viewmodels/placeListViewModel.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ChangeNotifierProvider(create: (context) => PlaceListViewModel(), child: HomePage()));
  }
}
