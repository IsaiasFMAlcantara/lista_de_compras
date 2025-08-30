import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart'; // Import the new repository

class ShoppingListController extends GetxController {
  // Inject ShoppingListRepository
  final ShoppingListRepository _shoppingListRepository = Get.put(
    ShoppingListRepository(),
  );
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ShoppingListModel> shoppingLists = <ShoppingListModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Associa o stream do Firestore à nossa lista reativa
    final user = _authController.user;
    if (user != null) {
      shoppingLists.bindStream(_getShoppingListsStream(user.uid));
    }
  }

  // Pega as listas de compra em tempo real e aplica a ordenação
  Stream<List<ShoppingListModel>> _getShoppingListsStream(String uid) {
    return _shoppingListRepository
        .getShoppingListsStream(uid, 'ativa') // Use repository method
        .map((lists) {
          // Lógica de ordenação: purchaseDate (mais próxima) > createdAt
          lists.sort((a, b) {
            // Se ambos têm purchaseDate, compara por ela
            if (a.purchaseDate != null && b.purchaseDate != null) {
              return a.purchaseDate!.compareTo(
                b.purchaseDate!,
              ); // Crescente (mais próxima primeiro)
            }
            // Se apenas 'a' tem purchaseDate, 'a' vem antes
            if (a.purchaseDate != null) {
              return -1;
            }
            // Se apenas 'b' tem purchaseDate, 'b' vem antes
            if (b.purchaseDate != null) {
              return 1;
            }
            // Se nenhum tem purchaseDate, compara por createdAt (mais recente primeiro)
            return b.createdAt.compareTo(
              a.createdAt,
            ); // Decrescente (mais recente primeiro)
          });
          return lists;
        });
  }

  // Cria uma nova lista de compras
  Future<void> createList(
    String name,
    String category,
    DateTime? purchaseDate,
  ) async {
    if (name.isEmpty) {
      Get.snackbar('Erro', 'O nome da lista não pode ser vazio.');
      return;
    }

    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para criar uma lista.');
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();
      final uid = user.uid;

      final listData = {
        'name': name,
        'ownerId': uid,
        'createdAt': now,
        'updatedAt': now,
        'lastUpdatedBy': uid,
        'status': 'ativa',
        'members': {uid: 'owner'},
        'category': category,
        'purchaseDate': purchaseDate != null
            ? Timestamp.fromDate(purchaseDate)
            : null,
      };

      await _shoppingListRepository.addList(listData); // Use repository method

      Get.snackbar('Sucesso', 'Lista "$name" criada!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível criar a lista.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Arquiva uma lista (muda o status para 'arquivada')
  Future<void> archiveList(String listId) async {
    final user = _authController.user;
    if (user == null) {
      Get.snackbar(
        'Erro',
        'Você precisa estar logado para arquivar uma lista.',
      );
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();

      await _shoppingListRepository.updateList(listId, {
        // Use repository method
        'status': 'arquivada',
        'updatedAt': now,
        'lastUpdatedBy': user.uid,
      });
      Get.snackbar('Sucesso', 'Lista arquivada com sucesso!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível arquivar a lista.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Finaliza uma lista de compras
  Future<void> finishList(String listId) async {
    final user = _authController.user;
    if (user == null) {
      Get.snackbar(
        'Erro',
        'Você precisa estar logado para finalizar uma lista.',
      );
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();

      // 1. Buscar todos os itens da lista para calcular o total
      final items = await _shoppingListRepository.getShoppingListItems(
        listId,
      ); // Use repository method
      double totalPrice = 0.0;
      for (var item in items) {
        if (item.price != null && item.quantity > 0) {
          totalPrice += item.price! * item.quantity;
        }
      }

      // 2. Atualizar a lista com o novo status e o total
      await _shoppingListRepository.updateList(listId, {
        // Use repository method
        'status': 'finalizada',
        'totalPrice': totalPrice,
        'finishedAt': now, // Novo campo para registrar quando foi finalizada
        'updatedAt': now,
        'lastUpdatedBy': user.uid,
      });

      Get.snackbar('Sucesso', 'Compra finalizada e movida para o histórico!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível finalizar a compra.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Atualiza uma lista existente
  Future<void> updateList(
    ShoppingListModel list,
    String newName,
    String newCategory,
    DateTime? newPurchaseDate,
  ) async {
    if (newName.isEmpty) {
      Get.snackbar('Erro', 'O nome da lista não pode ser vazio.');
      return;
    }

    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para editar uma lista.');
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();

      await _shoppingListRepository.updateList(list.id, {
        // Use repository method
        'name': newName,
        'category': newCategory,
        'purchaseDate': newPurchaseDate != null
            ? Timestamp.fromDate(newPurchaseDate)
            : null,
        'updatedAt': now,
        'lastUpdatedBy': user.uid,
      });
      Get.snackbar('Sucesso', 'Lista atualizada com sucesso!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar a lista.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
