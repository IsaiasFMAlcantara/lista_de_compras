import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/routes/app_routes.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';
import 'package:lista_compras/app/data/models/list_item_model.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';

class ShoppingListDetailsView extends GetView<ShoppingListController> {
  const ShoppingListDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.currentList.value?.name ?? 'Detalhes da Lista')),
        actions: [
          Obx(() {
            final isOwner = controller.currentList.value?.ownerId == authController.firebaseUser.value?.uid;
            if (!isOwner) return const SizedBox.shrink();
            
            return IconButton(
              icon: const Icon(Icons.group_add),
              onPressed: () {
                Get.toNamed(Routes.MEMBERS);
              },
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
          return ListView.builder(
            itemCount: controller.currentItems.length,
            itemBuilder: (context, index) {
              final item = controller.currentItems[index];
              return CheckboxListTile(
                value: item.isCompleted,
                onChanged: (value) => controller.toggleItemCompletion(item),
                title: GestureDetector(
                  onTap: () => _showEditPriceDialog(context, item),
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
                  onTap: () => _showEditPriceDialog(context, item),
                  child: Text('Qtd: ${item.quantity} | Preço: ${item.unitPrice.toStringAsFixed(2)} R\$'),
                ),
                secondary: Text('${item.totalItemPrice.toStringAsFixed(2)} R\$'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.PRODUCT_SELECTION);
        },
        child: const Icon(Icons.add_shopping_cart),
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