/// bucket.dart
///
/// This file defines the [Bucket] class, which is the core data model for the
/// Investment Buckets application. It uses json_serializable for automatic
/// conversion to and from JSON.
library;

import 'package:json_annotation/json_annotation.dart';

part 'bucket.g.dart';

/// Represents an investment bucket with its associated properties.
@JsonSerializable()
class Bucket {
  /// The unique identifier for the bucket, typically assigned by Firestore.
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? id;

  /// The name of the investment bucket (e.g., "Conservative Growth").
  final String name;

  /// The investment strategy for the bucket (e.g., "Low-risk, long-term growth").
  final String strategy;

  /// The manager of the investment bucket (e.g., "Warren B.").
  final String manager;

  /// The rationale behind the investment strategy.
  final String rationale;

  /// The volatility of the bucket, typically represented as a decimal.
  final double volatility;

  /// The minimum investment amount required for the bucket.
  final double minInvestment;

  /// A map representing the asset allocation of the bucket (e.g., {'GOOGL': 0.3}).
  final Map<String, double> allocation;

  /// A map representing the historical returns of the bucket (e.g., {'1Y': 0.12}).
  final Map<String, double> returns;

  /// The number of stocks in the bucket.
  final int stockCount;

  /// The rebalance frequency of the bucket.
  final String rebalanceFrequency;

  /// The date of the last rebalance.
  final DateTime lastRebalance;

  /// The date of the next rebalance.
  final DateTime nextRebalance;

  /// A map representing the holdings distribution of the bucket (e.g., {'Largecap': 0.8}).
  final Map<String, double> holdingsDistribution;

  /// Creates a [Bucket] object.
  Bucket({
    this.id,
    required this.name,
    required this.strategy,
    required this.manager,
    required this.rationale,
    required this.volatility,
    required this.minInvestment,
    required this.allocation,
    required this.returns,
    required this.stockCount,
    required this.rebalanceFrequency,
    required this.lastRebalance,
    required this.nextRebalance,
    required this.holdingsDistribution,
  });

  /// Creates a [Bucket] from a JSON map.
  factory Bucket.fromJson(Map<String, dynamic> json) => _$BucketFromJson(json);

  /// Converts this [Bucket] object into a JSON map.
  Map<String, dynamic> toJson() => _$BucketToJson(this);

  /// Creates a copy of this [Bucket] instance with the given fields replaced
  /// with new values.
  Bucket copyWith({
    String? id,
    String? name,
    String? strategy,
    String? manager,
    String? rationale,
    double? volatility,
    double? minInvestment,
    Map<String, double>? allocation,
    Map<String, double>? returns,
    int? stockCount,
    String? rebalanceFrequency,
    DateTime? lastRebalance,
    DateTime? nextRebalance,
    Map<String, double>? holdingsDistribution,
  }) {
    return Bucket(
      id: id ?? this.id,
      name: name ?? this.name,
      strategy: strategy ?? this.strategy,
      manager: manager ?? this.manager,
      rationale: rationale ?? this.rationale,
      volatility: volatility ?? this.volatility,
      minInvestment: minInvestment ?? this.minInvestment,
      allocation: allocation ?? this.allocation,
      returns: returns ?? this.returns,
      stockCount: stockCount ?? this.stockCount,
      rebalanceFrequency: rebalanceFrequency ?? this.rebalanceFrequency,
      lastRebalance: lastRebalance ?? this.lastRebalance,
      nextRebalance: nextRebalance ?? this.nextRebalance,
      holdingsDistribution: holdingsDistribution ?? this.holdingsDistribution,
    );
  }
}
