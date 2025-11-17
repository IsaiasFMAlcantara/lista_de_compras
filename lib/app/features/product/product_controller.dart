import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/product_model.dart';
import 'package:lista_compras/app/data/providers/product_provider.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

enum SortOptions { alphabetical, userCreated, creationDate, updateDate }

class ProductController extends GetxController {
  final ProductProvider _productProvider = Get.find<ProductProvider>();
  final AuthController authController = Get.find<AuthController>();

  final _products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  final TextEditingController searchController = TextEditingController();
  final Rx<SortOptions> sortOption = SortOptions.alphabetical.obs;

  @override
  void onInit() {
    super.onInit();
    _products.bindStream(_productProvider.getProducts());
    // Listener para filtrar e ordenar a lista sempre que ela mudar
    ever(_products, (_) => _filterAndSortProducts());
    // Listener para o campo de pesquisa
    searchController.addListener(() => _filterAndSortProducts());
  }

  void changeSortOption(SortOptions? option) {
    if (option != null) {
      sortOption.value = option;
      _filterAndSortProducts();
    }
  }

  void _filterAndSortProducts() {
    List<ProductModel> tempProducts = List<ProductModel>.from(_products);

    // Filtragem por pesquisa
    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => product.name.toLowerCase().contains(query))
          .toList();
    }

    // Ordenação
    tempProducts.sort((a, b) {
      int comparison;
      switch (sortOption.value) {
        case SortOptions.userCreated:
          final isAOwner = authController.firebaseUser.value?.uid == a.ownerId;
          final isBOwner = authController.firebaseUser.value?.uid == b.ownerId;
          comparison = (isBOwner ? 1 : 0).compareTo(isAOwner ? 1 : 0);
          break;
        case SortOptions.creationDate:
          comparison = b.createdAt.compareTo(a.createdAt);
          break;
        case SortOptions.updateDate:
          comparison = b.updatedAt.compareTo(a.updatedAt);
          break;
        case SortOptions.alphabetical:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
      }
      // Critério de desempate: ordem alfabética
      if (comparison == 0) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return comparison;
    });

    filteredProducts.value = tempProducts;
  }

  void showOptionsDialog(ProductModel product) {
    final bool isOwner = authController.firebaseUser.value?.uid == product.ownerId;
    if (!isOwner) return;

    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.MANAGE_PRODUCT, arguments: product);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(product.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String productId) {
    Get.defaultDialog(
      title: 'Excluir Produto',
      middleText: 'Tem certeza que deseja excluir este produto?',
      textConfirm: 'Sim',
      textCancel: 'Não',
      onConfirm: () {
        deleteProduct(productId);
        Get.back();
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _productProvider.deleteProduct(productId);
      Get.snackbar('Sucesso', 'Produto excluído!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível excluir o produto.');
    }
  }
}