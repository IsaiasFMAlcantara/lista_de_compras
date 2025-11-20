import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lista_compras/app/features/home/controllers/home_controller.dart';
import 'package:lista_compras/app/features/shopping_list/controllers/shopping_list_controller.dart';
import 'package:lista_compras/app/routes/app_routes.dart';
import 'package:lista_compras/app/widgets/app_drawer.dart';
import 'package:lista_compras/app/theme/app_theme.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Espaçamento inicial
            _buildGreeting(),
            const SizedBox(height: 32), // Aumentado
            _buildQuickActions(),
            const SizedBox(height: 32), // Aumentado
            _buildSectionTitle('Próximas Compras'),
            _buildUpcomingPurchases(),
            const SizedBox(height: 32), // Aumentado
            _buildSectionTitle('Resumo do Mês'),
            _buildMonthlySummary(),
            const SizedBox(height: 32), // Aumentado
            _buildSectionTitle('Última Compra'),
            _buildLastPurchase(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Obx(
      () => Text(
        'Olá, ${controller.username.value}!',
        style: Theme.of(Get.context!).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _quickActionButton(
          icon: Icons.add_shopping_cart,
          label: 'Nova Lista',
          onTap: () => Get.find<ShoppingListController>().showAddListDialog(),
        ),
        _quickActionButton(
          icon: Icons.history,
          label: 'Histórico',
                      onTap: () => Get.toNamed(Routes.history),        ),
      ],
    );
  }

  Widget _quickActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(Get.context!).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(Get.context!).textTheme.titleLarge,
    );
  }

  Widget _buildUpcomingPurchases() {
    return Obx(() {
      if (controller.upcomingLists.isEmpty) {
        return const _InfoCard(
          icon: Icons.shopping_bag_outlined,
          text: 'Nenhuma lista de compras ativa.',
        );
      }
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.upcomingLists.length,
          itemBuilder: (context, index) {
            final list = controller.upcomingLists[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => Get.find<ShoppingListController>().selectListAndNavigate(list),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(list.name, style: Get.textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(
                        list.purchaseDate != null
                            ? 'Data: ${DateFormat('dd/MM/yy').format(list.purchaseDate!)}'
                            : 'Sem data',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildMonthlySummary() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Gasto em ${DateFormat.MMMM('pt_BR').format(DateTime.now())}', style: Get.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    'R\$ ${controller.monthlyTotal.value.toStringAsFixed(2)}',
                                              style: Get.textTheme.headlineSmall?.copyWith(color: AppTheme.successColor, fontWeight: FontWeight.bold),                  )),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Obx(() {
                if (controller.categorySpending.isEmpty) {
                  return const SizedBox(height: 80, child: Center(child: Text('Sem dados')));
                }
                return SizedBox(
                  height: 80,
                  width: 80,
                  child: PieChart(
                    PieChartData(
                      sections: _buildPieChartSections(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 20,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final List<Color> colors = [Colors.blue, Colors.orange, Colors.purple, Colors.teal];
    int colorIndex = 0;

    final sortedCategories = controller.categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topCategories = sortedCategories.take(4);

    return topCategories.map((entry) {
      final color = colors[colorIndex++ % colors.length];
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '', // No title inside the chart
        radius: 20,
      );
    }).toList();
  }

  Widget _buildLastPurchase() {
    return Obx(() {
      final purchase = controller.lastPurchase.value;
      if (purchase == null) {
        return const _InfoCard(
          icon: Icons.receipt_long_outlined,
          text: 'Nenhuma compra no seu histórico.',
        );
      }
      return Card(
        elevation: 2,
        child: ListTile(
                                    leading: const Icon(Icons.receipt_long, color: AppTheme.infoColor),          title: Text(purchase.name),
          subtitle: Text('Total: R\$ ${purchase.totalPrice.toStringAsFixed(2)}'),
          trailing: Text(DateFormat('dd/MM/yy').format(purchase.purchaseDate!)),
                                    onTap: () => Get.toNamed(Routes.historicalListDetails, arguments: purchase),        ),
      );
    });
  }
}

// A simple helper widget for info cards
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(width: 16),
            Text(text, style: Get.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}