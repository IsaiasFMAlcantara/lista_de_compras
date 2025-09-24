import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart'; // Import the new repository

class HistoryController extends GetxController {
  // Inject ShoppingListRepository
  final ShoppingListRepository _shoppingListRepository = Get.find<ShoppingListRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ShoppingListModel> historicalLists = <ShoppingListModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _authController.user;
    if (user != null) {
      historicalLists.bindStream(_getHistoricalListsStream(user.uid));
    }
  }

  Stream<List<ShoppingListModel>> _getHistoricalListsStream(String uid) {
    return _shoppingListRepository.getHistoricalListsStream(
      uid,
    ); // Use repository method
  }
}
