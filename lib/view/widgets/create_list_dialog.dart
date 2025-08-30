import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/shopping_list_controller.dart';

class CreateListDialog extends StatelessWidget {
  final ShoppingListController controller;

  const CreateListDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
    final Rx<String> selectedCategory = 'Outros'.obs;
    final List<String> categories = ['Mercado', 'Farmácia', 'Loja', 'Outros'];

    return AlertDialog(
      title: const Text('Criar Nova Lista'),
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
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
        TextButton(child: const Text('Cancelar'), onPressed: () => Get.back()),
        Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  child: const Text('Criar'),
                  onPressed: () {
                    controller.createList(
                      nameController.text,
                      selectedCategory.value,
                      selectedDate.value,
                    );
                    Get.back(); // Fecha o dialog
                  },
                );
        }),
      ],
    );
  }
}
