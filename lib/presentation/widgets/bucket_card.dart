import 'package:flutter/material.dart';
import 'package:tradetitan/domain/bucket.dart';
import 'package:tradetitan/presentation/screens/bucket_detail_screen.dart';
import 'package:tradetitan/presentation/widgets/stock_row.dart';

class BucketCard extends StatelessWidget {
  final Bucket bucket;

  const BucketCard({super.key, required this.bucket});

  // Determines the color based on the volatility value
  Color _getVolatilityColor(double volatility) {
    if (volatility < 10) {
      return Colors.green; // Low risk
    } else if (volatility >= 10 && volatility <= 20) {
      return Colors.orange; // Medium risk
    } else {
      return Colors.red; // High risk
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cagrText = bucket.returns.containsKey('1Y') && bucket.returns['1Y'] != null
        ? '${(bucket.returns['1Y']! * 100).toStringAsFixed(2)}%'
        : 'N/A';

    final volatilityColor = _getVolatilityColor(bucket.volatility);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BucketDetailScreen(bucket: bucket),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bucket.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                bucket.rationale,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              StockRow(stocks: bucket.topStocks),
              const Spacer(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(context, 'CAGR (1Y)', cagrText, Colors.green),
                  _buildStatColumn(context, 'Volatility', '${bucket.volatility.toStringAsFixed(2)}%', volatilityColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String title, String value, Color valueColor) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
