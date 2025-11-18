import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/category/controllers/category_controller.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';

class ShoppingListOverviewView extends GetView<ShoppingListController> {
  const ShoppingListOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get other controllers that were injected in the binding
    final shoppingListController = Get.find<ShoppingListController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (shoppingListController.isLoading.value && shoppingListController.lists.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (shoppingListController.lists.isEmpty) {
            return const Center(
              child: Text('Nenhuma lista encontrada. Crie uma nova!'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: shoppingListController.lists.length,
            itemBuilder: (context, index) {
              final list = shoppingListController.lists[index];
              return Card(
                child: ListTile(
                  title: Text(list.name),
                  subtitle: Text('Status: ${list.status}'),
                  trailing: Text('${list.totalPrice.toStringAsFixed(2)} R\$'),
                  onTap: () {
                    shoppingListController.selectList(list);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddListDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddListDialog(BuildContext context) {
    final shoppingListController = Get.find<ShoppingListController>();
    final categoryController = Get.find<CategoryController>();
    
    // Set a default category if available
    if (categoryController.categories.isNotEmpty) {
      shoppingListController.listCategoryController.text = categoryController.categories.first.id!;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Nova Lista de Compras'),
        content: Form(
          // key: shoppingListController.formKey, // A form key should be defined in the controller
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: shoppingListController.listNameController,
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
                String? selectedCategoryId = shoppingListController.listCategoryController.text.isNotEmpty &&
                                             availableCategories.any((c) => c.id == shoppingListController.listCategoryController.text)
                                             ? shoppingListController.listCategoryController.text
                                             : null;

                // If no category is selected and there are available categories, pre-select the first one
                if (selectedCategoryId == null && availableCategories.isNotEmpty) {
                  selectedCategoryId = availableCategories.first.id;
                  shoppingListController.listCategoryController.text = selectedCategoryId!;
                }

                return DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: availableCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id!, // Now guaranteed non-null
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      shoppingListController.listCategoryController.text = value;
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
                  final selectedDate = shoppingListController.purchaseDate.value;
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
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != selectedDate) {
                            shoppingListController.purchaseDate.value = picked;
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
                onPressed: shoppingListController.isLoading.value
                    ? null
                    : () => shoppingListController.addList(),
                child: shoppingListController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Criar'),
              ),
          ),
        ],
      ),
    );
  }
}
