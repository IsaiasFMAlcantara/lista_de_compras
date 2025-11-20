import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';

class HistoryController extends GetxController {
  final ShoppingListRepository repository;
  final FirebaseAuth auth;
  HistoryController({required this.repository, required this.auth});

  final _historicalLists = Rx<List<ListModel>>([]);
  List<ListModel> get historicalLists => _historicalLists.value;
  
  final isLoading = true.obs;

  String? get _userId => auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    if (_userId != null) {
      _historicalLists.bindStream(repository.getHistoricalLists(_userId!));
      // Once the stream emits the first value, we set loading to false.
      _historicalLists.listen((_) => isLoading.value = false);
    } else {
      isLoading.value = false;
    }
  }

  void showCloneListDialog(ListModel listToClone, BuildContext context) {
    final shoppingListController = Get.find<ShoppingListController>();
    final newNameController = TextEditingController(text: '[Cópia] ${listToClone.name}');
    final newPurchaseDate = Rx<DateTime?>(null);

    Get.dialog(
      AlertDialog(
        title: const Text('Clonar Lista'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: newNameController,
              decoration: const InputDecoration(labelText: 'Novo Nome da Lista'),
            ),
            const SizedBox(height: 16),
             Obx(() {
                  final selectedDate = newPurchaseDate.value;
                  final text = selectedDate == null
                      ? 'Nenhuma data selecionada'
                      : 'Nova Data: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(text),
                      TextButton(
                        child: const Text('Selecionar'),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            newPurchaseDate.value = picked;
                          }
                        },
                      ),
                    ],
                  );
                }
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              shoppingListController.cloneList(
                listToClone,
                newNameController.text,
                newPurchaseDate.value,
              );
              Get.back(); // Close the dialog
            },
            child: const Text('Clonar'),
          ),
        ],
      ),
    );
  }
}
