// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoTable _$RestoTableFromJson(Map<String, dynamic> json) {
  return RestoTable(
    json['name'] as String,
    json['maxPeople'] as num,
  )
    ..id = json['id'] as String
    ..orderId = json['orderId'] as String;
}

Map<String, dynamic> _$RestoTableToJson(RestoTable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'maxPeople': instance.maxPeople,
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
    ..notes = json['notes'] as String
    ..status = _$enumDecodeNullable(_$ItemStatusEnumMap, json['status']);
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'dishId': instance.dishId,
      'quantity': instance.quantity,
      'notes': instance.notes,
      'status': _$ItemStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ItemStatusEnumMap = {
  ItemStatus.ORDER: 'ORDER',
  ItemStatus.COOK: 'COOK',
  ItemStatus.READY: 'READY',
  ItemStatus.SERVED: 'SERVED',
};

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    json['tableId'] as String,
  )
    ..id = json['id'] as String
    ..seqId = json['seqId'] as num
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
