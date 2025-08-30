import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/controller/spending_analysis_controller.dart';

class TotalSpendingCard extends StatelessWidget {
  final SpendingAnalysisController controller;
  final NumberFormat currencyFormat;

  const TotalSpendingCard({
    super.key,
    required this.controller,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Gasto Total no Período',
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                currencyFormat.format(controller.totalSpending.value),
                style: Get.textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
