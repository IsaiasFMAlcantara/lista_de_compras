import 'package:flutter/material.dart';
import 'package:lista_compras/view/widgets/cards/square_card.dart';

typedef ItemWidgetBuilder = Widget Function(BuildContext context, int index);

class TwoColumnCardList extends StatelessWidget {
  final int itemCount;
  final ItemWidgetBuilder itemBuilder;

  const TwoColumnCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1 / 1, // Garante que o espaço alocado seja quadrado
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return SquareCard(child: itemBuilder(context, index));
      },
    );
  }
}
