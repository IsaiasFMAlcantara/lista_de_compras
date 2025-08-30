import 'package:flutter/material.dart';
import 'package:lista_compras/view/widgets/cards/rectangular_card.dart';

typedef ItemWidgetBuilder = Widget Function(BuildContext context, int index);

class SingleColumnCardList extends StatelessWidget {
  final int itemCount;
  final ItemWidgetBuilder itemBuilder;

  const SingleColumnCardList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RectangularCard(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
