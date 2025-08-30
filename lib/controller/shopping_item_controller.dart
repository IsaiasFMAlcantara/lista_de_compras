import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/model/shopping_item_model.dart';
import 'package:lista_compras/repositories/shopping_item_repository.dart'; // Import the new repository

class ShoppingItemController extends GetxController {
  // Inject ShoppingItemRepository
  final ShoppingItemRepository _shoppingItemRepository = Get.put(
    ShoppingItemRepository(),
  );
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ShoppingItemModel> items = <ShoppingItemModel>[].obs;
  var isLoading = false.obs;

  // Stream para pegar os itens de uma lista específica em tempo real
  void bindItemsStream(String listId) {
    items.bindStream(
      _shoppingItemRepository.getItemsStream(listId),
    ); // Use repository method
  }

  // Adiciona um novo item a uma lista
  Future<void> addItem(
    String listId,
    String name,
    double quantity, {
    double? price,
    String? productId,
  }) async {
    if (name.isEmpty || quantity <= 0) {
      Get.snackbar('Erro', 'Nome e quantidade são obrigatórios.');
      return;
    }

    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para adicionar um item.');
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();

      final itemData = {
        'name': name,
        'quantity': quantity,
        'price': price,
        'productId': productId,
        'isCompleted': false,
        'createdAt': now,
        'updatedAt': now,
        'createdBy': user.uid,
      };

      await _shoppingItemRepository.addItem(
        listId,
        itemData,
      ); // Use repository method

      Get.snackbar('Sucesso', 'Item "$name" adicionado!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível adicionar o item.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Marca/desmarca um item como concluído
  Future<void> toggleItemCompletion(
    String listId,
    String itemId,
    bool isCompleted,
  ) async {
    final user = _authController.user;
    if (user == null) return;

    try {
      await _shoppingItemRepository.updateItemCompletion(
        listId,
        itemId,
        isCompleted,
        user.uid,
      ); // Use repository method
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar o status do item.');
      log(e.toString());
    }
  }

  // Atualiza um item existente
  Future<void> updateItem(
    String listId,
    String itemId,
    String newName,
    double newQuantity, {
    double? newPrice,
  }) async {
    if (newName.isEmpty || newQuantity <= 0) {
      Get.snackbar('Erro', 'Nome e quantidade são obrigatórios.');
      return;
    }

    final user = _authController.user;
    if (user == null) return;

    try {
      isLoading.value = true;
      final now = Timestamp.now();

      final updateData = {
        'name': newName,
        'quantity': newQuantity,
        'price': newPrice,
        'updatedAt': now,
        'createdBy': user.uid,
      };

      await _shoppingItemRepository.updateItem(
        listId,
        itemId,
        updateData,
      ); // Use repository method
      Get.snackbar('Sucesso', 'Item atualizado!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar o item.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Deleta um item
  Future<void> deleteItem(String listId, String itemId) async {
    final user = _authController.user;
    if (user == null) return;

    try {
      isLoading.value = true;
      await _shoppingItemRepository.deleteItem(
        listId,
        itemId,
      ); // Use repository method
      Get.snackbar('Sucesso', 'Item removido!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível remover o item.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
