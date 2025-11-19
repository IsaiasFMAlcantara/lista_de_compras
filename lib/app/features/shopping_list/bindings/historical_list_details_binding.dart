import 'package:get/get.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/historical_list_details_controller.dart';

class HistoricalListDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoricalListDetailsController>(
      () => HistoricalListDetailsController(
        repository: Get.find<ShoppingListRepository>(),
      ),
    );
  }
}
