import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: actions,
      // Podemos adicionar outras customizações aqui no futuro
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
