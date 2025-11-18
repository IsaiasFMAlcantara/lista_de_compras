import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/product/product_controller.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';

class ProductSelectionView extends GetView<ProductController> {
  const ProductSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingListController = Get.find<ShoppingListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione um Produto'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar por nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('Nenhum produto encontrado.'),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        onTap: () => _showQuantityDialog(context, product, shoppingListController),
                        leading: CircleAvatar(
                          backgroundImage: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                              ? NetworkImage(product.imageUrl!)
                              : null,
                          child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                              ? const Icon(Icons.shopping_bag)
                              : null,
                        ),
                        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(BuildContext context, dynamic product, ShoppingListController shoppingListController) {
    final qtyController = TextEditingController(text: '1');
    Get.dialog(
      AlertDialog(
        title: Text('Quantidade para "${product.name}"'),
        content: TextFormField(
          controller: qtyController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantidade'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = double.tryParse(qtyController.text) ?? 1.0;
              shoppingListController.addItemFromProduct(product, quantity);
              Get.back(); // Close quantity dialog
              Get.back(); // Close product selection screen
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
