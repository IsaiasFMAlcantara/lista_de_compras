import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/data/models/list_item_model.dart';
import 'package:lista_compras/app/data/models/product_model.dart';
import 'package:lista_compras/app/data/models/user_model.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/data/repositories/user_repository.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class ShoppingListController extends GetxController {
  final ShoppingListRepository repository;
  final UserRepository userRepository;
  ShoppingListController({required this.repository, required this.userRepository});

  // --- General State ---
  final isLoading = false.obs;
  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  // --- List Management State ---
  final _lists = Rx<List<ListModel>>([]);
  List<ListModel> get lists => _lists.value;
  final listNameController = TextEditingController();
  final listCategoryController = TextEditingController();
  final purchaseDate = Rx<DateTime?>(null);

  // --- Item Management State ---
  final currentList = Rx<ListModel?>(null);
  final _currentItems = Rx<List<ListItemModel>>([]);
  List<ListItemModel> get currentItems => _currentItems.value;

  // --- Item Form Controllers ---
  final itemNameController = TextEditingController();
  final itemQtyController = TextEditingController(text: '1');
  final itemPriceController = TextEditingController();

  // --- Member Management State ---
  final memberEmailController = TextEditingController();
  final selectedPermission = 'viewer'.obs;
  final _userCache = <String, UserModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (_userId != null) {
      _lists.bindStream(repository.getLists(_userId!));
    }
  }

  // --- List Management ---
  Future<void> addList() async {
    if (listNameController.text.isEmpty || _userId == null) {
      Get.snackbar('Erro', 'O nome da lista é obrigatório.');
      return;
    }
    isLoading.value = true;
    try {
      final newList = ListModel(
        name: listNameController.text,
        ownerId: _userId!,
        status: 'ativa',
        categoryId: listCategoryController.text,
        createdAt: DateTime.now(),
        purchaseDate: purchaseDate.value,
        memberUIDs: [_userId!],
        memberPermissions: {_userId!: 'owner'},
      );
      await repository.addList(newList);
      Get.back(); // Close dialog
      listNameController.clear();
      listCategoryController.clear();
      purchaseDate.value = null;
      Get.snackbar('Sucesso', 'Lista "${newList.name}" criada!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível criar a lista.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteList(String listId) async {
    try {
      await repository.deleteList(listId);
      Get.snackbar('Sucesso', 'Lista excluída.');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível excluir a lista.');
    }
  }

  // --- Item Management ---
  void selectList(ListModel list) {
    currentList.value = list;
    _currentItems.bindStream(repository.getItems(list.id!));
    _cacheMemberData(list.memberUIDs);
    Get.toNamed(Routes.SHOPPING_LIST_DETAILS);
  }

  Future<void> addItemFromProduct(ProductModel product, double quantity) async {
    if (currentList.value?.id == null) return;
    
    final newItem = ListItemModel(
      productId: product.id!,
      productName: product.name,
      productImageUrl: product.imageUrl,
      quantity: quantity,
      unitPrice: 0,
      totalItemPrice: 0,
    );

    try {
      await repository.addItem(currentList.value!.id!, newItem);
      Get.snackbar('Sucesso', '"${product.name}" adicionado à lista!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível adicionar o item.');
    }
  }

  Future<void> updateItemPrice(ListItemModel item, double price) async {
    if (currentList.value?.id == null) return;
    try {
      final updatedItem = item.copyWith(
        unitPrice: price,
        totalItemPrice: item.quantity * price,
      );
      await repository.updateItem(currentList.value!.id!, updatedItem);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar o preço do item.');
    }
  }

  Future<void> toggleItemCompletion(ListItemModel item) async {
    if (currentList.value?.id == null) return;
    try {
      final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
      await repository.updateItem(currentList.value!.id!, updatedItem);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar o item.');
    }
  }

  // --- Member Management ---
  void _cacheMemberData(List<String> uids) {
    for (var uid in uids) {
      if (!_userCache.containsKey(uid)) {
        userRepository.getUserById(uid).then((user) {
          if (user != null) {
            _userCache[uid] = user;
          }
        });
      }
    }
  }

  String getUserEmail(String uid) {
    return _userCache[uid]?.email ?? 'Carregando...';
  }

  Future<void> addMember() async {
    final email = memberEmailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Erro', 'Digite um e-mail válido.');
      return;
    }
    if (currentList.value == null) return;
    final list = currentList.value!;

    isLoading.value = true;
    try {
      final userToAdd = await userRepository.findUserByEmail(email);
      if (userToAdd == null) {
        Get.snackbar('Erro', 'Usuário não encontrado com este e-mail.');
        isLoading.value = false;
        return;
      }
      if (list.memberUIDs.contains(userToAdd.id)) {
        Get.snackbar('Info', 'Este usuário já é membro da lista.');
        isLoading.value = false;
        return;
      }

      final updatedList = list.copyWith(
        memberUIDs: List.from(list.memberUIDs)..add(userToAdd.id),
        memberPermissions: Map.from(list.memberPermissions)..[userToAdd.id] = selectedPermission.value,
      );

      await repository.updateList(updatedList);
      currentList.value = updatedList;
      _cacheMemberData([userToAdd.id]);
      memberEmailController.clear();
      Get.snackbar('Sucesso', 'Membro adicionado!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível adicionar o membro.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeMember(String uid) async {
    if (uid == currentList.value?.ownerId) {
      Get.snackbar('Erro', 'Você não pode remover o dono da lista.');
      return;
    }
    if (currentList.value == null) return;
    final list = currentList.value!;

    isLoading.value = true;
    try {
      final updatedList = list.copyWith(
        memberUIDs: List.from(list.memberUIDs)..remove(uid),
        memberPermissions: Map.from(list.memberPermissions)..remove(uid),
      );
      await repository.updateList(updatedList);
      currentList.value = updatedList;
      Get.snackbar('Sucesso', 'Membro removido.');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível remover o membro.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    listNameController.dispose();
    listCategoryController.dispose();
    memberEmailController.dispose();
    itemNameController.dispose();
    itemQtyController.dispose();
    itemPriceController.dispose();
    super.onClose();
  }
}
