// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bucket _$BucketFromJson(Map<String, dynamic> json) => Bucket(
  name: json['name'] as String,
  strategy: json['strategy'] as String,
  manager: json['manager'] as String,
  rationale: json['rationale'] as String,
  volatility: (json['volatility'] as num).toDouble(),
  minInvestment: (json['minInvestment'] as num).toDouble(),
  allocation: (json['allocation'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  returns: (json['returns'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  stockCount: (json['stockCount'] as num).toInt(),
  rebalanceFrequency: json['rebalanceFrequency'] as String,
  lastRebalance: DateTime.parse(json['lastRebalance'] as String),
  nextRebalance: DateTime.parse(json['nextRebalance'] as String),
  holdingsDistribution: (json['holdingsDistribution'] as Map<String, dynamic>)
      .map((k, e) => MapEntry(k, (e as num).toDouble())),
);

Map<String, dynamic> _$BucketToJson(Bucket instance) => <String, dynamic>{
  'name': instance.name,
  'strategy': instance.strategy,
  'manager': instance.manager,
  'rationale': instance.rationale,
  'volatility': instance.volatility,
  'minInvestment': instance.minInvestment,
  'allocation': instance.allocation,
  'returns': instance.returns,
  'stockCount': instance.stockCount,
  'rebalanceFrequency': instance.rebalanceFrequency,
  'lastRebalance': instance.lastRebalance.toIso8601String(),
  'nextRebalance': instance.nextRebalance.toIso8601String(),
  'holdingsDistribution': instance.holdingsDistribution,
};
