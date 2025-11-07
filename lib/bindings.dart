import 'package:get/get.dart';
import 'package:lista_compras/repositories/auth_repository.dart';
import 'package:lista_compras/repositories/product_repository.dart';
import 'package:lista_compras/repositories/shopping_item_repository.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart';
import 'package:lista_compras/services/logger_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<LoggerService>(() => LoggerService(), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(logger: Get.find()), fenix: true);
    Get.lazyPut<ProductRepository>(() => ProductRepository(logger: Get.find()), fenix: true);
    Get.lazyPut<ShoppingListRepository>(() => ShoppingListRepository(logger: Get.find()), fenix: true);
    Get.lazyPut<ShoppingItemRepository>(() => ShoppingItemRepository(logger: Get.find()), fenix: true);
  }
}
