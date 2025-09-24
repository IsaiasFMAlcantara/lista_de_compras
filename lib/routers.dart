import 'package:get/get.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/view/history_page.dart';
import 'package:lista_compras/view/login_page.dart';
import 'package:lista_compras/view/home_page.dart';
import 'package:lista_compras/view/list_details_page.dart';
import 'package:lista_compras/view/members_page.dart';
import 'package:lista_compras/view/product_catalog_page.dart';
import 'package:lista_compras/view/spending_analysis_page.dart';
import 'package:lista_compras/view/splash_page.dart';

class AppRoutes {
  static const splash = '/';
  static const homePage = '/homePage';
  static const loginpage = '/loginpage';
  static const productCatalogPage = '/product-catalog';
  static const listDetailsPage = '/list-details';
  static const historyPage = '/history';
  static const spendingAnalysisPage = '/spending-analysis';
  static const membersPage = '/members';

  List<GetPage> define() {
    return [
      GetPage(name: splash, page: () => const SplashPage()),
      GetPage(name: homePage, page: () => const HomePage()),
      GetPage(name: loginpage, page: () => const LoginPage()),
      GetPage(name: productCatalogPage, page: () => const ProductCatalogPage()),
      GetPage(
        name: listDetailsPage,
        page: () {
          final ShoppingListModel list = Get.arguments as ShoppingListModel;
          return ListDetailsPage(shoppingList: list);
        },
      ),
      GetPage(name: historyPage, page: () => const HistoryPage()),
      GetPage(
        name: spendingAnalysisPage,
        page: () => const SpendingAnalysisPage(),
      ),
      GetPage(name: membersPage, page: () => const MembersPage()),
    ];
  }
}
