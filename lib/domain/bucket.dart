import 'package:cloud_firestore/cloud_firestore.dart';

class Bucket {
  final String? id;
  final String name;
  final String strategy;
  final String manager;
  final String rationale;
  final double minInvestment;
  final double volatility;
  final int stockCount;
  final String rebalanceFrequency;
  final DateTime lastRebalance;
  final DateTime nextRebalance;
  final Map<String, double> allocation;
  final Map<String, double> holdingsDistribution;
  final Map<String, double> returns;

  Bucket({
    this.id,
    required this.name,
    required this.strategy,
    required this.manager,
    required this.rationale,
    required this.minInvestment,
    required this.volatility,
    required this.stockCount,
    required this.rebalanceFrequency,
    required this.lastRebalance,
    required this.nextRebalance,
    required this.allocation,
    required this.holdingsDistribution,
    required this.returns,
  });

  factory Bucket.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Bucket(
      id: snapshot.id,
      name: data['name'] ?? '',
      strategy: data['strategy'] ?? '',
      manager: data['manager'] ?? '',
      rationale: data['rationale'] ?? '',
      minInvestment: (data['minInvestment'] ?? 0).toDouble(),
      volatility: (data['volatility'] ?? 0).toDouble(),
      stockCount: data['stockCount'] ?? 0,
      rebalanceFrequency: data['rebalanceFrequency'] ?? '',
      lastRebalance: (data['lastRebalance'] as Timestamp).toDate(),
      nextRebalance: (data['nextRebalance'] as Timestamp).toDate(),
      allocation: Map<String, double>.from(data['allocation'] ?? {}),
      holdingsDistribution:
          Map<String, double>.from(data['holdingsDistribution'] ?? {}),
      returns: Map<String, double>.from(data['returns'] ?? {}),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'strategy': strategy,
      'manager': manager,
      'rationale': rationale,
      'minInvestment': minInvestment,
      'volatility': volatility,
      'stockCount': stockCount,
      'rebalanceFrequency': rebalanceFrequency,
      'lastRebalance': lastRebalance,
      'nextRebalance': nextRebalance,
      'allocation': allocation,
      'holdingsDistribution': holdingsDistribution,
      'returns': returns,
    };
  }
}
