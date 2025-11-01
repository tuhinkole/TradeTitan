import 'package:cloud_firestore/cloud_firestore.dart';

class Bucket {
  final String id;
  final String name;
  final String strategy;
  final String manager;
  final String rationale;
  final double volatility;
  final double minInvestment;
  final Map<String, double> allocation;
  final Map<String, double> returns;
  final int stockCount;
  final String rebalanceFrequency;
  final DateTime lastRebalance;
  final DateTime nextRebalance;
  final Map<String, double> holdingsDistribution;
  final String description;
  final List<String> topStocks;

  Bucket({
    this.id = '', // Not required for new buckets
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
    this.description = '',
    this.topStocks = const [],
  });

  factory Bucket.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Bucket(
      id: snapshot.id,
      name: data['name'] ?? '',
      strategy: data['strategy'] ?? '',
      manager: data['manager'] ?? 'TradeTitan Team',
      rationale: data['rationale'] ?? '',
      volatility: (data['volatility'] ?? 0.0).toDouble(),
      minInvestment: (data['minInvestment'] ?? 0.0).toDouble(),
      allocation: Map<String, double>.from(data['allocation'] ?? {}),
      returns: Map<String, double>.from(data['returns'] ?? {'1Y': 0.0}),
      stockCount: data['stockCount'] ?? 0,
      rebalanceFrequency: data['rebalanceFrequency'] ?? '',
      lastRebalance: (data['lastRebalance'] as Timestamp?)?.toDate() ?? DateTime.now(),
      nextRebalance: (data['nextRebalance'] as Timestamp?)?.toDate() ?? DateTime.now(),
      holdingsDistribution: Map<String, double>.from(data['holdingsDistribution'] ?? {}),
      description: data['description'] ?? '',
      topStocks: List<String>.from(data['topStocks'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'strategy': strategy,
      'manager': manager,
      'rationale': rationale,
      'volatility': volatility,
      'minInvestment': minInvestment,
      'allocation': allocation,
      'returns': returns,
      'stockCount': stockCount,
      'rebalanceFrequency': rebalanceFrequency,
      'lastRebalance': lastRebalance,
      'nextRebalance': nextRebalance,
      'holdingsDistribution': holdingsDistribution,
      'description': description,
      'topStocks': topStocks,
    };
  }
}
