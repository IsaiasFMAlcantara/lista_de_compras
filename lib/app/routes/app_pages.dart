import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/bindings/auth_binding.dart';
import 'package:lista_compras/app/features/auth/views/auth_view.dart';
import 'package:lista_compras/app/features/home/bindings/home_binding.dart';
import 'package:lista_compras/app/features/home/views/home_view.dart';
import 'package:lista_compras/app/features/category/bindings/category_binding.dart';
import 'package:lista_compras/app/features/category/views/category_view.dart';
import 'package:lista_compras/app/features/manage_product/manage_product_binding.dart';
import 'package:lista_compras/app/features/manage_product/manage_product_view.dart';
import 'package:lista_compras/app/features/product/product_binding.dart';
import 'package:lista_compras/app/features/product/product_selection_view.dart';
import 'package:lista_compras/app/features/product/product_view.dart';
import 'package:lista_compras/app/features/profile/profile_binding.dart';
import 'package:lista_compras/app/features/profile/profile_view.dart';
import 'package:lista_compras/app/features/shopping_list/bindings/shopping_list_binding.dart';
import 'package:lista_compras/app/features/shopping_list/views/members_view.dart';
import 'package:lista_compras/app/features/shopping_list/views/shopping_list_details_view.dart';
import 'package:lista_compras/app/features/shopping_list/views/shopping_list_overview_view.dart';
import 'package:lista_compras/app/features/history/bindings/history_binding.dart';
import 'package:lista_compras/app/features/history/views/history_view.dart';
import 'package:lista_compras/app/features/spending_analysis/bindings/spending_analysis_binding.dart';
import 'package:lista_compras/app/features/shopping_list/bindings/historical_list_details_binding.dart';
import 'package:lista_compras/app/features/shopping_list/views/historical_list_details_view.dart';
import 'package:lista_compras/app/features/spending_analysis/views/spending_analysis_view.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HISTORICAL_LIST_DETAILS,
      page: () => const HistoricalListDetailsView(),
      binding: HistoricalListDetailsBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.SPENDING_ANALYSIS,
      page: () => const SpendingAnalysisView(),
      binding: SpendingAnalysisBinding(),
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
    GetPage(
      name: Routes.CATEGORIES,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.SHOPPING_LIST_DETAILS,
      page: () => const ShoppingListDetailsView(),
      binding: ShoppingListBinding(),
    ),
    GetPage(
      name: Routes.SHOPPING_LIST_OVERVIEW,
      page: () => const ShoppingListOverviewView(),
      binding: ShoppingListBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT_SELECTION,
      page: () => const ProductSelectionView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.MEMBERS,
      page: () => const MembersView(),
      binding: ShoppingListBinding(),
    ),
  ];
}
