import 'package:flutter/material.dart';

class RectangularCard extends StatelessWidget {
  final Widget child;

  const RectangularCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}
