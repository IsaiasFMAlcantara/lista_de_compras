import 'package:get/get.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/view/LoginPage.dart';
import 'package:lista_compras/view/HomePage.dart';
import 'package:lista_compras/view/list_details_page.dart';
import 'package:lista_compras/view/product_catalog_page.dart';
import 'package:lista_compras/view/splash_page.dart';

class AppRoutes{
  static const splash = '/';
  static const homePage = '/homePage';
  static const loginpage = '/loginpage';
  static const productCatalogPage = '/product-catalog';
  static const listDetailsPage = '/list-details';


  List<GetPage> define(){
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
    ];
  }
}