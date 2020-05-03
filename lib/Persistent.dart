import 'dart:async';
import 'dart:convert';

import 'package:goresto/Model.dart';

import 'Storage.dart';

class Persistent {
  static const String FILE = 'resto.txt';

  static void save() {
    var repo = Repository.get();
    Persistence persistence = Persistence();
    persistence.categories = repo.dishCategories;
    persistence.tables = repo.tables;
    persistence.orders = repo.currentOrders.values.toList();
    persistence.orderIdSeq = repo.orderIdSeq;

    var jsonTxt = json.encode(persistence.toJson());
    Storage.get().write(FILE, jsonTxt);
  }

  static Future<bool> load() async {
    var jsonTxt = await Storage.get().read(FILE);
    print('Loaded $jsonTxt');
    var jsonData = json.decode(jsonTxt);
    var persistence = Persistence.fromJson(jsonData);
    var repo = Repository.get();
    repo.tables = persistence.tables;
    repo.dishCategories = persistence.categories;
    repo.currentOrders = {};
    persistence.orders.forEach((order) {
      repo.currentOrders[order.tableId] = order;
    });
    return true;
  }
}
