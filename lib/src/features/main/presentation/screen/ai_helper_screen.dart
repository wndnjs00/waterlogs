import 'package:flutter/material.dart';

class AiHelperScreen extends StatelessWidget {
  const AiHelperScreen({super.key});

  static const routePath = '/ai';
  static const routeName = 'ai';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ai 도우미 화면',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}