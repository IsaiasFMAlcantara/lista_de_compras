import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/product_controller.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/custom_drawer.dart';
import 'package:lista_compras/view/widgets/add_product_dialog.dart'; // Import the new dialog

import 'package:lista_compras/view/widgets/lists/two_column_card_list.dart';

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia o controller
    final ProductController controller = Get.put(ProductController());

    return Scaffold(
      appBar: const CustomAppBar(title: 'Catálogo de Produtos'),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('Nenhum produto no catálogo ainda.'));
        }
        return TwoColumnCardList(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(product.imageUrl),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium, // Use theme text style
                  ),
                ),
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AddProductDialog(controller: controller),
          ); // Use the new dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
