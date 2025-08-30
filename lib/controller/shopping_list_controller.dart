import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/model/shopping_list_model.dart';

class ShoppingListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    return _firestore
        .collection('lists')
        .where('members.$uid', isNull: false)
        .where('status', isEqualTo: 'ativa') // Filtra apenas listas ativas
        .snapshots()
        .map((snapshot) {
      final lists = snapshot.docs
          .map((doc) => ShoppingListModel.fromFirestore(doc))
          .toList();

      // Lógica de ordenação: purchaseDate (mais próxima) > createdAt
      lists.sort((a, b) {
        // Se ambos têm purchaseDate, compara por ela
        if (a.purchaseDate != null && b.purchaseDate != null) {
          return a.purchaseDate!.compareTo(b.purchaseDate!); // Crescente (mais próxima primeiro)
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
        return b.createdAt.compareTo(a.createdAt); // Decrescente (mais recente primeiro)
      });
      return lists;
    });
  }

  // Cria uma nova lista de compras
  Future<void> createList(String name, DateTime? purchaseDate) async {
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

      await _firestore.collection('lists').add({
        'name': name,
        'ownerId': uid,
        'createdAt': now,
        'updatedAt': now,
        'lastUpdatedBy': uid,
        'status': 'ativa',
        'members': {uid: 'owner'},
        'purchaseDate': purchaseDate != null ? Timestamp.fromDate(purchaseDate) : null,
      });

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
      Get.snackbar('Erro', 'Você precisa estar logado para arquivar uma lista.');
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();

      await _firestore.collection('lists').doc(listId).update({
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

  // Atualiza uma lista existente
  Future<void> updateList(ShoppingListModel list, String newName, DateTime? newPurchaseDate) async {
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

      await _firestore.collection('lists').doc(list.id).update({
        'name': newName,
        'purchaseDate': newPurchaseDate != null ? Timestamp.fromDate(newPurchaseDate) : null,
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
