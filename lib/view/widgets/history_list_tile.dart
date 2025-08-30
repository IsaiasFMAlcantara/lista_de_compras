import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/routers.dart';

class HistoryListTile extends StatelessWidget {
  final ShoppingListModel list;

  const HistoryListTile({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    String subtitle = '';
    if (list.status == 'finalizada') {
      final date = list.finishedAt != null
          ? DateFormat('dd/MM/yyyy').format(list.finishedAt!.toDate())
          : 'Data indisponível';
      final price = list.totalPrice != null
          ? 'R\$ ${list.totalPrice!.toStringAsFixed(2)}'
          : 'Preço não calculado';
      subtitle = 'Finalizada em: $date - Total: $price';
    } else if (list.status == 'arquivada') {
      final date = DateFormat('dd/MM/yyyy').format(list.updatedAt.toDate());
      subtitle = 'Arquivada em: $date';
    }

    return ListTile(
      title: Text(list.name),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Get.toNamed(AppRoutes.listDetailsPage, arguments: list);
      },
    );
  }
}
