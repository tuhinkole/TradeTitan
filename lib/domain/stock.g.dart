// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) => Stock(
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
  'symbol': instance.symbol,
  'name': instance.name,
  'price': instance.price,
};
