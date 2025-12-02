import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/theme/app_theme.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/data/models/list_item_model.dart';
import 'package:lista_compras/app/data/models/product_model.dart';
import 'package:lista_compras/app/data/models/user_model.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/data/repositories/user_repository.dart';
import 'package:lista_compras/app/features/category/controllers/category_controller.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class ShoppingListController extends GetxController {
  final ShoppingListRepository repository;
  final UserRepository userRepository;
  ShoppingListController({required this.repository, required this.userRepository});

  // --- General State ---
  final isLoading = false.obs;
  String? get _userId => FirebaseAuth.instance.currentUser?.uid; // Corrigido: Este getter é essencial.

  // Novos getters para permissões
  String? get currentUserPermission {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || currentList.value == null) {
      return null;
    }
    return currentList.value!.memberPermissions[userId];
  }

  bool get canEditList => currentUserPermission == 'owner' || currentUserPermission == 'editor';
  bool get isViewer => currentUserPermission == 'viewer';

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
  final canFinalize = false.obs;

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
    // Worker que observa a lista de itens e atualiza a flag 'canFinalize'
    ever(_currentItems, _updateCanFinalize);
  }

  // --- List Management ---
  Future<void> addList() async {
    if (listNameController.text.isEmpty || _userId == null) {
      Get.snackbar('Erro', 'O nome da lista é obrigatório.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
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
      Get.snackbar('Sucesso', 'Lista "$newList.name" criada!',
        backgroundColor: AppTheme.successColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível criar a lista.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteList(String listId) async {
    try {
      await repository.deleteList(listId);
      Get.snackbar('Sucesso', 'Lista excluída.',
        backgroundColor: AppTheme.successColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível excluir a lista.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
    }
  }

  Future<void> cloneList(ListModel originalList, String newName, DateTime? newDate) async {
    if (_userId == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para clonar uma lista.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
      return;
    }
    isLoading.value = true;
    try {
      // 1. Create the new list object
      final clonedList = ListModel(
        name: newName,
        ownerId: _userId!,
        status: 'ativa',
        categoryId: originalList.categoryId,
        createdAt: DateTime.now(),
        purchaseDate: newDate,
        memberUIDs: originalList.memberUIDs, // Keep original members
        memberPermissions: originalList.memberPermissions, // Keep original permissions
        totalPrice: 0.0, // Reset total price
      );

      // 2. Add the new list to the repository and get its ID
      final newListRef = await repository.addList(clonedList);
      final newListId = newListRef.id;

      // 3. Get items from the original list
      final originalItems = await repository.getItemsOnce(originalList.id!);

      // 4. Create new items for the cloned list
      final clonedItems = originalItems.map((item) {
        return item.copyWith(
          isCompleted: false, // Reset completion status
          unitPrice: 0, // Optionally reset price, or keep item.unitPrice
          totalItemPrice: 0, // Reset total
        );
      }).toList();

      // 5. Add items in batch to the new list
      if (clonedItems.isNotEmpty) {
        await repository.addItemsBatch(newListId, clonedItems);
      }

      Get.snackbar('Sucesso', 'Lista "$newName" clonada com sucesso!',
        backgroundColor: AppTheme.successColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível clonar a lista. Tente novamente.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Item Management ---
  void setList(ListModel list) {
    currentList.value = list;
    _currentItems.bindStream(repository.getItems(list.id!));
    _cacheMemberData(list.memberUIDs);
  }

  void _updateCanFinalize(List<ListItemModel> items) {
    canFinalize.value = items.any((item) => item.isCompleted);
  }

  void selectListAndNavigate(ListModel list) {
    setList(list);
    Get.toNamed(Routes.shoppingListDetails);
  }

  Future<void> addItemFromProduct(ProductModel product, double quantity) async {
    if (currentList.value?.id == null) return;

    // Verifica se o item já existe na lista
    final existingItemIndex =
        currentItems.indexWhere((item) => item.productId == product.id);

    if (existingItemIndex != -1) {
      // Se o item existe, pergunta ao usuário se deseja atualizar a quantidade
      final existingItem = currentItems[existingItemIndex];
      Get.dialog(
        AlertDialog(
          title: const Text('Produto já existe'),
          content: Text(
              'O produto "${product.name}" já está na sua lista com quantidade ${existingItem.quantity}. Deseja adicionar mais $quantity?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newQuantity = existingItem.quantity + quantity;
                updateItemQuantity(existingItem, newQuantity);
                Get.back();
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      );
    } else {
      // Se o item não existe, adiciona normalmente
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
        Get.snackbar('Sucesso', '"${product.name}" adicionado à lista!',
            backgroundColor: AppTheme.successColor, colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Erro', 'Não foi possível adicionar o item.',
            backgroundColor: AppTheme.errorColor, colorText: Colors.white);
      }
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
              Get.snackbar('Erro', 'Não foi possível atualizar o preço do item.',
                  backgroundColor: AppTheme.errorColor, colorText: Colors.white);    }
  }

  Future<void> updateItemQuantity(ListItemModel item, double newQuantity) async {
    if (currentList.value?.id == null) return;
    try {
      final updatedItem = item.copyWith(
        quantity: newQuantity,
        // Recalcula o preço total do item se o preço unitário já existir
        totalItemPrice: newQuantity * item.unitPrice,
      );
      await repository.updateItem(currentList.value!.id!, updatedItem);
              Get.snackbar('Sucesso', 'Quantidade de "${item.productName}" atualizada!',
                  backgroundColor: AppTheme.successColor, colorText: Colors.white);    } catch (e) {
              Get.snackbar('Erro', 'Não foi possível atualizar a quantidade do item.',
                  backgroundColor: AppTheme.errorColor, colorText: Colors.white);    }
  }

  Future<void> toggleItemCompletion(ListItemModel item) async {
    if (currentList.value?.id == null) return;
    try {
      final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
      await repository.updateItem(currentList.value!.id!, updatedItem);
    } catch (e) {
              Get.snackbar('Erro', 'Não foi possível atualizar o item.',
                  backgroundColor: AppTheme.errorColor, colorText: Colors.white);    }
  }

  Future<void> deleteItem(ListItemModel item) async {
    if (currentList.value?.id == null || item.id == null) return;
    try {
      await repository.deleteItem(currentList.value!.id!, item.id!);
              Get.snackbar('Sucesso', '"${item.productName}" removido da lista.',
                  backgroundColor: AppTheme.successColor, colorText: Colors.white);    } catch (e) {
              Get.snackbar('Erro', 'Não foi possível remover o item.',
                  backgroundColor: AppTheme.errorColor, colorText: Colors.white);    }
  }

  Future<void> finishShopping() async {
    if (currentList.value?.id == null) return;

    if (!canFinalize.value) {
      Get.snackbar('Atenção', 'Marque pelo menos um item como comprado para finalizar a lista.',
          backgroundColor: AppTheme.infoColor, colorText: Colors.white);
      return;
    }

    // Validação de quantidade e preço para itens selecionados
    final itemsWithZeroValues = currentItems.where((item) =>
        item.isCompleted && (item.quantity <= 0 || item.unitPrice <= 0)).toList();

    if (itemsWithZeroValues.isNotEmpty) {
      Get.snackbar(
        'Erro',
        'Não foi possível finalizar a lista. Existem produtos selecionados com quantidade ou valor zerado.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      double total = 0.0;
      for (var item in currentItems) {
        if (item.isCompleted) {
          total += item.totalItemPrice;
        }
      }

      final updatedList = currentList.value!.copyWith(
        status: 'finalizada',
        totalPrice: total,
        finalizedDate: DateTime.now(), // Define a data de finalização da compra
      );
      await repository.updateList(updatedList);
      currentList.value = updatedList; // Update the observable
      Get.back(); // Go back to the previous screen (ShoppingListOverviewView)
      Get.snackbar('Sucesso', 'Compra "${updatedList.name}" finalizada com sucesso!',
          backgroundColor: AppTheme.successColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível finalizar a compra.',
          backgroundColor: AppTheme.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
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
      Get.snackbar('Erro', 'Digite um e-mail válido.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
      return;
    }
    if (currentList.value == null) return;
    final list = currentList.value!;

    isLoading.value = true;
    try {
      final userToAdd = await userRepository.findUserByEmail(email);
      if (userToAdd == null) {
        Get.snackbar('Erro', 'Usuário não encontrado com este e-mail.',
            backgroundColor: AppTheme.errorColor, colorText: Colors.white);
        isLoading.value = false;
        return;
      }
      if (list.memberUIDs.contains(userToAdd.id)) {
        Get.snackbar('Info', 'Este usuário já é membro da lista.',
            backgroundColor: AppTheme.infoColor, colorText: Colors.white);
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
      Get.snackbar('Sucesso', 'Membro adicionado!',
          backgroundColor: AppTheme.successColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível adicionar o membro.',
          backgroundColor: AppTheme.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeMember(String uid) async {
    if (uid == currentList.value?.ownerId) {
      Get.snackbar('Erro', 'Você não pode remover o dono da lista.',
          backgroundColor: AppTheme.errorColor, colorText: Colors.white);
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
      Get.snackbar('Sucesso', 'Membro removido.',
          backgroundColor: AppTheme.successColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível remover o membro.',
          backgroundColor: AppTheme.errorColor, colorText: Colors.white);
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

  void showAddListDialog() {
    // Importa o CategoryController para acessar as categorias
    final categoryController = Get.find<CategoryController>();

    // Limpa os controladores de texto antes de abrir o diálogo
    listNameController.clear();
    listCategoryController.clear();
    purchaseDate.value = null;
    
    // Define uma categoria padrão se houver alguma disponível
    if (categoryController.categories.isNotEmpty) {
      listCategoryController.text = categoryController.categories.first.id!;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Nova Lista de Compras'),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: listNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Lista',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(() {
                final availableCategories = categoryController.categories.where((c) => c.id != null).toList();
                String? selectedCategoryId = listCategoryController.text.isNotEmpty &&
                                             availableCategories.any((c) => c.id == listCategoryController.text)
                                             ? listCategoryController.text
                                             : null;

                if (selectedCategoryId == null && availableCategories.isNotEmpty) {
                  selectedCategoryId = availableCategories.first.id;
                  listCategoryController.text = selectedCategoryId!;
                }

                return DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: availableCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id!,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      listCategoryController.text = value;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione uma categoria';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                  final selectedDate = purchaseDate.value;
                  final text = selectedDate == null
                      ? 'Nenhuma data selecionada'
                      : 'Data: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(text),
                      TextButton(
                        child: const Text('Selecionar Data'),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: Get.overlayContext!,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != selectedDate) {
                            purchaseDate.value = picked;
                          }
                        },
                      ),
                    ],
                  );
                }
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () => addList(),
                child: isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Criar'),
              ),
          ),
        ],
      ),
    );
  }
}
