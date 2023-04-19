import 'package:flutter/material.dart';

import 'package:crop_rot/model/mycrops.dart';
import 'package:crop_rot/model/crops.dart';

import 'package:crop_rot/ui/alert.dart';
import 'package:crop_rot/ui/crop.dart';

class SelectCrops extends StatefulWidget {
  SelectCropsState createState() => SelectCropsState();
}

class SelectCropsState extends State<SelectCrops> {
  List<MyCrops> selectedCrops = List();

  _showDialog() {
    if (selectedCrops.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => Alert(
          title: Text('Confirmation'),
          body: Text('Do you want to continue?'),
          function: () {
            Navigator.popAndPushNamed(
              context,
              'getDates',
              arguments: selectedCrops,
            );
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Alert(
          title: Text('Warning'),
          body: Text(
              'No plants have been selected, please select a list of plants to continue.'),
          function: () {
            Navigator.of(context).pop();
          },
          error: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Crops')),
      body: FutureBuilder<List<Crops>>(
          future: Crops.getAllCrops(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Crop(
                    crop: snapshot.data[index],
                    selectedCrops: selectedCrops,
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              );
            }
          }),
      bottomNavigationBar: Center(
        heightFactor: 1.2,
        child: FloatingActionButton.extended(
          icon: Icon(Icons.check),
          onPressed: _showDialog,
          label: Text("Continue"),
        ),
      ),
    );
  }
}
