
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/product_controller.dart';
import 'package:lista_compras/model/product_model.dart';

import 'package:lista_compras/view/widgets/edit_product_dialog.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductController controller;

  const ProductCard({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Handle product tap, maybe view details?
        },
        onLongPress: () {
          _showContextMenu(context);
        },
        child: Column(
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                Get.dialog(
                  EditProductDialog(controller: controller, product: product),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Deletar'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.defaultDialog(
      title: "Confirmar Exclusão",
      middleText: "Você tem certeza que deseja deletar o produto '${product.name}'?",
      textConfirm: "Deletar",
      textCancel: "Cancelar",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteProduct(product.id);
        Get.back(); // Fecha o diálogo de confirmação
      },
      onCancel: () {},
    );
  }
}
