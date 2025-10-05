import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradetitan/domain/bucket.dart';
import 'package:tradetitan/main.dart';
import 'package:tradetitan/presentation/screens/create_bucket_screen.dart';
import 'package:tradetitan/presentation/screens/info_screen.dart';
import 'package:tradetitan/presentation/screens/profile_screen.dart';
import 'package:tradetitan/presentation/widgets/bucket_card.dart';
import 'package:tradetitan/services/firestore_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  StreamSubscription<User?>? _authSubscription;

  final ValueNotifier<SortOption> _sortOption = ValueNotifier(SortOption.recent);
  final ValueNotifier<int> _carouselIndex = ValueNotifier(0);

  static const int _itemsPerPage = 20;
  int _currentPage = 0;

  User? _user;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    _authSubscription?.cancel();
    _sortOption.dispose();
    _carouselIndex.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _currentPage = 0);
    });
  }

  Future<void> _addBucket(Bucket bucket) async {
    await _firestoreService.addBucket(bucket);
  }

  void _changeSort(SortOption option) {
    _sortOption.value = option;
    _currentPage = 0;
  }

  void _loadMore() {
    setState(() => _currentPage++);
  }

  List<Bucket> _applySearchSortFilter(List<Bucket> allBuckets) {
    final query = _searchController.text.trim().toLowerCase();

    Iterable<Bucket> it = allBuckets;
    if (query.isNotEmpty) {
      it = it.where((b) =>
          b.name.toLowerCase().contains(query) ||
          b.description.toLowerCase().contains(query));
    }

    final List<Bucket> filtered = it.toList();
    switch (_sortOption.value) {
      case SortOption.recent:
        filtered.sort((a, b) => b.lastRebalance.compareTo(a.lastRebalance));
        break;
      case SortOption.investedDesc:
        filtered.sort((a, b) => b.minInvestment.compareTo(a.minInvestment));
        break;
      case SortOption.nameAsc:
        filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Buckets',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.grey[850]!, Colors.grey[900]!]
                  : [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: StreamBuilder<List<Bucket>>(
        stream: _firestoreService.getBuckets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allBuckets = snapshot.data ?? [];
          final filteredBuckets = _applySearchSortFilter(allBuckets);
          final endIndex = ((_currentPage + 1) * _itemsPerPage)
              .clamp(0, filteredBuckets.length);
          final displayedBuckets = filteredBuckets.sublist(0, endIndex);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreetingRow(),
                      const SizedBox(height: 12),
                      ValueListenableBuilder<SortOption>(
                        valueListenable: _sortOption,
                        builder: (context, sortOption, child) {
                          return _SearchAndFilterBar(
                            controller: _searchController,
                            sortOption: sortOption,
                            onSortChanged: _changeSort,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _MostInvestedSection(buckets: allBuckets),
                      const SizedBox(height: 12),
                      if (_user == null)
                        _UnlockMetricsBanner(
                            onLoginPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ProfileScreen()))),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: _carouselIndex,
                        builder: (context, carouselIndex, child) {
                          return _BucketCarousel(
                              buckets: displayedBuckets,
                              carouselIndex: carouselIndex,
                              onPageChanged: (i) => _carouselIndex.value = i);
                        },
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text('All Buckets',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final bucket = displayedBuckets[index];
                    return Padding(
                      key: ValueKey(bucket.id),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: BucketCard(bucket: bucket),
                    );
                  },
                  childCount: displayedBuckets.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                  child: displayedBuckets.length < filteredBuckets.length
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loadMore,
                            child: const Text('Load more'),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBucket = await Navigator.push<Bucket>(
            context,
            MaterialPageRoute(builder: (context) => const CreateBucketScreen()),
          );

          if (newBucket != null) {
            await _addBucket(newBucket);
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InfoScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingRow() {
    final name = _user?.displayName ?? _user?.email?.split('@').first ?? 'Guest';
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'G'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, $name',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(
                  _user != null
                      ? 'Welcome back — here are your buckets'
                      : 'Sign in to unlock personalized metrics',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color)),
            ],
          ),
        ),
        if (_user == null)
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              child: const Text('Login'))
      ],
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final SortOption sortOption;
  final ValueChanged<SortOption> onSortChanged;

  const _SearchAndFilterBar({
    required this.controller,
    required this.sortOption,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search buckets by name or description',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Wrap(spacing: 8.0, children: [
              ChoiceChip(
                label: const Text('Recent'),
                selected: sortOption == SortOption.recent,
                onSelected: (_) => onSortChanged(SortOption.recent),
              ),
              ChoiceChip(
                label: const Text('Min Investment'),
                selected: sortOption == SortOption.investedDesc,
                onSelected: (_) => onSortChanged(SortOption.investedDesc),
              ),
              ChoiceChip(
                label: const Text('A → Z'),
                selected: sortOption == SortOption.nameAsc,
                onSelected: (_) => onSortChanged(SortOption.nameAsc),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}

class _MostInvestedSection extends StatelessWidget {
  final List<Bucket> buckets;

  const _MostInvestedSection({required this.buckets});

  @override
  Widget build(BuildContext context) {
    final List<Bucket> copy = List.from(buckets);
    copy.sort((a, b) => b.minInvestment.compareTo(a.minInvestment));
    final top = copy.take(3).toList();

    return SizedBox(
      height: 120,
      child: top.isEmpty
          ? const Center(child: Text('No investments yet'))
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: top.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final b = top[index];
                return Container(
                  width: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.9),
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.9)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text('Min Investment: ₹${b.minInvestment.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white)),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                              child: Text(b.description, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.white70))),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _UnlockMetricsBanner extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const _UnlockMetricsBanner({required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          theme.colorScheme.primary.withOpacity(0.15),
          theme.colorScheme.primaryContainer.withOpacity(0.15)
        ]),
      ),
      child: Row(
        children: [
          const Icon(Icons.bar_chart, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unlock all metrics',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Login to see the live performance and returns',
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
              onPressed: onLoginPressed, child: const Text('Login'))
        ],
      ),
    );
  }
}

class _BucketCarousel extends StatelessWidget {
  final List<Bucket> buckets;
  final int carouselIndex;
  final ValueChanged<int> onPageChanged;

  const _BucketCarousel(
      {required this.buckets,
      required this.carouselIndex,
      required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            enlargeCenterPage: true,
            autoPlay: false,
            enableInfiniteScroll: false,
            viewportFraction: 0.82,
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
          items: buckets
              .map((bucket) =>
                  Builder(builder: (context) => BucketCard(bucket: bucket)))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(buckets.length, (i) => _buildDot(i == carouselIndex)),
        ),
      ],
    );
  }

  Widget _buildDot(bool active) {
    return Container(
      width: active ? 10 : 8,
      height: active ? 10 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.blueAccent : Colors.grey[400],
      ),
    );
  }
}

enum SortOption { recent, investedDesc, nameAsc }
