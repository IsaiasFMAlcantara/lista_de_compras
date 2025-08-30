import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/shopping_list_controller.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/custom_drawer.dart';
import 'package:lista_compras/view/widgets/lists/single_column_card_list.dart';

import 'package:lista_compras/routers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia o controller das listas de compras
    final ShoppingListController controller = Get.put(ShoppingListController());

    return Scaffold(
      appBar: const CustomAppBar(title: 'Minhas Listas'),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.shoppingLists.isEmpty) {
          return const Center(
            child: Text('Você ainda não tem nenhuma lista de compras.'),
          );
        }
        return SingleColumnCardList(
          itemCount: controller.shoppingLists.length,
          itemBuilder: (context, index) {
            final list = controller.shoppingLists[index];
            // Formata a data para exibição
            final subtitle = list.purchaseDate != null
                ? 'Comprar em: ${DateFormat('dd/MM/yyyy').format(list.purchaseDate!.toDate())}'
                : 'Criada em: ${DateFormat('dd/MM/yyyy').format(list.createdAt.toDate())}';

            return ListTile(
              title: Text(list.name),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.toNamed(AppRoutes.listDetailsPage, arguments: list);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateListDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateListDialog(BuildContext context, ShoppingListController controller) {
    final TextEditingController nameController = TextEditingController();
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

    Get.dialog(AlertDialog(
      title: const Text('Criar Nova Lista'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome da Lista'),
            autofocus: true,
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate.value == null
                        ? 'Sem data de compra'
                        : 'Data: ${DateFormat('dd/MM/yyyy').format(selectedDate.value!)}',
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        selectedDate.value = picked;
                      }
                    },
                  ),
                ],
              )),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Get.back(),
        ),
        Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  child: const Text('Criar'),
                  onPressed: () {
                    controller.createList(nameController.text, selectedDate.value);
                    Get.back(); // Fecha o dialog
                  },
                );
        }),
      ],
    ));
  }
}
