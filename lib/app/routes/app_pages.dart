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
import 'package:lista_compras/app/features/auth/forgot_password/bindings/forgot_password_binding.dart';
import 'package:lista_compras/app/features/auth/forgot_password/views/forgot_password_view.dart';
import 'package:lista_compras/app/features/spending_analysis/views/spending_analysis_view.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.historicalListDetails,
      page: () => const HistoricalListDetailsView(),
      binding: HistoricalListDetailsBinding(),
    ),
    GetPage(
      name: Routes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.spendingAnalysis,
      page: () => const SpendingAnalysisView(),
      binding: SpendingAnalysisBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.products,
      page: () => const ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.manageProduct,
      page: () => const ManageProductView(),
      binding: ManageProductBinding(),
    ),
    GetPage(
      name: Routes.categories,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.shoppingListDetails,
      page: () => const ShoppingListDetailsView(),
      binding: ShoppingListBinding(),
    ),
    GetPage(
      name: Routes.shoppingListOverview,
      page: () => const ShoppingListOverviewView(),
      binding: ShoppingListBinding(),
    ),
    GetPage(
      name: Routes.productSelection,
      page: () => const ProductSelectionView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.members,
      page: () => const MembersView(),
      binding: ShoppingListBinding(),
    ),
  ];
}
