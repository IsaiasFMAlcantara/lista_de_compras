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
                          if (Get.currentRoute != Routes.home) {
                            Get.offAllNamed(Routes.home);              }
            },
          ),          
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Produtos'),
            onTap: () {
              Get.back(); // Fecha o drawer
                          if (Get.currentRoute != Routes.products) {
                            Get.toNamed(Routes.products);              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Minhas Listas'),
            onTap: () {
              Get.back(); // Fecha o drawer
                          if (Get.currentRoute != Routes.shoppingListOverview) {
                            Get.toNamed(Routes.shoppingListOverview);              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Compras'),
            onTap: () {
              Get.back(); // Fecha o drawer
                          if (Get.currentRoute != Routes.history) {
                            Get.toNamed(Routes.history);              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorias'),
            onTap: () {
              Get.back(); // Fecha o drawer
                          if (Get.currentRoute != Routes.categories) {
                            Get.toNamed(Routes.categories);              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Análise de Gastos'),
            onTap: () {
              Get.back(); // Fecha o drawer
                          if (Get.currentRoute != Routes.spendingAnalysis) {
                            Get.toNamed(Routes.spendingAnalysis);              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              Get.back(); // Fecha o drawer
                          if (Get.currentRoute != Routes.profile) {
                            Get.toNamed(Routes.profile);              }
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