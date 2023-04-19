import 'package:crop_rot/route.dart';
import 'package:flutter/material.dart';

import 'package:crop_rot/ui/backmenu.dart';
import 'package:crop_rot/ui/plot.dart';

import 'package:crop_rot/xml_parse.dart';
import 'package:crop_rot/db_manager.dart';

import 'package:crop_rot/model/family.dart';
import 'package:crop_rot/model/rotation.dart';

main() => runApp(CropRot());

class CropRot extends StatelessWidget {
  CropRot({this.rotation});
  final Rotation rotation;

  static TextStyle _defTxtStyle =
      TextStyle(color: Colors.amber, fontWeight: FontWeight.bold);
  static TextTheme _textTheme = TextTheme(
    title: _defTxtStyle.copyWith(fontSize: 19),
    button: _defTxtStyle,
    body1: _defTxtStyle,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            color: Colors.amber,
            elevation: 10.0,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black45),
            textTheme: _textTheme.copyWith(
                title: _defTxtStyle.copyWith(
              color: Colors.black45,
              fontSize: 19,
            ))),
        textTheme: _textTheme,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.normal,
        ),
        accentColor: Colors.amberAccent,
        buttonColor: Colors.amber,
      ),
      home: Home(rotation: rotation),
      initialRoute: "home",
      onGenerateRoute: Router.generateRoute,
      title: 'Crop Rotator',
    );
  }
}

class Home extends StatefulWidget {
  Home({this.rotation});
  final Rotation rotation;
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    readyTheApp();
  }

  void readyTheApp() async {
    bool tableExists = await DBManager.doCropsExist();

    if (!tableExists) {
      DBManager.insertFamilies(Family.getFamilies());
      DBManager.insertCrops(XML.getCrops());
    }
  }

  Future setRotation() async {
    if (widget.rotation == null) {
      if (await DBManager.doesDatabaseExist()) {
        return await Rotation.getLastRotation();
      }
    } else {
      return widget.rotation;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Rotator"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 7,
        ),
        child: FutureBuilder(
          future: setRotation(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Plot(snapshot.data),
              );
            } else {
              return Center(
                child: BackMenu(),
              );
            }
          },
        ),
      ),
    );
  }
}
