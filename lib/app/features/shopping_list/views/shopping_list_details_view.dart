import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/routes/app_routes.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';
import 'package:lista_compras/app/data/models/list_item_model.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:lista_compras/app/theme/app_theme.dart'; // Adicionado

class ShoppingListDetailsView extends GetView<ShoppingListController> {
  const ShoppingListDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.arguments is ListModel) {
      controller.setList(Get.arguments as ListModel);
    }

    final authController = Get.find<AuthController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.currentList.value?.name ?? 'Detalhes da Lista')),
        actions: [
          Obx(() {
            // Ações da AppBar só visíveis para quem não é visualizador ou se não for lista histórica
            final isViewer = controller.isViewer;
            final isListOwner = controller.currentList.value?.ownerId == authController.firebaseUser.value?.uid;
            final isHistorical = controller.currentList.value?.status != 'ativa';

            if (isViewer || isHistorical) return const SizedBox.shrink(); // Esconde ações para visualizadores e listas históricas

            return Row(
              children: [
                Obx(() => TextButton(
                  onPressed: controller.canFinalize.value && (isListOwner || controller.canEditList)
                      ? () => controller.finishShopping()
                      : null,
                  child: Text(
                    'Finalizar',
                    style: TextStyle(
                      color: (controller.canFinalize.value && (isListOwner || controller.canEditList))
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                )),
                IconButton(
                  icon: const Icon(Icons.group_add),
                  onPressed: () {
                    Get.toNamed(Routes.members);
                  },
                ),
              ],
            );
          })
        ],
      ),
      body: Obx(
        () {
          if (controller.currentItems.isEmpty) {
            return const Center(
              child: Text('Nenhum item na lista. Adicione um!'),
            );
          }

          final isViewer = controller.isViewer;

          return ListView.builder(
            itemCount: controller.currentItems.length,
            itemBuilder: (context, index) {
              final item = controller.currentItems[index];

              Widget itemTile = CheckboxListTile(
                value: item.isCompleted,
                onChanged: isViewer ? null : (value) => controller.toggleItemCompletion(item),
                title: GestureDetector(
                  onTap: isViewer ? null : () => _showEditPriceDialog(context, item),
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                subtitle: GestureDetector(
                  onTap: isViewer ? null : () => _showEditPriceDialog(context, item),
                  child: Text('Qtd: ${item.quantity} | Preço: ${item.unitPrice.toStringAsFixed(2)} R\$'),
                ),
                secondary: Text('${item.totalItemPrice.toStringAsFixed(2)} R\$'),
              );

              if (isViewer) {
                return Card( // Se for visualizador, apenas um Card sem Dismissible
                  child: itemTile,
                );
              } else {
                return Dismissible(
                  key: Key(item.id!),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    controller.deleteItem(item);
                  },
                  background: Container(
                    color: AppTheme.destructiveColor, // Usando a cor do tema
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: itemTile,
                );
              }
            },
          );
        },
      ),
      floatingActionButton: Obx(() => controller.isViewer
          ? const SizedBox.shrink() // Oculta o FAB para visualizadores
          : FloatingActionButton(
              onPressed: () {
                Get.toNamed(Routes.productSelection);
              },
              child: const Icon(Icons.add_shopping_cart),
            ),
      ),
    );
  }

  void _showEditPriceDialog(BuildContext context, ListItemModel item) {
    final priceController = TextEditingController(text: item.unitPrice.toString());
    Get.dialog(
      AlertDialog(
        title: Text('Editar Preço de "${item.productName}"'),
        content: TextFormField(
          controller: priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Novo Preço Unitário'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text) ?? 0.0;
              controller.updateItemPrice(item, price);
              Get.back();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}