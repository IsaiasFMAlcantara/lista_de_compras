import 'package:get/get.dart';
import 'package:lista_compras/app/data/providers/product_provider.dart';

import 'product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductProvider>(
      () => ProductProvider(),
    );
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}