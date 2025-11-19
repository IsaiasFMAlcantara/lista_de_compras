import 'package:get/get.dart';
import 'package:lista_compras/app/data/repositories/category_repository.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // O HomeController agora busca as dependências que já foram
    // inicializadas no InitialBinding.
    Get.lazyPut<HomeController>(
      () => HomeController(
        authController: Get.find<AuthController>(),
        shoppingListRepository: Get.find<ShoppingListRepository>(),
        categoryRepository: Get.find<CategoryRepository>(),
      ),
    );
  }
}