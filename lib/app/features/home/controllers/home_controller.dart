import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH);
  }
}

