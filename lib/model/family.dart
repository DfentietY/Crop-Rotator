import 'package:crop_rot/db_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

class Family {
  var id;
  var name;

  Family({this.id, this.name});

  factory Family.fromMap(family) => Family(id: "f_id", name: "f_name");

  Map<String, dynamic> toMap() => {"f_id": id, "f_name": name};

  static List<Family> getFamilies() {
    String _xml = '''<?xml version=1.0 ?>
                      <families>
                        <family>
                          <id>01</id>
                          <name>Legumes</name>
                        </family>
                        <family>
                          <id>02</id>
                          <name>Brassicas</name>
                        </family>
                        <family>
                          <id>03</id>
                          <name>Root Crops</name>
                        </family>
                        <family>
                          <id>04</id>
                          <name>Solanaceae</name>
                        </family>
                        <family>
                          <id>05</id>
                          <name>Leafy Crops</name>
                        </family>
                        <family>
                          <id>06</id>
                          <name>Cucurbits</name>
                        </family>
                      </families>''';
    List<Family> families = List();
    var xmlParse = parse(_xml);
    Iterable<XmlElement> items = xmlParse.findAllElements("family");
    items.map((item) {
      var id = _getValue(item.findElements("id"));
      var name = _getValue(item.findElements("name"));
      families.add(Family(id: id, name: name));
    }).toList();
    return families;
  }

  static _getValue(Iterable<XmlElement> items) {
    var textValue;
    items.map((XmlElement node) {
      textValue = node.text;
    }).toList();
    return textValue;
  }

  static Future<String> getFamilyName(idNum) async {
    Database db = await DBManager.db;
    var results;
    await db.transaction((txn) async {
      results = await txn.query(
        "family",
        where: "id = ?",
        whereArgs: idNum,
      );
    });
    return _decodeResultsForName(results.first["f_name"]);
  }

  static String _decodeResultsForName(results) {
    String name = results;
    return name;
  }

  static Future<String> getFamilyNameByCropId(id) async {
    Database db = await DBManager.db;
    var results;
    await db.transaction((txn) async {
      results = await txn.rawQuery('''SELECT *
                                     FROM family, crops
                                     WHERE family.f_id = crops.f_id
                                     AND crops.c_id = ?''', [id]);
    });

    return _decodeResultsForName(results.first["f_name"]);
  }
}
