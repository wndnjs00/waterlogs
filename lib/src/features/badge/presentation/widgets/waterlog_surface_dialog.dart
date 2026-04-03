import 'package:flutter/material.dart';

class WaterLogSurfaceDialog extends StatelessWidget {
  final Widget child;

  const WaterLogSurfaceDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}
