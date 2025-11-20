import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/features/history/controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(
        repository: Get.find<ShoppingListRepository>(),
        auth: FirebaseAuth.instance,
      ),
    );
  }
}
