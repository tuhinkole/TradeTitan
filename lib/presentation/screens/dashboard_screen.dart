import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tradetitan/data/bucket_data.dart';
import 'package:tradetitan/domain/bucket.dart';
import 'package:tradetitan/presentation/screens/bucket_detail_screen.dart';
import 'package:tradetitan/presentation/screens/create_bucket_screen.dart';
import 'package:tradetitan/presentation/widgets/bucket_card.dart';
import 'package:provider/provider.dart';
import 'package:tradetitan/main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Bucket> _buckets;

  @override
  void initState() {
    super.initState();
    _buckets = initialBuckets;
  }

  void _addBucket(Bucket bucket) {
    setState(() {
      _buckets.add(bucket);
    });
  }

  Future<void> _refreshBuckets() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _buckets = initialBuckets;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Buckets'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshBuckets,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWebLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBucket = await Navigator.push<Bucket>(
            context,
            MaterialPageRoute(builder: (context) => const CreateBucketScreen()),
          );

          if (newBucket != null) {
            _addBucket(newBucket);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWebLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMostInvestedHeader(),
            const SizedBox(height: 24),
            _buildUnlockMetricsBanner(),
            const SizedBox(height: 24),
             CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
              ),
              items: _buckets.map((bucket) {
                return Builder(
                  builder: (BuildContext context) {
                    return AllBucketsCard(bucket: bucket);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'All Buckets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _buckets.length,
              itemBuilder: (context, index) {
                return BucketListItem(bucket: _buckets[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostInvestedHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star, color: Colors.green, size: 40),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Most Invested',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Most invested buckets in the last 4 weeks',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockMetricsBanner() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock all metrics',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Login to see the live performance and returns',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(onPressed: () {}, child: const Text('Login')),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return RefreshIndicator(
      onRefresh: _refreshBuckets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildMostInvestedHeader(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildUnlockMetricsBanner(),
            ),
            const SizedBox(height: 24),
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: false,
                viewportFraction: 0.8,
              ),
              items: _buckets.map((bucket) {
                return Builder(
                  builder: (BuildContext context) {
                    return AllBucketsCard(bucket: bucket);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'All Buckets',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _buckets.length,
              itemBuilder: (context, index) {
                return BucketListItem(bucket: _buckets[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AllBucketsCard extends StatelessWidget {
  final Bucket bucket;

  const AllBucketsCard({super.key, required this.bucket});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BucketDetailScreen(bucket: bucket),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.show_chart, color: Colors.blue, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bucket.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            bucket.strategy,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Created by ${bucket.manager}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(_getVolatilityLabel(bucket.volatility)),
                      backgroundColor: _getVolatilityColor(bucket.volatility),
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Min. Investment',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '₹ ${bucket.minInvestment.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('See Performance'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BucketDetailScreen(bucket: bucket),
                          ),
                        );
                      },
                      child: const Text('View Bucket'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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

class BucketListItem extends StatelessWidget {
  final Bucket bucket;

  const BucketListItem({super.key, required this.bucket});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BucketDetailScreen(bucket: bucket),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.show_chart, color: Colors.blue, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bucket.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          bucket.strategy,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Created by ${bucket.manager}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Chip(
                    label: Text(_getVolatilityLabel(bucket.volatility)),
                    backgroundColor: _getVolatilityColor(bucket.volatility),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Min. Investment',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '₹ ${bucket.minInvestment.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('See Performance'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BucketDetailScreen(bucket: bucket),
                        ),
                      );
                    },
                    child: const Text('View Bucket'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
