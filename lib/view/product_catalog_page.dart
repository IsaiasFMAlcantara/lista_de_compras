import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/controller/product_controller.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/custom_drawer.dart';

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
          return const Center(
            child: Text('Nenhum produto no catálogo ainda.'),
          );
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
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, ProductController controller) {
    final TextEditingController nameController = TextEditingController();
    final Rx<XFile?> imageFile = Rx<XFile?>(null);

    Get.dialog(AlertDialog(
      title: const Text('Adicionar Novo Produto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            const SizedBox(height: 20),
            Obx(() => imageFile.value == null
                ? const Text('Nenhuma imagem selecionada.')
                : Image.file(File(imageFile.value!.path), height: 100)),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Selecionar Imagem'),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  imageFile.value = pickedFile;
                }
              },
            ),
          ],
        ),
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
                  child: const Text('Adicionar'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && imageFile.value != null) {
                      controller.addProduct(nameController.text, imageFile.value!);
                      Get.back(); // Fecha o dialog
                    }
                  },
                );
        }),
      ],
    ));
  }
}