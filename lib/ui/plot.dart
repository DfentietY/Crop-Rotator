import 'package:crop_rot/model/crops.dart';
import 'package:flutter/material.dart';

import 'package:crop_rot/model/rotation.dart';

class Plot extends StatefulWidget {
  Plot(this.rotation);
  final Rotation rotation;
  @override
  PlotState createState() => PlotState();
}

class PlotState extends State<Plot> {
  List<Crops> crops = List();

  @override
  void initState() {
    super.initState();
  }

  void initialisePlot(List<Crops> cs, snapShot, Rotation rot) {
    for (int i = 0; i < snapShot.data.length; i++) {
      rot.myCrops.forEach((crop) {
        if (crop.id == snapShot.data[i].id) {
          cs.add(snapShot.data[i]);
        }
      });
    }
  }
  //ISSUES THAT STILL NEED FIXING
  /// Getting the id of the rotation from the database

  Widget _header(name) => AnimatedContainer(
        duration: Duration(seconds: 1),
        child: Text(name),
      );

  Widget _image(image) => AnimatedContainer(
        duration: Duration(seconds: 1),
        child: Image.asset(image),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Crops>>(
      future: Crops.getAllCrops(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          initialisePlot(crops, snapshot, widget.rotation);
          return GridView.builder(
            itemCount: widget.rotation.myCrops.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  children: <Widget>[
                    _header(crops[index].name),
                    _image(crops[index].image),
                  ],
                ),
              );
            },
          );
        } else {
          return Center(
            child: RefreshProgressIndicator(
              strokeWidth: 3,
            ),
          );
        }
      },
    );
  }
}
