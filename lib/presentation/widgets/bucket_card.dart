import 'package:flutter/material.dart';
import 'package:tradetitan/domain/bucket.dart';
import 'package:tradetitan/presentation/screens/bucket_detail_screen.dart';

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
    final isDarkMode = theme.brightness == Brightness.dark;

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
      child: Container(
        height: 250, // Fixed height to prevent layout jumps
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          shadowColor: theme.colorScheme.primary.withOpacity(isDarkMode ? 0.7 : 0.4),
          child: Stack(
            children: [
              // --- Background Gradient --- //
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [theme.colorScheme.primary.withOpacity(0.6), Colors.black87]
                          : [theme.colorScheme.primary, theme.colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              // --- Redesigned Top Header --- //
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and Name on the left
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.business_center, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              bucket.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Investment amount on the right
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Min. Invest',
                          style: theme.textTheme.labelMedium?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\$${bucket.minInvestment.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Bottom Content Area --- //
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 145,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description (Rationale)
                      Text(
                        bucket.rationale,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Manager Name
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 16, color: theme.hintColor),
                          const SizedBox(width: 6),
                          Text(
                            bucket.manager, // Corrected to use 'manager'
                            style: theme.textTheme.labelLarge?.copyWith(color: theme.hintColor, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Divider(),
                      // Stats Row
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

              // --- Favorite Button with Yellow Glow Effect --- //
              Positioned(
                bottom: 122,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.8),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.amber),
                      onPressed: () {
                        // TODO: Handle favorite action
                      },
                    ),
                  ),
                ),
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
