import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/routes/app_routes.dart';
import 'package:lista_compras/app/widgets/app_drawer.dart';

import 'product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Barra de Pesquisa e Ordenação ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar por nome',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => DropdownButton<SortOptions>(
                    value: controller.sortOption.value,
                    onChanged: controller.changeSortOption,
                    items: const [
                      DropdownMenuItem(
                        value: SortOptions.alphabetical,
                        child: Text('A-Z'),
                      ),
                      DropdownMenuItem(
                        value: SortOptions.userCreated,
                        child: Text('Meus Produtos'),
                      ),
                      DropdownMenuItem(
                        value: SortOptions.creationDate,
                        child: Text('Data de Criação'),
                      ),
                      DropdownMenuItem(
                        value: SortOptions.updateDate,
                        child: Text('Data de Atualização'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // --- Lista de Produtos ---
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
                        onTap: () => controller.showOptionsDialog(product),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                            Get.toNamed(Routes.manageProduct);        },
        child: const Icon(Icons.add),
      ),
    );
  }
}