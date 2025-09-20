import 'package:json_annotation/json_annotation.dart';

part 'stock.g.dart';

@JsonSerializable()
class Stock {
  final String symbol;
  final String name;
  final double price;

  Stock({required this.symbol, required this.name, required this.price});

  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);
  Map<String, dynamic> toJson() => _$StockToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stock &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol;

  @override
  int get hashCode => symbol.hashCode;
}
