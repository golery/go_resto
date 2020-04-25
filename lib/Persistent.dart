import 'Storage.dart';
import 'Serializer.dart';
import 'dart:convert';
import 'dart:async';
class Persistent {
  static void save() {
    var jsonTxt = json.encode(new Serializer().repoToJson());
    Storage.get().write('resto.txt', jsonTxt);
  }

  static Future<bool> load() async {
    var jsonTxt = await Storage.get().read('resto.txt');
    print('Loaded $jsonTxt');
    var jsonData = json.decode(jsonTxt);
    new Serializer().jsonToRepo(jsonData);
    return true;
  }
}