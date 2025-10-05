import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradetitan/domain/bucket.dart';

class BucketDetailScreen extends StatelessWidget {
  final Bucket bucket;

  const BucketDetailScreen({super.key, required this.bucket});

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(bucket.name, style: const TextStyle(color: Colors.white)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.grey[850]!, Colors.grey[900]!]
                        : [Colors.deepPurple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.show_chart, size: 60, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        bucket.strategy,
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Managed by ${bucket.manager}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Overview'),
                      Tab(text: 'Stocks & Weights'),
                    ],
                  ),
                  SizedBox(
                    height: 1200, // Adjust height as needed
                    child: TabBarView(
                      children: [
                        _buildOverviewTab(context),
                        _buildStocksAndWeightsTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About the Bucket',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(bucket.rationale),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        'Read more',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoTile(
                      context,
                      Icons.bar_chart,
                      'Methodology',
                      'Know how this bucket was created',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      context,
                      Icons.article,
                      'Factsheet',
                      'Download key points of this bucket',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Live Performance vs Equity Large Cap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 300, child: _buildLineChart(context)),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Minimum Investment Amount'),
                    Text(
                      '₹${bucket.minInvestment.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Get access for ₹3000/1y',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        'See all plans & benefits',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Full width
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Subscribe Now'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final line1Color = isDarkMode ? Colors.cyanAccent : Colors.blue;
    final line2Color = isDarkMode ? Colors.yellowAccent : Colors.orange;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 50,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.dividerColor.withAlpha(25),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: theme.dividerColor.withAlpha(25),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(fontSize: 12);
                switch (value.toInt()) {
                  case 0:
                    return const Text('2018', style: style);
                  case 2:
                    return const Text('2020', style: style);
                  case 4:
                    return const Text('2022', style: style);
                  case 6:
                    return const Text('2024', style: style);
                  default:
                    return const Text('', style: style);
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}', style: const TextStyle(fontSize: 12));
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        minX: 0,
        maxX: 6,
        minY: 50,
        maxY: 250,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 100),
              FlSpot(1, 120),
              FlSpot(2, 150),
              FlSpot(3, 130),
              FlSpot(4, 180),
              FlSpot(5, 200),
              FlSpot(6, 230),
            ],
            isCurved: true,
            color: line1Color,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: line1Color.withAlpha(51),
            ),
          ),
          LineChartBarData(
            spots: const [
              FlSpot(0, 100),
              FlSpot(1, 110),
              FlSpot(2, 120),
              FlSpot(3, 115),
              FlSpot(4, 130),
              FlSpot(5, 140),
              FlSpot(6, 150),
            ],
            isCurved: true,
            color: line2Color,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: line2Color.withAlpha(51),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStocksAndWeightsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'At a Glance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGlanceInfo('Stocks', bucket.stockCount.toString()),
                        _buildGlanceInfo(
                          'Rebalance Frequency',
                          bucket.rebalanceFrequency,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGlanceInfo(
                          'Last Rebalance',
                          _formatDate(bucket.lastRebalance),
                        ),
                        _buildGlanceInfo(
                          'Next Rebalance',
                          _formatDate(bucket.nextRebalance),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Holdings Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHoldingsDistribution(context),
            const SizedBox(height: 24),
            const Text(
              'Stocks & Weights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStocksAndWeightsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlanceInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildHoldingsDistribution(BuildContext context) {
    final colors = [Colors.blue, Colors.purple, Colors.orange, Colors.green, Colors.red];
    final holdings = bucket.holdingsDistribution.entries.toList();
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: List.generate(holdings.length, (index) {
                return Expanded(
                  flex: (holdings[index].value * 100).toInt(),
                  child: Container(
                    height: 20,
                    color: colors[index % colors.length],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: List.generate(holdings.length, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      color: colors[index % colors.length],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${holdings[index].key} ${(holdings[index].value * 100).toStringAsFixed(2)}%',
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStocksAndWeightsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bucket.allocation.length,
      itemBuilder: (context, index) {
        final stock = bucket.allocation.keys.elementAt(index);
        final weight = bucket.allocation[stock]! * 100;
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(stock.substring(0, 1)),
            ),
            title: Text(stock),
            trailing: Text(
              '${weight.toStringAsFixed(2)}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
