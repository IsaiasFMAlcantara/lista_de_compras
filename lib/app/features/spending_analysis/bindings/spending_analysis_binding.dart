import 'package:get/get.dart';
import 'package:lista_compras/app/data/repositories/category_repository.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/features/spending_analysis/controllers/spending_analysis_controller.dart';

class SpendingAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpendingAnalysisController>(
      () => SpendingAnalysisController(
        repository: Get.find<ShoppingListRepository>(),
        categoryRepository: Get.find<CategoryRepository>(),
      ),
    );
  }
}

