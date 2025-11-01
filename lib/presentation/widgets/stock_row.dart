import 'package:flutter/material.dart';

class StockRow extends StatelessWidget {
  final List<String> stocks;

  const StockRow({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: stocks.take(3).map((stock) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            stock,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
