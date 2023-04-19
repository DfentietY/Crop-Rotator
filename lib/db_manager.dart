import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:crop_rot/model/crops.dart';
import 'package:crop_rot/model/family.dart';

class DBManager {
  static Database _db;
  static DBManager dbManager;

  static String _dbName = "cr.db";

  static Future<Database> get db async {
    if (_db != null)
      return _db;
    else {
      _db = await initializeDB();
      return _db;
    }
  }

  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, _dbName);
    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  static Future<bool> doesDatabaseExist() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await databaseExists(path);
  }

  static void _createDB(Database db, int version) async {
    String sql1 = '''CREATE TABLE family (
                                      f_id text PRIMARY KEY,
                                      f_name text)''';
    String sql2 = '''CREATE TABLE crops (
                                      c_id text PRIMARY KEY,
                                      c_name text, 
                                      c_image text,
                                      f_id text,
                                      FOREIGN KEY(f_id) REFERENCES family (f_id))''';
    String sql3 = '''CREATE TABLE mycrops (
                                      c_id text PRIMARY KEY, 
                                      mc_sowmonths text, 
                                      mc_harvestmonths text, 
                                      mc_numtimes integer,
                                      FOREIGN KEY(c_id) REFERENCES crops (c_id))''';
    String sql4 = '''CREATE TABLE rotation (
                                      r_id text PRIMARY KEY, 
                                      r_numCrops text)''';
    String sql5 = '''CREATE TABLE cropsinrotation (
                                      r_id text, 
                                      c_id text,
                                      PRIMARY KEY(r_id, c_id),
                                      FOREIGN KEY(r_id) REFERENCES rotation (r_id),
                                      FOREIGN KEY(c_id) REFERENCES crops (c_id))''';
    Batch b = db.batch();
    
    b.execute(sql1);
    b.execute(sql2);
    b.execute(sql3);
    b.execute(sql4);
    b.execute(sql5);

    b.commit(noResult: true);
  }

  static Future<bool> doCropsExist() async{
    Database db = await DBManager.db;
    var result = await db.rawQuery("SELECT * FROM crops");
    return result.length > 0;
  }

  static void insertCrops(List<Crops> crops) async {
    Database db = await DBManager.db;
    Batch batch = db.batch();
    batch.delete("crops");
    crops.forEach((crop) {
      batch.insert("crops", crop.toMap());
    });
    await batch.commit(noResult: true);
  }

  static void insertFamilies(List<Family> families) async {
    Database db = await DBManager.db;
    Batch batch = db.batch();
    batch.delete("family");
    families.forEach((family) {
      batch.insert("family", family.toMap());
    });
    await batch.commit(noResult: true);
  }
}
