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