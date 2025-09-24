import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/controller/product_controller.dart';
import 'package:lista_compras/model/product_model.dart';
import 'package:lista_compras/model/shopping_item_model.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart';
import 'package:collection/collection.dart';
import 'package:lista_compras/services/logger_service.dart';

class SuggestionController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final ShoppingListRepository _shoppingListRepo =
      Get.find<ShoppingListRepository>();
  final ProductController _productController = Get.find<ProductController>();
  final LoggerService _logger = Get.find<LoggerService>();

  var isLoading = false.obs;
  final RxList<ProductModel> suggestions = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Carrega as sugestões quando o usuário está logado
    if (_authController.user != null) {
      fetchSuggestions();
    }
  }

  Future<void> fetchSuggestions() async {
    final user = _authController.user;
    if (user == null) return;

    try {
      isLoading.value = true;

      // 1. Buscar todas as listas históricas (finalizadas/arquivadas)
      final historicalLists =
          await _shoppingListRepo.getHistoricalListsStream(user.uid).first;

      // 2. Buscar todos os itens de todas essas listas
      final List<Future<List<ShoppingItemModel>>> futureItems =
          historicalLists.map((list) => _shoppingListRepo.getShoppingListItems(list.id)).toList();

      final List<List<ShoppingItemModel>> allItemsNested = await Future.wait(futureItems);
      final List<ShoppingItemModel> allItems = allItemsNested.expand((i) => i).toList();

      if (allItems.isEmpty) {
        suggestions.value = [];
        return;
      }

      // 3. Contar a frequência de cada produto (usando productId)
      final frequencyMap = allItems
          .where((item) => item.productId != null) // Apenas itens com referência de produto
          .groupListsBy((item) => item.productId!)
          .map((key, value) => MapEntry(key, value.length));
      
      // 4. Ordenar os produtos pela frequência
      final sortedProducts = frequencyMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      // 5. Pegar os IDs dos top 5 produtos mais frequentes
      final top5ProductIds = sortedProducts.take(5).map((e) => e.key).toList();

      // 6. Buscar os objetos ProductModel correspondentes
      final allProducts = _productController.products;
      final suggestedProducts = allProducts
          .where((product) => top5ProductIds.contains(product.id))
          .toList();
      
      // Opcional: Reordenar a lista de sugestões para manter a ordem de frequência
      suggestedProducts.sort((a, b) => 
          top5ProductIds.indexOf(a.id).compareTo(top5ProductIds.indexOf(b.id)));

      suggestions.value = suggestedProducts;

    } catch (e, s) {
      _logger.logError(e, s);
      suggestions.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}
