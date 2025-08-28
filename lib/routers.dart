import 'package:get/get.dart';
import 'package:lista_compras/view/LoginPage.dart';
import 'package:lista_compras/view/HomePage.dart';
import 'package:lista_compras/view/splash_page.dart';

class AppRoutes{
  static const splash = '/';
  static const homePage = '/homePage';
  static const loginpage = '/loginpage';

  List<GetPage> define(){
    return [
      GetPage(name: splash, page: () => const SplashPage()),
      GetPage(name: homePage, page: () => HomePage()),
      GetPage(name: loginpage, page: () => const LoginPage()),
    ];
  }
}