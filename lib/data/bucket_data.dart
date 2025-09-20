import 'package:tradetitan/domain/bucket.dart';

final List<Bucket> initialBuckets = [
  Bucket(
    name: 'Zero Debt Model',
    strategy:
        'Zero debt, high ROE companies with an established track record of high earnings growth',
    manager: 'Windmill Capital',
    rationale:
        'Focus on companies with strong fundamentals and a history of stable returns. Ideal for capital preservation.',
    volatility: 0.15,
    minInvestment: 65180.0,
    allocation: {'GOOGL': 0.3, 'AAPL': 0.4, 'MSFT': 0.3},
    returns: {'1Y': 0.12},
    stockCount: 12,
    rebalanceFrequency: 'Annual',
    lastRebalance: DateTime(2025, 9, 3),
    nextRebalance: DateTime(2026, 9, 3),
    holdingsDistribution: {
      'Largecap': 0.0833,
      'Midcap': 0.3333,
      'Smallcap': 0.5833,
    },
  ),
  Bucket(
    name: 'Growth & Income Model',
    strategy:
        'Efficiently managed dividend paying companies at attractive valuations',
    manager: 'Windmill Capital',
    rationale:
        'Diversified across sectors to balance risk and capture market growth. Suitable for most investors.',
    volatility: 0.35,
    minInvestment: 39702.0,
    allocation: {'VTI': 0.5, 'BND': 0.3, 'VXUS': 0.2},
    returns: {'1Y': 0.18},
    stockCount: 15,
    rebalanceFrequency: 'Quarterly',
    lastRebalance: DateTime(2024, 3, 15),
    nextRebalance: DateTime(2024, 6, 15),
    holdingsDistribution: {'Largecap': 0.6, 'Midcap': 0.3, 'Smallcap': 0.1},
  ),
  Bucket(
    name: 'Safe Haven Model',
    strategy:
        'Low beta stocks that are rated `BUY`, to help protect against market volatility',
    manager: 'Windmill Capital',
    rationale:
        'Invests in disruptive innovation in fields like AI, blockchain, and genomics. High potential for growth and volatility.',
    volatility: 0.75,
    minInvestment: 29631.0,
    allocation: {'TSLA': 0.4, 'NVDA': 0.3, 'ARKK': 0.3},
    returns: {'1Y': 0.45},
    stockCount: 10,
    rebalanceFrequency: 'Monthly',
    lastRebalance: DateTime(2024, 5, 1),
    nextRebalance: DateTime(2024, 6, 1),
    holdingsDistribution: {'Largecap': 0.2, 'Midcap': 0.4, 'Smallcap': 0.4},
  ),
];
