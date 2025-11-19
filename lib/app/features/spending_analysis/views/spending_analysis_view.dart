import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/app/features/spending_analysis/controllers/spending_analysis_controller.dart';

class SpendingAnalysisView extends GetView<SpendingAnalysisController> {
  const SpendingAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Gastos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(controller.startDate.value == null
                        ? 'Data Inicial'
                        : DateFormat('dd/MM/yyyy').format(controller.startDate.value!)),
                  )),
                ),
                Expanded(
                  child: Obx(() => TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(controller.endDate.value == null
                        ? 'Data Final'
                        : DateFormat('dd/MM/yyyy').format(controller.endDate.value!)),
                  )),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.setDateFilter(null, null),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.spendingByCategory.value.isEmpty) {
                return const Center(
                  child: Text('Nenhum gasto para analisar no período selecionado.'),
                );
              }

              final totalSpending = controller.spendingByCategory.value.values.fold(0.0, (sum, item) => sum + item);

              return Column(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieChartSections(totalSpending, controller.spendingByCategory.value.entries),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              controller.touchedIndex.value = -1;
                              return;
                            }
                            controller.touchedIndex.value =
                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: controller.spendingByCategory.value.entries.map((entry) {
                        final percentage = (entry.value / totalSpending) * 100;
                        return ListTile(
                          leading: Container(
                            width: 20,
                            height: 20,
                            color: _getColorForCategory(controller.categoryName(entry.key)), // Implement this
                          ),
                          title: Text(controller.categoryName(entry.key)),
                          trailing: Text('${percentage.toStringAsFixed(2)}% (R\$ ${entry.value.toStringAsFixed(2)})'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(double totalSpending, Iterable<MapEntry<String, double>> entries) {
    final List<Color> colors = [
      Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.purple, Colors.orange,
      Colors.teal, Colors.pink, Colors.brown, Colors.cyan,
    ];
    int colorIndex = 0;
    int entryIndex = 0;

    return entries.map((entry) {
      final isTouched = entryIndex == controller.touchedIndex.value;
      entryIndex++;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final value = entry.value;
      final percentage = (value / totalSpending) * 100;

      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return PieChartSectionData(
        color: color,
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    // Simple color assignment for demonstration.
    // In a real app, you might want a more robust color management system.
    final int hash = category.hashCode;
    final int r = (hash & 0xFF0000) >> 16;
    final int g = (hash & 0x00FF00) >> 8;
    final int b = (hash & 0x0000FF) >> 0;
    return Color.fromARGB(255, r % 255, g % 255, b % 255);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isStartDate) {
        controller.setDateFilter(picked, controller.endDate.value);
      } else {
        controller.setDateFilter(controller.startDate.value, picked);
      }
    }
  }
}
