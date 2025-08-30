import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lista_compras/controller/spending_analysis_controller.dart';

class PieChartCard extends StatelessWidget {
  final SpendingAnalysisController controller;

  const PieChartCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categorySpendingData.isEmpty) {
        return const Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Não há dados de categorias para exibir no gráfico.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Gastos por Categoria',
                style: Get.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: controller.categorySpendingData,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback:
                          (
                            FlTouchEvent event,
                            PieTouchResponse? pieTouchResponse,
                          ) {
                            // Handle touch events if needed
                          },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
