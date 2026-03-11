import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/temp_view_model.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const routePath = '/main';
  static const routeName = 'main';

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Main 화면',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}