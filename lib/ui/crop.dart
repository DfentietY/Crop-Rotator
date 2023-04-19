import 'package:flutter/material.dart';

import 'package:crop_rot/model/crops.dart';
import 'package:crop_rot/model/mycrops.dart';

class Crop extends StatefulWidget {
  Crop({this.crop, this.selectedCrops});

  final Crops crop;
  final List<MyCrops> selectedCrops;
  CropState createState() => CropState();
}

class CropState extends State<Crop> {
  bool selected = false;
  void onObjectPress(checked) {
    setState(() {
      selected = checked;
    });
    if (checked) {
      widget.selectedCrops.add(MyCrops(id: widget.crop.id));
    } else {
      widget.selectedCrops.forEach((mycrop) {
        if(mycrop.id == widget.crop.id) {
          widget.selectedCrops.remove(mycrop);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(widget.crop.image),
      title: Center(
        child: Text(widget.crop.name),
      ),
      trailing: Checkbox(
        onChanged: onObjectPress,
        value: selected,
        activeColor: Colors.green,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 40,
      ),
    );
  }
}
