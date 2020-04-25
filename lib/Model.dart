import 'Utils.dart';
import 'dart:convert';

class RestoTable {
  String id = Uuid.v4();
  String name;

  RestoTable(this.name);
}

class DishCategory {
  String id = Uuid.v4();
  String name;
  List<Dish> dishes = [];

  DishCategory(this.name, this.dishes);
}

class Dish {
  String id = Uuid.v4();
  String name;
  double price;
  String description;
  String fullName;

  Dish(this.name, this.price, {this.description, this.fullName});
}

class Order {
  String id = Uuid.v4();
  final String tableId;

  Order(this.tableId);

  // Map from dishId to quantity
  Map<String, int> dishes = {};
}

class Repository {
  static Repository _instance = new Repository();

  static Repository get() {
    return _instance;
  }

  Map<String, Order> currentOrders = {};

  void setSampleData() {
    tables = [
      new RestoTable('Table 1'),
      new RestoTable('Table 2'),
      new RestoTable('Table 3')
    ];

    dishCategories = [
      new DishCategory('Plates', [
        new Dish('Brisket Plate', 9.5),
        new Dish('Pork Ribs Plate', 10.9),
        new Dish('Sausage Plate', 5.2),
        new Dish('Turkey Plate', 3.4),
        new Dish('1/2 Of A Whole Chicken Plate', 4.5),
      ]),
      new DishCategory('Desserts', [
        new Dish('Slice of Homemade Pecan Pie', 10.9),
        new Dish('Slice of Chocolate Pecan Pie', 8.9),
        new Dish('Blackberry or Peach Cobbler ', 9.2),
      ])
    ];
  }

  Order getCurrentOrder(String tableId) {
    return currentOrders[tableId];
  }

  void setCurrentOrder(String tableId, Order order) {
    currentOrders[tableId] = order;
  }

  List<RestoTable> tables;
  List<DishCategory> dishCategories;
}
