import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:lista_compras/app/features/home/controllers/home_controller.dart';
import 'package:lista_compras/app/widgets/app_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Página Inicial'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                'Olá, ${authController.firestoreUser.value?.name ?? 'Usuário'}!',
                style: Get.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bem-vindo ao seu assistente de compras.',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Use o menu lateral para navegar.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}