import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

Storage _instance = new Storage();

class Storage {
  static Storage get() {
    return _instance;
  }

  void write(String filename, String s) async {
    File file = await _getFile(filename);
    file.writeAsStringSync(s);
  }

  Future<String> read(String filename) async {
    File file = await _getFile(filename);
    return file.readAsString();
  }

  Future<String> _localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String filename) async {
    String path = await _localPath();
    File file = new File('$path/$filename');
    return file;
  }
}
