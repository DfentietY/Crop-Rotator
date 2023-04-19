import 'package:flutter/material.dart';

import 'package:crop_rot/main.dart';
import 'package:crop_rot/ui/selectcrops.dart';
import 'package:crop_rot/ui/getdates.dart';

import 'package:crop_rot/model/rotation.dart';
import 'package:crop_rot/model/mycrops.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        Rotation _rotation = settings.arguments as Rotation;
        return MaterialPageRoute(
          builder: (BuildContext context) => Home(
            rotation: _rotation,
          ),
        );
      case 'selectCrops':
        return MaterialPageRoute(
          builder: (BuildContext context) => SelectCrops(),
        );
      case 'getDates':
        List<MyCrops> crops = settings.arguments as List<MyCrops>;
        return MaterialPageRoute(
          builder: (BuildContext context) => GetDates(
            selectedCrops: crops,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => Scaffold(
            body: Center(
              child: Text('Cannot find the route'),
            ),
          ),
        );
    }
  }
}
