import 'package:crop_rot/db_manager.dart';
import 'package:sqflite/sqflite.dart';

import 'package:crop_rot/model/mycrops.dart';
import 'package:crop_rot/model/family.dart';

class Rotation {
  var id;
  List<MyCrops> myCrops;

  Rotation({this.id, this.myCrops});

  factory Rotation.fromMap(rotation) {
    List<MyCrops> mcrops = List();
    getRotation(rotation["r_id"]).then((Rotation r) {
      mcrops = r.myCrops;
    });

    return new Rotation(id: rotation["r_id"], myCrops: mcrops);
  }

  factory Rotation.fromMapWithoutCrops(rotation) =>
      new Rotation(id: rotation["r_id"], myCrops: List());

  int getID() {
    return int.parse(id.toString());
  }

  int getCropsLength() {
    return myCrops.length;
  }

  static void insertRotation(Rotation rotation) async {
    Database db = await DBManager.db;
    Batch batch = db.batch();

    String query = '''INSERT INTO rotation (r_id, r_numCrops)
                    VALUES (?, ?)
                  ''';

    batch.rawInsert(query, [rotation.getID(), rotation.myCrops.length]);

    query = '''INSERT INTO cropsinrotation (r_id, c_id)
              VALUES (?, ?)
          ''';

    rotation.myCrops.forEach((crop) {
      batch.rawInsert(query, [rotation.getID(), crop.id]);
    });

    await batch.commit(noResult: true, continueOnError: true);
  }

  Map<String, dynamic> toMap() => {"r_id": id, "r_numCrops": myCrops.length};

  static Future<Rotation> calculateRotation(List<MyCrops> crops) async {
    Rotation rotat = new Rotation();
    List<MyCrops> myCrops = List();
    int tracker = 0;

    //insert the first crop in the rotation
    myCrops.add(crops.first);
    crops.removeAt(0);
    //do while some crops are still not in the rotation
    do {
      //check name of previous plant and compare with any potential crops to see which is best
      await rotateCrop(myCrops, tracker, crops);

      if (crops.length == 1) {
        if (!myCrops.contains(crops.first)) {
          myCrops.add(crops.first);
          crops.remove(crops.first);
        }
      }
      tracker++;
    } while (crops.isNotEmpty);

    print('My Crops: ' + myCrops.length.toString());
    Database db = await DBManager.db;
    print('Initialized Database');
    int id = 0;

    id = await getMaxRotationID(db) + 1;

    rotat = new Rotation(id: id, myCrops: myCrops);
    Rotation.insertRotation(rotat);

    return (rotat != null) ? rotat : null;
  }

  static Future rotateCrop(
      List<MyCrops> myCrops, int tracker, List<MyCrops> crops) async {
    String familyName =
        await Family.getFamilyNameByCropId(myCrops.elementAt(tracker).getID());
    switch (familyName) {
      case "Legumes":
        myCrops.add(
          await _getNextPlant(
            crops,
            familyNames: ["Brassicas", "Cucurbits", "Leafy crops"],
          ),
        );
        break;
      case "Brassicas":
        myCrops.add(
          await _getNextPlant(
            crops,
            familyNames: ["Root crops", "Cucurbits", "Legumes"],
          ),
        );
        break;
      case "Root Crops":
        myCrops.add(
          await _getNextPlant(
            crops,
            familyNames: ["Solanaceae", "Brassicas", "Cucurbits"],
          ),
        );
        break;
      case "Solanaceae":
        myCrops.add(
          await _getNextPlant(
            crops,
            familyNames: ["Leafy crops", "Cucurbits", "Root crops"],
          ),
        );
        break;
      case "Leafy Crops":
        myCrops.add(
          await _getNextPlant(
            crops,
            familyNames: ["Legumes", "Cucurbits", "Solanaceae"],
          ),
        );
        break;
      case "Cucurbits":
        myCrops.add(
          await _getNextPlant(
            crops,
            familyNames: [
              "Legumes",
              "Brassicas",
              "Root crops",
              "Solanaceae",
              "Leafy crops"
            ],
          ),
        );
        break;
      default:
        print("Unknown Option");
        break;
    }
  }

  static Future<MyCrops> _getNextPlant(List<MyCrops> crops,
      {List<String> familyNames}) async {
    MyCrops newCrop = new MyCrops();
    int i = 0;
    while (crops.isNotEmpty) {
      bool cropReturned = await _loopThroughList(crops[i], familyNames);
      newCrop = (cropReturned) ? crops[i] : newCrop;
      if (crops.contains(newCrop)) {
        crops.removeAt(i);
        break;
      }

      if (i >= crops.length - 1) {
        i = 0;
        continue;
      }
      i++;
    }
    return newCrop;
  }

  static Future<bool> _loopThroughList(
      MyCrops crop, List<String> famNames) async {
    String famName = await Family.getFamilyNameByCropId(crop.id);
    if (famNames.contains(famName)) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Rotation> getRotation(id) async {
    Rotation rot = new Rotation();
    List<MyCrops> myCrops = [];

    Database db = await DBManager.db;
    var result =
        await db.query('cropsinrotation', where: 'r_id = ?', whereArgs: [id]);

    await _populateMyCrops(result, myCrops);
    //print('The list of crops has this many: ' + myCrops.length.toString());
    rot = new Rotation(id: id, myCrops: myCrops);

    return rot;
  }

  static _populateMyCrops(result, myCrops) {
    result.map((crop) async {
      //get the crops based on the id gotten from the database
      myCrops.add(await MyCrops.getCrop(Rotation.fromMap(crop).id));
      //insert them in the rotation list
    }).toList();
  }

  static Future<Rotation> getLastRotation() async {
    int id = 0;
    int maxID = 0;

    Database db = await DBManager.db;

    maxID = await getMaxRotationID(db);

    id = await getRotationID(db, maxID);

    if (id > 0) {
      return await getRotation(id);
    } else {
      return null;
    }
  }

  static Future<int> getRotationID(Database db, int maxID) async {
    var result = await db.query('rotation',
        columns: ["r_id"], where: "r_id = ?", whereArgs: [maxID]);

    if (result.length > 0) {
      return int.parse(result.first["r_id"]);
    }
    return 1;
  }

  static Future<int> getMaxRotationID(Database db) async {
    var maxResult = await db.rawQuery("SELECT MAX(r_id) FROM rotation");

    return (maxResult.first['MAX(r_id)'] != null)
        ? int.parse(maxResult.first['MAX(r_id)'])
        : 0;
  }
}
