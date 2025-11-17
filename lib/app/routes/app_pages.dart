import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/bindings/auth_binding.dart';
import 'package:lista_compras/app/features/auth/views/auth_view.dart';
import 'package:lista_compras/app/features/home/bindings/home_binding.dart';
import 'package:lista_compras/app/features/home/views/home_view.dart';
import 'package:lista_compras/app/features/manage_product/manage_product_binding.dart';
import 'package:lista_compras/app/features/manage_product/manage_product_view.dart';
import 'package:lista_compras/app/features/product/product_binding.dart';
import 'package:lista_compras/app/features/product/product_view.dart';
import 'package:lista_compras/app/features/profile/profile_binding.dart';
import 'package:lista_compras/app/features/profile/profile_view.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.MANAGE_PRODUCT,
      page: () => const ManageProductView(),
      binding: ManageProductBinding(),
    ),
  ];
}
