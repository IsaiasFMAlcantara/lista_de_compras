import 'package:get/get.dart';

class ShoppingListBinding extends Bindings {
  @override
  void dependencies() {
    // A dependência do ShoppingListController foi movida para o InitialBinding
    // para estar disponível globalmente.
  }
}