import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Adicionado: Import para formatação de data
import 'package:lista_compras/app/features/history/controllers/history_controller.dart';
import 'package:lista_compras/app/routes/app_routes.dart'; // Import for navigation
import 'package:lista_compras/app/widgets/empty_state_widget.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Compras'),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.historicalLists.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.history_rounded,
              title: 'Nenhum Histórico',
              message: 'Suas listas de compras finalizadas ou arquivadas aparecerão aqui.',
            );
          }
          return ListView.builder(
            itemCount: controller.historicalLists.length,
            itemBuilder: (context, index) {
              final list = controller.historicalLists[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(list.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${list.status}'),
                      Text('Total: R\$ ${list.totalPrice.toStringAsFixed(2)}'),
                      if (list.purchaseDate != null)
                        Text('Data da Compra: ${DateFormat('dd/MM/yyyy').format(list.purchaseDate!)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          controller.showCloneListDialog(list, context);
                        },
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () {
                    Get.toNamed(Routes.historicalListDetails, arguments: list);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
