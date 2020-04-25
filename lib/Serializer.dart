import 'Model.dart';

class Serializer {
  List _mapList(List list, f) {
    if (list == null) return null;
    var out = [];
    list.forEach((e) {
      if (e != null) {
        var v = f(e);
        out.add(v);
      }
    });
    return out;
  }

  _tableToJson(RestoTable table) {
    return {'id': table.id, 'name': table.name};
  }

  _dishToJson(Dish dish) {
    return {
      'id': dish.id,
      'name': dish.name,
      'price': dish.price,
      'fullName': dish.fullName,
      'description': dish.description
    };
  }

  _categoryToJson(DishCategory category) {
    return {
      'id': category.id,
      'name': category.name,
      'dishes': _mapList(category.dishes, _dishToJson)
    };
  }

  _orderToJson(Order order) {
    return {'id': order.id, 'tableId': order.tableId, 'dishes': order.dishes};
  }

  Map<String, dynamic> repoToJson() {
    var repo = Repository.get();
    return {
      'tables': _mapList(repo.tables, _tableToJson),
      'categories': _mapList(repo.dishCategories, _categoryToJson),
      'orders': _mapList(repo.currentOrders.values.toList(), _orderToJson)
    };
  }

  void jsonToRepo(Map<String, dynamic> map) {
    var repo = Repository.get();
    repo.tables =
        (map['tables'] as List<dynamic>).map((m) => _tableFromJson(m)).toList();
    repo.dishCategories = (map['categories'] as List<dynamic>)
        .map((m) => _categoryFromJson(m))
        .toList();

    var orders =
        (map['orders'] as List<dynamic>).map((m) => _orderFromJson(m)).toList();
    Map<String, Order> orderMap = {};
    orders.forEach((order) {
      orderMap[order.tableId] = order;
    });
    repo.currentOrders = orderMap;
    print('$orderMap');
  }

  Order _orderFromJson(Map<String, dynamic> map) {
    Order order = new Order(map['tableId']);
    order.id = map['id'];
    order.dishes = (map['dishes'] as Map<String, dynamic>).map((k, v) {
      int quantity = v;
      return new MapEntry(k, quantity);
    });
    return order;
  }

  RestoTable _tableFromJson(Map<String, dynamic> map) {
    var table = new RestoTable(map['name']);
    table.id = map['id'];
    return table;
  }

  DishCategory _categoryFromJson(Map<String, dynamic> map) {
    List<dynamic> dishesMap = map['dishes'];
    var dishes = dishesMap == null
        ? null
        : dishesMap.map((map) => _dishFromJson(map)).toList();
    var o = new DishCategory(map['name'], dishes);
    o.id = map['id'];
    return o;
  }

  Dish _dishFromJson(Map<String, dynamic> map) {
    var dish = new Dish(map['name'], map['price'],
        description: map['description'], fullName: map['fullName']);
    dish.id = map['id'];
    return dish;
  }
}
