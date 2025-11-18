import 'package:get/get.dart';
import 'package:lista_compras/app/data/repositories/category_repository.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/data/repositories/user_repository.dart';
import 'package:lista_compras/app/features/category/controllers/category_controller.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';

class ShoppingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShoppingListRepository>(
      () => ShoppingListRepository(),
    );
    Get.lazyPut<UserRepository>(
      () => UserRepository(),
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(),
    );
    Get.lazyPut<CategoryController>(
      () => CategoryController(repository: Get.find<CategoryRepository>()),
    );
    Get.lazyPut<ShoppingListController>(
      () => ShoppingListController(
        repository: Get.find<ShoppingListRepository>(),
        userRepository: Get.find<UserRepository>(),
      ),
    );
  }
}