import 'package:xml/xml.dart';

import 'package:crop_rot/model/crops.dart';

class XML {
  static String _xml = '''<?xml version=1.0 ?>
                            <crops>
                              <crop>
                                <id>01</id>
                                <name>Beetroot</name>
                                <image>images/beetroot.png</image>
                                <family>03</family>
                              </crop>
                              <crop>
                                <id>02</id>
                                <name>Cabbage</name>
                                <image>images/cabbage.png</image>
                                <family>02</family>
                              </crop>
                              <crop>
                                <id>03</id>
                                <name>Carrots</name>
                                <image>images/carrots.png</image>
                                <family>03</family>
                              </crop>
                              <crop>
                                <id>04</id>
                                <name>Cauliflower</name>
                                <image>images/cauliflower.png</image>
                                <family>02</family>
                              </crop>
                              <crop>
                                <id>05</id>
                                <name>Cucumber</name>
                                <image>images/cucumber.png</image>
                                <family>06</family>
                              </crop>
                              <crop>
                                <id>06</id>
                                <name>Garlic</name>
                                <image>images/garlic.png</image>
                                <family>03</family>
                              </crop>
                              <crop>
                                <id>07</id>
                                <name>Lettuce</name>
                                <image>images/lettuce.png</image>
                                <family>02</family>
                              </crop>
                              <crop>
                                <id>08</id>
                                <name>Onion</name>
                                <image>images/onions.png</image>
                                <family>03</family>
                              </crop>
                              <crop>
                                <id>09</id>
                                <name>Peas</name>
                                <image>images/peas.png</image>
                                <family>01</family>
                              </crop>
                              <crop>
                                <id>10</id>
                                <name>Potatoes</name>
                                <image>images/potatoes.png</image>
                                <family>04</family>
                              </crop>
                              <crop>
                                <id>11</id>
                                <name>Tomatoes</name>
                                <image>images/tomatoes.png</image>
                                <family>04</family>
                              </crop>
                            </crops>''';

  static List<Crops> _crops = List();

  static getCrops () {
    var xmlfile = parse(_xml);
    Iterable<XmlElement> items = xmlfile.findAllElements('crop');
    items.map((XmlElement item) {
      var id = _getValue(item.findElements("id"));
      var name = _getValue(item.findElements("name"));
      var image = _getValue(item.findElements("image"));
      var family = _getValue(item.findElements("family"));
      _crops.add(Crops(id: id, name: name, image: image, family: family));
    }).toList();

    return _crops;
  }

  static _getValue(Iterable<XmlElement> items) {
    var textValue;
    items.map((XmlElement node) {
      textValue = node.text;
    }).toList();
    return textValue;
  }
}