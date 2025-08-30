import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/shopping_item_controller.dart';
import 'package:lista_compras/controller/shopping_list_controller.dart';
import 'package:lista_compras/model/shopping_item_model.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/lists/single_column_card_list.dart';

class ListDetailsPage extends StatelessWidget {
  final ShoppingListModel shoppingList;

  const ListDetailsPage({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    final ShoppingListController listController =
        Get.find<ShoppingListController>();
    final ShoppingItemController itemController = Get.put(
      ShoppingItemController(),
    );

    // Vincula o stream de itens para esta lista específica
    itemController.bindItemsStream(shoppingList.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: shoppingList.name,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _showEditListDialog(context, listController, shoppingList);
              } else if (value == 'archive') {
                _showArchiveConfirmationDialog(
                  context,
                  listController,
                  shoppingList.id,
                );
              } else if (value == 'finish') {
                _showFinishConfirmationDialog(
                  context,
                  listController,
                  shoppingList.id,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Editar Lista'),
              ),
              const PopupMenuItem<String>(
                value: 'archive',
                child: Text('Arquivar Lista'),
              ),
              const PopupMenuItem<String>(
                value: 'finish',
                child: Text('Finalizar Compra'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (itemController.isLoading.value && itemController.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (itemController.items.isEmpty) {
          return const Center(child: Text('Nenhum item nesta lista ainda.'));
        }
        return SingleColumnCardList(
          itemCount: itemController.items.length,
          itemBuilder: (context, index) {
            final item = itemController.items[index];
            return ListTile(
              leading: Checkbox(
                value: item.isCompleted,
                onChanged: (bool? value) {
                  if (value != null) {
                    itemController.toggleItemCompletion(
                      shoppingList.id,
                      item.id,
                      value,
                    );
                  }
                },
              ),
              title: Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                'Qtd: ${item.quantity} ${item.price != null ? ' - R\$ ${item.price!.toStringAsFixed(2)}' : ''}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditItemDialog(
                        context,
                        itemController,
                        shoppingList.id,
                        item,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteItemConfirmationDialog(
                        context,
                        itemController,
                        shoppingList.id,
                        item.id,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddItemDialog(context, itemController, shoppingList.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditListDialog(
    BuildContext context,
    ShoppingListController controller,
    ShoppingListModel list,
  ) {
    final TextEditingController nameController = TextEditingController(
      text: list.name,
    );
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(
      list.purchaseDate?.toDate(),
    );
    final Rx<String> selectedCategory = list.category.obs;
    final List<String> categories = ['Mercado', 'Farmácia', 'Loja', 'Outros'];

    Get.dialog(
      AlertDialog(
        title: Text('Editar Lista', style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome da Lista'),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory.value,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  selectedCategory.value = newValue;
                }
              },
            ),
            const SizedBox(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate.value == null
                        ? 'Sem data de compra'
                        : 'Data: ${DateFormat('dd/MM/yyyy').format(selectedDate.value!)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        selectedDate.value = picked;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
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
                    child: const Text('Salvar'),
                    onPressed: () {
                      controller.updateList(
                        list,
                        nameController.text,
                        selectedCategory.value,
                        selectedDate.value,
                      );
                      Get.back(); // Fecha o dialog
                    },
                  );
          }),
        ],
      ),
    );
  }

  void _showArchiveConfirmationDialog(
    BuildContext context,
    ShoppingListController controller,
    String listId,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('Arquivar Lista', style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Tem certeza que deseja arquivar esta lista? Ela não será mais exibida na tela principal.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: const Text('Arquivar'),
            onPressed: () {
              controller.archiveList(listId);
              Get.back(); // Fecha o dialog
              Get.back(); // Volta para a HomePage após arquivar
            },
          ),
        ],
      ),
    );
  }

  void _showFinishConfirmationDialog(
    BuildContext context,
    ShoppingListController controller,
    String listId,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('Finalizar Compra', style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Tem certeza que deseja finalizar esta compra? A lista será movida para o seu histórico.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: const Text('Finalizar'),
            onPressed: () {
              controller.finishList(listId);
              Get.back(); // Fecha o dialog
              Get.back(); // Volta para a HomePage após finalizar
            },
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(
    BuildContext context,
    ShoppingItemController itemController,
    String listId,
  ) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Adicionar Novo Item', style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Item'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Preço (opcional)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          Obx(() {
            return itemController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      final name = nameController.text;
                      final quantity =
                          double.tryParse(quantityController.text) ?? 0.0;
                      final price = double.tryParse(priceController.text);

                      if (name.isNotEmpty && quantity > 0) {
                        itemController.addItem(
                          listId,
                          name,
                          quantity,
                          price: price,
                        );
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Erro',
                          'Nome e quantidade são obrigatórios.',
                        );
                      }
                    },
                  );
          }),
        ],
      ),
    );
  }

  void _showEditItemDialog(
    BuildContext context,
    ShoppingItemController itemController,
    String listId,
    ShoppingItemModel item,
  ) {
    final TextEditingController nameController = TextEditingController(
      text: item.name,
    );
    final TextEditingController quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    final TextEditingController priceController = TextEditingController(
      text: item.price?.toString(),
    );

    Get.dialog(
      AlertDialog(
        title: Text('Editar Item', style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Item'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Preço (opcional)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          Obx(() {
            return itemController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text('Salvar'),
                    onPressed: () {
                      final name = nameController.text;
                      final quantity =
                          double.tryParse(quantityController.text) ?? 0.0;
                      final price = double.tryParse(priceController.text);

                      if (name.isNotEmpty && quantity > 0) {
                        itemController.updateItem(
                          listId,
                          item.id,
                          name,
                          quantity,
                          newPrice: price,
                        );
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Erro',
                          'Nome e quantidade são obrigatórios.',
                        );
                      }
                    },
                  );
          }),
        ],
      ),
    );
  }

  void _showDeleteItemConfirmationDialog(
    BuildContext context,
    ShoppingItemController itemController,
    String listId,
    String itemId,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('Remover Item', style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Tem certeza que deseja remover este item da lista?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: const Text('Remover'),
            onPressed: () {
              itemController.deleteItem(listId, itemId);
              Get.back(); // Fecha o dialog
            },
          ),
        ],
      ),
    );
  }
}
