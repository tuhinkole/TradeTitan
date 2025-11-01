import 'dart:async';

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

  final ValueNotifier<SortOption> _sortOption = ValueNotifier(
    SortOption.recent,
  );

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
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() {});
    });
  }

  Future<void> _addBucket(Bucket bucket) async {
    await _firestoreService.addBucket(bucket);
  }

  void _changeSort(SortOption option) {
    _sortOption.value = option;
  }

  List<Bucket> _applySearchSortFilter(List<Bucket> allBuckets) {
    final query = _searchController.text.trim().toLowerCase();

    Iterable<Bucket> it = allBuckets;
    if (query.isNotEmpty) {
      it = it.where(
        (b) =>
            b.name.toLowerCase().contains(query) ||
            b.description.toLowerCase().contains(query),
      );
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
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
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
        title: const Text(
          'All Buckets',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
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
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'All Buckets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350.0, // Make cards smaller
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1.4, // Adjust aspect ratio
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final bucket = filteredBuckets[index];
                    return BucketCard(bucket: bucket);
                  }, childCount: filteredBuckets.length),
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
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingRow() {
    final name =
        _user?.displayName ?? _user?.email?.split('@').first ?? 'Guest';
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
              Text(
                'Hi, $name',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _user != null
                    ? 'Welcome back — here are your buckets'
                    : 'Sign in to see your buckets',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        if (_user == null)
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: const Text('Login'),
          ),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
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
            Wrap(
              spacing: 8.0,
              children: [
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
              ],
            ),
          ],
        ),
      ],
    );
  }
}

enum SortOption { recent, investedDesc, nameAsc }
