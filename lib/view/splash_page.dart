import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/repositories/product_repository.dart';
import 'package:lista_compras/services/logger_service.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia os serviços globais
    Get.put(LoggerService());
    Get.put(ProductRepository()); // Adicionado aqui
    Get.put(AuthController());

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
