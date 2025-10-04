import 'package:flutter/material.dart';
import 'package:tradetitan/presentation/screens/create_bucket_screen.dart';

class BottomBar extends StatelessWidget {
  final BuildContext context;

  const BottomBar({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implement profile screen
            },
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateBucketScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: Implement info screen
            },
          ),
        ],
      ),
    );
  }
}
