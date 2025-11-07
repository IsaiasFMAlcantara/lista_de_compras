import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/shopping_list_controller.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/custom_drawer.dart';
import 'package:lista_compras/view/widgets/lists/single_column_card_list.dart';
import 'package:lista_compras/view/widgets/create_list_dialog.dart'; // Import the new dialog

import 'package:lista_compras/routers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia o controller das listas de compras
    final ShoppingListController controller = Get.put(ShoppingListController());

    return Scaffold(
      appBar: const CustomAppBar(title: 'Minhas Listas'),
      drawer: CustomDrawer(),
      body: controller.obx(
        (state) => SingleColumnCardList(
          itemCount: state!.length,
          itemBuilder: (context, index) {
            final list = state[index];
            // Formata a data para exibição
            final subtitle = list.purchaseDate != null
                ? 'Comprar em: ${DateFormat('dd/MM/yyyy').format(list.purchaseDate!.toDate())}'
                : 'Criada em: ${DateFormat('dd/MM/yyyy').format(list.createdAt.toDate())}';

            return ListTile(
              title: Text(list.name),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.toNamed(AppRoutes.listDetailsPage, arguments: list);
              },
            );
          },
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(
            child: Text('Você ainda não tem nenhuma lista de compras.')),
        onError: (error) => const Center(
            child: Text('Você ainda não tem nenhuma lista de compras.')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            CreateListDialog(controller: controller),
          ); // Use the new dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
