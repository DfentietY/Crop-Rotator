import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:crop_rot/model/mycrops.dart';
import 'package:crop_rot/model/crops.dart';
import 'package:crop_rot/model/rotation.dart';

import 'package:crop_rot/ui/alert.dart';

import '../main.dart';

class GetDates extends StatefulWidget {
  GetDates({this.selectedCrops, });
  final List<MyCrops> selectedCrops;
  GetDatesState createState() => GetDatesState();
}

class GetDatesState extends State<GetDates> {
  Rotation _rotation;
  List<Crops> crops = List<Crops>();

  List<String> months = <String>[
    "January - February",
    "February - March",
    "March - April",
    "April - May",
    "May - June",
    "June - July",
    "July - August",
    "August - September",
    "September - October",
    "October - November",
    "November - December",
    "December - January"
  ];

  List<DropdownMenuItem> monthItems = List();

  List<int> numTimes = List(8);
  List<int> numTracker = List();
  List<DropdownMenuItem> numTimesItems = List();

  List<String> sowMonth = List();
  List<String> harvestMonth = List();

  void manageCrops(snapshot) {
    for (int i = 0; i < widget.selectedCrops.length; i++) {
      for (int j = 0; j < snapshot.data.length; j++) {
        if (widget.selectedCrops[i].id == snapshot.data[j].id) {
          crops.add(snapshot.data[j]);
        }
      }
    }
  }

  void saveMonths(List<MyCrops> mycrops) {
    MyCrops.saveAllCrops(mycrops);
  }

  void changeSelectedDate(value, index, {harvest = false}) {
    if (!harvest) {
      widget.selectedCrops[index].sowMonths = value;
    } else {
      widget.selectedCrops[index].harvestMonths = value;
    }
    setState(() {
      if (!harvest) {
        sowMonth[index] = value;
      } else {
        harvestMonth[index] = value;
      }
    });
  }

  void initState() {
    super.initState();

    sowMonth.length = widget.selectedCrops.length;
    harvestMonth.length = widget.selectedCrops.length;
    numTracker.length = widget.selectedCrops.length;

    for (int i = 0; i < numTimes.length; i++) {
      numTimes[i] = i + 1;
    }

    for (int i = 0; i < sowMonth.length; i++) {
      widget.selectedCrops[i].sowMonths = months.first;
      widget.selectedCrops[i].harvestMonths = months.first;
      widget.selectedCrops[i].numTimesInRotation = numTimes.first;
      
      sowMonth[i] = months.first;
      harvestMonth[i] = months.first;
      numTracker[i] = numTimes.first;
    }

    monthItems.clear();
    numTimesItems.clear();

    months.forEach((month) {
      monthItems.add(
        DropdownMenuItem(
          value: month,
          child: Text('$month'),
        ),
      );
    });

    numTimes.forEach((numTime) {
      numTimesItems.add(DropdownMenuItem(
        value: numTime,
        child: Text('$numTime'),
      ));
    });
  }

  Widget _header(name) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(image) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 50.0,
        horizontal: 50.0,
      ),
      child: Image.asset(image),
    );
  }

  Widget _getDate(index, {getHarvestMonth = false}) {
    String text = (!getHarvestMonth) ? "Sow Months: " : "Harvest Months: ";
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(text),
              DropdownButton(
                items: monthItems,
                onChanged: (value) =>
                    changeSelectedDate(value, index, harvest: getHarvestMonth),
                value:
                    (getHarvestMonth) ? harvestMonth[index] : sowMonth[index],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getNumTimesInRotation(index) {
    return Container(
        child: DropdownButton(
            items: numTimesItems,
            onChanged: (value) {
              widget.selectedCrops[index].numTimesInRotation = value;
              setState(() {
                numTracker[index] = value;
              });
            },
            value: numTracker[index]));
  }

  Widget _footer(index) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _getDate(index),
            ],
          ),
          Row(
            children: <Widget>[
              _getDate(index, getHarvestMonth: true),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Number of times in a rotation: "),
              _getNumTimesInRotation(index),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Set dates'),
      ),
      body: FutureBuilder<List<Crops>>(
        future: Crops.getAllCrops(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            manageCrops(snapshot);
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 80.0,
                horizontal: 10.0,
              ),
              child: PageView.builder(                
                itemCount: widget.selectedCrops.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: GridTile(
                        header: _header(crops[index].name),
                        child: _body(crops[index].image),
                        footer: _footer(index),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(strokeWidth: 3),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Alert(
              title: Text(""),
              body: Text(""),
              function: () async {
                saveMonths(widget.selectedCrops);
                _rotation = await Rotation.calculateRotation(widget.selectedCrops);
                print('The contents of rotat:\n id: ' + _rotation.id.toString());
                Navigator.popAndPushNamed(context, 'home', arguments: _rotation);
              },
            ),
          );
        },
        child: Icon(CupertinoIcons.check_mark),
      ),
    );
  }
}