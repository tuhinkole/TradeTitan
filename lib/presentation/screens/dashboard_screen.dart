import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final ValueNotifier<SortOption> _sortOption =
      ValueNotifier(SortOption.recent);
  final ValueNotifier<String> _selectedCategory = ValueNotifier('All');

  User? _user;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchDebounce?.cancel();
    _authSubscription?.cancel();
    _sortOption.dispose();
    _selectedCategory.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() {});
    });
  }

  List<Bucket> _applySearchAndFilter(List<Bucket> allBuckets) {
    final query = _searchController.text.trim().toLowerCase();
    final category = _selectedCategory.value;

    Iterable<Bucket> filtered = allBuckets;

    // Category Filtering
    switch (category) {
      case 'Top Gainers':
        filtered = filtered.where((b) => (b.returns['1Y'] ?? 0) >= 0.15);
        break;
      case 'High Growth':
        filtered = filtered.where((b) => (b.returns['1Y'] ?? 0) >= 0.20);
        break;
      case 'Thematic':
        filtered =
            filtered.where((b) => b.strategy.toLowerCase().contains('thematic'));
        break;
      case 'Low Risk':
        filtered = filtered.where((b) => b.volatility <= 0.25);
        break;
      case 'New':
        filtered = filtered.where((b) =>
            b.lastRebalance.isAfter(DateTime.now().subtract(const Duration(days: 30))));
        break;
      case 'All':
      default:
        // No filter needed for 'All'
        break;
    }

    // Search Query Filtering
    if (query.isNotEmpty) {
      filtered = filtered.where(
        (b) =>
            b.name.toLowerCase().contains(query) ||
            b.description.toLowerCase().contains(query),
      );
    }

    // Sorting
    final List<Bucket> sortedList = filtered.toList();
    switch (_sortOption.value) {
      case SortOption.recent:
        sortedList.sort((a, b) => b.lastRebalance.compareTo(a.lastRebalance));
        break;
      case SortOption.investedDesc:
        // Assuming you want to sort by minInvestment in descending order
        sortedList.sort((a, b) => b.minInvestment.compareTo(a.minInvestment));
        break;
      case SortOption.nameAsc:
        sortedList.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
    }
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<List<Bucket>>(
        stream: _firestoreService.getBuckets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allBuckets = snapshot.data ?? [];
          final filteredBuckets = _applySearchAndFilter(allBuckets);

          return CustomScrollView(
            slivers: [
              _HeaderSection(user: _user),
              const _ExploreSectionHeader(),
              _ExploreSection(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  _selectedCategory.value = category;
                  setState(() {}); // Re-render the list
                },
              ),
              _AllBucketsHeader(
                searchController: _searchController,
                sortNotifier: _sortOption,
                onSortChanged: (sortOption) {
                  _sortOption.value = sortOption;
                  setState(() {}); // Re-render the list
                },
                theme: theme,
              ),
              if (filteredBuckets.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Text('No buckets found.'),
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360.0,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return BucketCard(bucket: filteredBuckets[index]);
                    },
                    childCount: filteredBuckets.length,
                  ),
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
            await _firestoreService.addBucket(newBucket);
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final User? user;
  const _HeaderSection({this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final name =
        user?.displayName ?? user?.email?.split('@').first ?? 'Investor';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $name',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find your next winning investment.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () => themeProvider.toggleTheme(),
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreSectionHeader extends StatelessWidget {
  const _ExploreSectionHeader();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Text(
          'Explore',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ExploreSection extends StatelessWidget {
  final ValueNotifier<String> selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final List<String> _categories = [
    'All',
    'Top Gainers',
    'Thematic',
    'Low Risk',
    'High Growth',
    'New'
  ];

  _ExploreSection({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return ValueListenableBuilder<String>(
              valueListenable: selectedCategory,
              builder: (context, value, child) {
                final isSelected = category == value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onCategorySelected(category);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AllBucketsHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueNotifier<SortOption> sortNotifier;
  final ValueChanged<SortOption> onSortChanged;
  final ThemeData theme;

  const _AllBucketsHeader({
    required this.searchController,
    required this.sortNotifier,
    required this.onSortChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Buckets',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by name or description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<SortOption>(
              valueListenable: sortNotifier,
              builder: (context, sortValue, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<SortOption>(
                      onSelected: onSortChanged,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SortOption>>[
                        const PopupMenuItem(
                          value: SortOption.recent,
                          child: Text('Most Recent'),
                        ),
                        const PopupMenuItem(
                          value: SortOption.investedDesc,
                          child: Text('Min. Investment'),
                        ),
                        const PopupMenuItem(
                          value: SortOption.nameAsc,
                          child: Text('Name (A-Z)'),
                        ),
                      ],
                      child: Row(
                        children: [
                          Text(
                            'Sort by: ${sortValue.name}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum SortOption {
  recent,
  investedDesc,
  nameAsc;

  String get name {
    switch (this) {
      case SortOption.recent:
        return 'Recent';
      case SortOption.investedDesc:
        return 'Investment';
      case SortOption.nameAsc:
        return 'Name';
    }
  }
}
