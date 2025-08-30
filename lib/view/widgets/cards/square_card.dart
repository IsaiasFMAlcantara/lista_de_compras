import 'package:flutter/material.dart';

class SquareCard extends StatelessWidget {
  final Widget child;

  const SquareCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 3,
      child: AspectRatio(
        aspectRatio: 1 / 1, // Proporção 1:1 para ser um quadrado
        child: child,
      ),
    );
  }
}
