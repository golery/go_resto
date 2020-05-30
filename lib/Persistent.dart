import 'dart:async';
import 'dart:convert';

import 'package:goresto/Model.dart';
import 'package:goresto/service/Factory.dart';

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
    persistence.settings = repo.settings;

    var jsonTxt = json.encode(persistence.toJson());
    Storage.get().write(FILE, jsonTxt);
  }

  static Future<bool> load() async {
    var jsonTxt = await Storage.get().read(FILE);
    print('Loaded $jsonTxt');
    var jsonData = json.decode(jsonTxt);
    var repo = Repository.get();

    var persistence = Persistence.fromJson(jsonData);
    factory.analytics
        .logEvent(name: "evLoadFormat ${persistence.formatVersion ?? 0}");

    repo.tables = persistence.tables;
    repo.dishCategories = persistence.categories;
    repo.currentOrders = {};
    repo.settings = persistence.settings ?? new Settings();

    persistence.orders.forEach((order) {
      repo.currentOrders[order.tableId] = order;
    });
    return true;
  }
}
