import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:tradetitan/domain/bucket.dart';
import 'package:tradetitan/presentation/screens/bucket_detail_screen.dart';

class BucketCard extends StatelessWidget {
  final Bucket bucket;

  const BucketCard({super.key, required this.bucket});

  @override
  Widget build(BuildContext context) {
    // Check if the returns data is available
    final returnsAvailable =
        bucket.returns.containsKey('1Y') && bucket.returns['1Y'] != null;
    final cagrText = returnsAvailable
        ? '${(bucket.returns['1Y']! * 100).toStringAsFixed(2)}%'
        : 'N/A';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BucketDetailScreen(bucket: bucket),
          ),
        );
      },
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 200,
        borderRadius: 12,
        blur: 10,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0.1),
            Theme.of(context).colorScheme.surface.withOpacity(0.2),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.show_chart, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bucket.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          bucket.strategy,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'by ${bucket.manager}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    'Min. Amount',
                    '₹ ${bucket.minInvestment.toStringAsFixed(0)}',
                    context,
                  ),
                  _buildInfoColumn('3Y CAGR', cagrText, context),
                  Chip(
                    label: Text(_getVolatilityLabel(bucket.volatility)),
                    backgroundColor: _getVolatilityColor(bucket.volatility),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  String _getVolatilityLabel(double volatility) {
    if (volatility < 0.3) {
      return 'Low Volatility';
    } else if (volatility < 0.6) {
      return 'Med. Volatility';
    } else {
      return 'High Volatility';
    }
  }

  Color _getVolatilityColor(double volatility) {
    if (volatility < 0.3) {
      return Colors.green;
    } else if (volatility < 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
