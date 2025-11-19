import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/historical_list_details_controller.dart';

class HistoricalListDetailsView extends GetView<HistoricalListDetailsController> {
  const HistoricalListDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.list.name),
      ),
      body: Obx(
        () {
          if (controller.items.value.isEmpty) {
            return const Center(
              child: Text('Nenhum item nesta lista.'),
            );
          }
          return ListView.builder(
            itemCount: controller.items.value.length,
            itemBuilder: (context, index) {
              final item = controller.items.value[index];
              return ListTile(
                leading: Icon(
                  item.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  color: item.isCompleted ? Colors.green : null,
                ),
                title: Text(
                  item.productName,
                  style: TextStyle(
                    decoration: item.isCompleted
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                    color: item.isCompleted ? null : Colors.grey,
                  ),
                ),
                subtitle: Text('Qtd: ${item.quantity} | Preço: ${item.unitPrice.toStringAsFixed(2)} R\$'),
                trailing: Text('${item.totalItemPrice.toStringAsFixed(2)} R\$'),
              );
            },
          );
        },
      ),
    );
  }
}
