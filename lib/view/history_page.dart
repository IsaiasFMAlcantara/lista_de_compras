import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/history_controller.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/custom_drawer.dart';
import 'package:lista_compras/view/widgets/history_list_tile.dart'; // Import the new widget

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());

    return Scaffold(
      appBar: const CustomAppBar(title: 'Histórico de Listas'),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.historicalLists.isEmpty) {
          return const Center(
            child: Text('Seu histórico de listas está vazio.'),
          );
        }
        return ListView.builder(
          itemCount: controller.historicalLists.length,
          itemBuilder: (context, index) {
            final list = controller.historicalLists[index];
            return HistoryListTile(list: list); // Use the new widget
          },
        );
      }),
    );
  }
}
