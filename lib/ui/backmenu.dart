import 'package:flutter/material.dart';

class BackMenu extends StatefulWidget {
  @override
  BackMenuState createState() => BackMenuState();
}

class BackMenuState extends State<BackMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9999.99,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text('Select Crops'),
            color: Colors.amber,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'selectCrops');
            },
          ),
        ],
      ),
    );
  }
}
