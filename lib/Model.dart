import 'package:json_annotation/json_annotation.dart';

import 'Utils.dart';

part 'Model.g.dart';

@JsonSerializable()
class RestoTable {
  String id = Uuid.v4();
  String name;
  num maxPeople;
  String orderId;

  RestoTable(this.name, this.maxPeople);

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

enum ItemStatus { ORDER, COOK, READY, SERVED }

@JsonSerializable()
class OrderItem {
  String id = Uuid.v4();
  String dishId;
  num quantity = 0;
  String notes;
  ItemStatus status = ItemStatus.ORDER;

  OrderItem(this.dishId);

  OrderItem.from(OrderItem other) {
    id = other.id;
    dishId = other.dishId;
    quantity = other.quantity;
    notes = other.notes;
    status = other.status;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable()
class Order {
  String id = Uuid.v4();
  num seqId;
  final String tableId;

  Order(this.tableId);

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
      new RestoTable('01', 4),
      new RestoTable('02', 4),
      new RestoTable('03', 2)
    ];

    var dish1 = new Dish('Brisket Plate', 20);
    var dish2 = new Dish('Slice of Homemade Pecan Pie', 5);
    dishCategories = [
      new DishCategory('Plates', [
        dish1,
        new Dish('Pork Ribs Plate', 19),
        new Dish('Sausage Plate', 25),
        new Dish('Turkey Plate', 18),
        new Dish('1/2 Of A Whole Chicken Plate', 22),
      ]),
      new DishCategory('Desserts', [
        dish2,
        new Dish('Slice of Chocolate Pecan Pie', 6),
        new Dish('Blackberry or Peach Cobbler ', 5.5),
      ])
    ];

    var tableId = tables[0].id;
    Order order = Order(tableId);
    OrderItem item1 = new OrderItem(dish1.id);
    item1.quantity = 1;
    item1.status = ItemStatus.ORDER;
    OrderItem item2 = new OrderItem(dish2.id);
    item2.quantity = 1;
    item2.status = ItemStatus.READY;
    order.items = [item1, item2];
    currentOrders[tableId] = order;
  }

  Order getCurrentOrder(String tableId) {
    return currentOrders[tableId];
  }

  void setCurrentOrder(String tableId, Order order) {
    currentOrders[tableId] = order;
  }

  Dish getDish(String dishId) {
    return dishCategories
        .map((cat) => cat.dishes
            .firstWhere((dish) => dish.id == dishId, orElse: () => null))
        .firstWhere((dish) => dish != null, orElse: () => null);
  }

  void closeTable(String tableId) {
    currentOrders[tableId] = null;
  }
}
