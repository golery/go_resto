import 'package:json_annotation/json_annotation.dart';

import 'Utils.dart';

part 'Model.g.dart';

@JsonSerializable()
class RestoTable {
  String id = Uuid.v4();
  String name;
  String orderId;

  RestoTable(this.name);

  factory RestoTable.fromJson(Map<String, dynamic> json) =>
      _$RestoTableFromJson(json);

  Map<String, dynamic> toJson() => _$RestoTableToJson(this);
}

@JsonSerializable()
class DishCategory {
  String id = Uuid.v4();
  String name;
  List<Dish> dishes = [];

  DishCategory(this.name, this.dishes);

  factory DishCategory.fromJson(Map<String, dynamic> json) =>
      _$DishCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$DishCategoryToJson(this);
}

@JsonSerializable()
class Dish {
  String id = Uuid.v4();
  String name;
  double price;
  String description;
  String fullName;

  Dish(this.name, this.price, {this.description, this.fullName});

  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);

  Map<String, dynamic> toJson() => _$DishToJson(this);
}

@JsonSerializable()
class OrderItem {
  String dishId;
  num quantity = 0;
  String notes;

  OrderItem(this.dishId);

  OrderItem.from(OrderItem other) {
    dishId = other.dishId;
    quantity = other.quantity;
    notes = other.notes;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class Order {
  String id = Uuid.v4();
  final num seqId;
  final String tableId;

  Order(this.seqId, this.tableId);

  List<OrderItem> items = [];

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  findItemByDishId(String dishId) {
    return items.firstWhere((o) => o.dishId == dishId, orElse: () => null);
  }
}

/// This object is written to file
@JsonSerializable()
class Persistence {
  List<RestoTable> tables;
  List<DishCategory> categories;
  List<Order> orders;
  num orderIdSeq;

  Persistence();

  factory Persistence.fromJson(Map<String, dynamic> json) =>
      _$PersistenceFromJson(json);

  Map<String, dynamic> toJson() => _$PersistenceToJson(this);
}

class Repository {
  static Repository _instance = new Repository();

  static Repository get() {
    return _instance;
  }

  List<RestoTable> tables;
  List<DishCategory> dishCategories;
  Map<String, Order> currentOrders = {};
  num orderIdSeq = 1;

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
}
