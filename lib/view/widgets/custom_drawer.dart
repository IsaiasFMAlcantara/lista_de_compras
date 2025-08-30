import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/routers.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Obx(() {
            final user = _authController.userModel.value;
            String userName = user?.name ?? 'Usuário';
            String userEmail = user?.email ?? 'email@exemplo.com';
            String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

            return UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  initial,
                  style: const TextStyle(fontSize: 40.0, color: Colors.blue), // Cor do texto para contraste
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue, // Cor de fundo do header
              ),
            );
          }),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Adicionar Novo Produto'),
            onTap: () {
              Get.back(); // Fecha o drawer
              Get.toNamed(AppRoutes.productCatalogPage);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Compras'),
            onTap: () {
              // TODO: Navegar para a página de Histórico
              Get.back(); // Fecha o drawer
              Get.snackbar('Em Breve', 'Página de histórico ainda em desenvolvimento.');
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Análise de Gastos'),
            onTap: () {
              // TODO: Navegar para a página de Análise
              Get.back();
              Get.snackbar('Em Breve', 'Página de análise ainda em desenvolvimento.');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              _authController.logout();
            },
          ),
        ],
      ),
    );
  }
}
