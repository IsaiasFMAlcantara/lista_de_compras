import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia o AuthController
    Get.put(AuthController());

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
