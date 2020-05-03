// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoTable _$RestoTableFromJson(Map<String, dynamic> json) {
  return RestoTable(
    json['name'] as String,
  )
    ..id = json['id'] as String
    ..orderId = json['orderId'] as String;
}

Map<String, dynamic> _$RestoTableToJson(RestoTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'orderId': instance.orderId,
    };

DishCategory _$DishCategoryFromJson(Map<String, dynamic> json) {
  return DishCategory(
    json['name'] as String,
    (json['dishes'] as List)
        ?.map(
            (e) => e == null ? null : Dish.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..id = json['id'] as String;
}

Map<String, dynamic> _$DishCategoryToJson(DishCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dishes': instance.dishes,
    };

Dish _$DishFromJson(Map<String, dynamic> json) {
  return Dish(
    json['name'] as String,
    (json['price'] as num)?.toDouble(),
    description: json['description'] as String,
    fullName: json['fullName'] as String,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$DishToJson(Dish instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'fullName': instance.fullName,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    json['dishId'] as String,
  )
    ..quantity = json['quantity'] as num
    ..notes = json['notes'] as String;
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'dishId': instance.dishId,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    json['seqId'] as num,
    json['tableId'] as String,
  )
    ..id = json['id'] as String
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : OrderItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'seqId': instance.seqId,
      'tableId': instance.tableId,
      'items': instance.items,
    };

Persistence _$PersistenceFromJson(Map<String, dynamic> json) {
  return Persistence()
    ..tables = (json['tables'] as List)
        ?.map((e) =>
            e == null ? null : RestoTable.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..categories = (json['categories'] as List)
        ?.map((e) =>
            e == null ? null : DishCategory.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..orders = (json['orders'] as List)
        ?.map(
            (e) => e == null ? null : Order.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..orderIdSeq = json['orderIdSeq'] as num;
}

Map<String, dynamic> _$PersistenceToJson(Persistence instance) =>
    <String, dynamic>{
      'tables': instance.tables,
      'categories': instance.categories,
      'orders': instance.orders,
      'orderIdSeq': instance.orderIdSeq,
    };
