import 'package:crop_rot/db_manager.dart';

import 'package:sqflite/sqflite.dart';

class Crops {
  var id;
  var name;
  var image;
  var family;

  Crops({this.id, this.name, this.image, this.family});

  static Future<List<Crops>> getAllCrops() async {
    List<Crops> crops = List();
    Database db = await DBManager.db;

    var result = await db.query("crops");

    result.map((crop) {
      crops.add(Crops.fromMap(crop));
    }).toList();

    return crops;
  }

  static Future<Crops> getCrop(id) async {
    Database db = await DBManager.db;
    Crops crop = Crops();

    await db.transaction((txn) async {
      var result = await txn.query("crops", where: "c_id = ?", whereArgs: [id]);
      crop = Crops.fromMap(result.first);
    });

    return crop;
  }

  static Crops getCropByName(name) {
    return Crops();
  }

  factory Crops.fromMap(Map<String, dynamic> crop) => new Crops(
      id: crop["c_id"],
      name: crop["c_name"],
      image: crop["c_image"],
      family: crop["f_id"]);

  Map<String, dynamic> toMap() =>
      {"c_id": id, "c_name": name, "c_image": image, "f_id": family};
}
