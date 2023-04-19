import 'package:crop_rot/db_manager.dart';
import 'package:sqflite/sqflite.dart';

class MyCrops {
  var id;
  var sowMonths;
  var harvestMonths;
  var numTimesInRotation;

  MyCrops({this.id});
  MyCrops.all({
    this.id,
    this.sowMonths,
    this.harvestMonths,
    this.numTimesInRotation,
  });

  factory MyCrops.fromMap(mycrop) => new MyCrops.all(
      id: mycrop["c_id"],
      sowMonths: mycrop["mc_sowmonths"],
      harvestMonths: mycrop["mc_harvestmonths"],
      numTimesInRotation: mycrop["mc_numtimes"]);

  Map<String, dynamic> toMap() => {
        "c_id": id,
        "mc_sowMonths": sowMonths,
        "mc_harvestMonths": harvestMonths,
        "mc_numTimes": numTimesInRotation
      };

  String getID() {
    return id;
  }

  static Future<List<MyCrops>> getAllCrops() async {
    Database db = await DBManager.db;
    List<MyCrops> mycrops = List<MyCrops>();
    var result = await db.query("mycrops");

    result.map((mycrop) {
      mycrops.add(MyCrops.fromMap(mycrop));
    }).toList();

    return mycrops;
  }

  static Future<MyCrops> getCrop(id) async {
    Database db = await DBManager.db;
    MyCrops crop = MyCrops();
    var result = await db.query('mycrops', where: 'c_id = ?', whereArgs: [id]);

    if (result.length > 0) {
      crop = MyCrops.fromMap(result.first);
    }
    return crop;
  }

  static void saveAllCrops(List<MyCrops> mycrops) async {
    Database db = await DBManager.db;
    Batch batch = db.batch();

    batch.delete("mycrops");
    mycrops.forEach((mycrop) {
      batch.insert("mycrops", mycrop.toMap());
    });

    await batch.commit(noResult: true);
  }
}
