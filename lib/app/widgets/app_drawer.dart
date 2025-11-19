import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(
            () {
              final user = authController.firestoreUser.value;
              return UserAccountsDrawerHeader(
                accountName: Text(user?.name ?? 'Usuário'),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: (user?.photoUrl?.isNotEmpty == true)
                      ? NetworkImage(user!.photoUrl!)
                      : null,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.HOME) {
                Get.offAllNamed(Routes.HOME);
              }
            },
          ),          
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Produtos'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.PRODUCTS) {
                Get.toNamed(Routes.PRODUCTS);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Minhas Listas'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.SHOPPING_LIST_OVERVIEW) {
                Get.toNamed(Routes.SHOPPING_LIST_OVERVIEW);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Compras'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.HISTORY) {
                Get.toNamed(Routes.HISTORY);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorias'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.CATEGORIES) {
                Get.toNamed(Routes.CATEGORIES);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Análise de Gastos'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.SPENDING_ANALYSIS) {
                Get.toNamed(Routes.SPENDING_ANALYSIS);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              Get.back(); // Fecha o drawer
              if (Get.currentRoute != Routes.PROFILE) {
                Get.toNamed(Routes.PROFILE);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authController.logout();
            },
          ),
        ],
      ),
    );
  }
}