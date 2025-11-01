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

  // Determines the color based on the CAGR value
  Color _getCagrColor(double? cagr) {
    if (cagr == null) {
      return Colors.blue; // Neutral
    }
    if (cagr > 0) {
      return Colors.green;
    } else if (cagr < 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cagr = bucket.returns.containsKey('1Y') ? bucket.returns['1Y'] : null;
    final cagrText = cagr != null
        ? '${(cagr * 100).toStringAsFixed(2)}%'
        : 'N/A';
    final cagrColor = _getCagrColor(cagr);

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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      bucket.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.shopping_basket,
                    color: _getVolatilityColor(bucket.volatility),
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: theme.hintColor),
                  const SizedBox(width: 4),
                  Text(
                    bucket.author,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: const Color.fromARGB(255, 209, 155, 61), // Light Orange
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                bucket.rationale,
                style: theme.textTheme.bodyMedium,
                maxLines: 3, // Changed to 3 lines
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              StockRow(stocks: bucket.topStocks),
              const Spacer(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(context, 'CAGR (1Y)', cagrText, cagrColor),
                  _buildStatColumn(
                    context,
                    'Volatility',
                    '${bucket.volatility.toStringAsFixed(2)}%',
                    volatilityColor,
                  ),
                  _buildStatColumn(
                    context,
                    'Min. Invest',
                    '\$${bucket.minInvestment.toStringAsFixed(0)}',
                    theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String title,
    String value,
    Color valueColor,
  ) {
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
            fontSize: 14,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
