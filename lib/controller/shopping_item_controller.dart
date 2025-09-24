import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/helpers/error_helper.dart';
import 'package:lista_compras/model/shopping_item_model.dart';
import 'package:lista_compras/repositories/shopping_item_repository.dart';
import 'package:lista_compras/services/logger_service.dart';

class ShoppingItemController extends GetxController {
  final ShoppingItemRepository _shoppingItemRepository = Get.find<ShoppingItemRepository>();
  final AuthController _authController = Get.find<AuthController>();
  final LoggerService _logger = Get.find<LoggerService>();

  final RxList<ShoppingItemModel> items = <ShoppingItemModel>[].obs;
  var isLoading = false.obs;

  void bindItemsStream(String listId) {
    items.bindStream(
      _shoppingItemRepository.getItemsStream(listId),
    );
  }

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
      );

      Get.snackbar('Sucesso', 'Item "$name" adicionado!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

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
      );
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    }
  }

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
      );
      Get.snackbar('Sucesso', 'Item atualizado!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    final user = _authController.user;
    if (user == null) return;

    try {
      isLoading.value = true;
      await _shoppingItemRepository.deleteItem(
        listId,
        itemId,
      );
      Get.snackbar('Sucesso', 'Item removido!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
}
