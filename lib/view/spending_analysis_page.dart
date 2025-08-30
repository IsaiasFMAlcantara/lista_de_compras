import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/spending_analysis_controller.dart';
import 'package:lista_compras/view/widgets/custom_app_bar.dart';
import 'package:lista_compras/view/widgets/custom_drawer.dart';
import 'package:lista_compras/view/widgets/date_range_pickers.dart'; // Import new widget
import 'package:lista_compras/view/widgets/total_spending_card.dart'; // Import new widget
import 'package:lista_compras/view/widgets/pie_chart_card.dart'; // Import new widget

class SpendingAnalysisPage extends StatelessWidget {
  const SpendingAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SpendingAnalysisController controller = Get.put(
      SpendingAnalysisController(),
    );
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Scaffold(
      appBar: const CustomAppBar(title: 'Análise de Gastos'),
      drawer: CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DateRangePickers(controller: controller), // Use new widget
              const SizedBox(height: 24),

              TotalSpendingCard(
                controller: controller,
                currencyFormat: currencyFormat,
              ), // Use new widget
              const SizedBox(height: 24),

              PieChartCard(controller: controller), // Use new widget
            ],
          ),
        );
      }),
    );
  }
}
