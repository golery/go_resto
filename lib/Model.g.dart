// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
