
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradetitan/presentation/screens/dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToDashboard,
                child: Text('Skip', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
              ),
            ),
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                children: [
                  _buildWelcomePage(
                    color: theme.colorScheme.primary,
                    icon: Icons.dashboard_rounded,
                    title: 'Manage Your Projects',
                  ),
                  _buildWelcomePage(
                    color: theme.colorScheme.secondary,
                    icon: Icons.insights_rounded,
                    title: 'Track Your Progress',
                  ),
                  _buildWelcomePage(
                    color: theme.colorScheme.tertiary,
                    icon: Icons.checklist_rtl_rounded,
                    title: 'Complete Your Tasks',
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Managing Your Projects is Now Easy',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Simplify your workflow and boost your productivity. Let\'s get started!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        activeDotColor: theme.colorScheme.primary,
                        dotColor: Colors.grey,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _navigateToDashboard,
                      child: const Text('Get Started'),
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

  Widget _buildWelcomePage({
    required Color color,
    required IconData icon,
    required String title,
  }) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: color),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
