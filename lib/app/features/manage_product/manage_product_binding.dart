import 'package:get/get.dart';
import 'package:lista_compras/app/data/providers/product_provider.dart';
import 'manage_product_controller.dart';

class ManageProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductProvider>(
      () => ProductProvider(),
    );
    Get.lazyPut<ManageProductController>(
      () => ManageProductController(),
    );
  }
}