import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart'; // For Colors
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart'; // Import the new repository

class SpendingAnalysisController extends GetxController {
  // Inject ShoppingListRepository
  final ShoppingListRepository _shoppingListRepository = Get.put(
    ShoppingListRepository(),
  );
  final AuthController _authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var startDate = Rx<DateTime?>(null);
  var endDate = Rx<DateTime?>(null);
  var totalSpending = 0.0.obs;
  var categorySpendingData = <PieChartSectionData>[].obs;

  // Predefined colors for categories
  final Map<String, Color> categoryColors = {
    'Mercado': Colors.blue,
    'Farmácia': Colors.green,
    'Loja': Colors.orange,
    'Outros': Colors.grey,
    // Add more colors if more categories are introduced
  };

  @override
  void onInit() {
    super.onInit();
    // Initialize date range to current month
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = DateTime(
      now.year,
      now.month + 1,
      0,
    ); // Last day of current month
    fetchSpendingData();
  }

  Future<void> fetchSpendingData() async {
    final user = _authController.user;
    if (user == null) return;

    try {
      isLoading.value = true;
      final lists = await _shoppingListRepository.getFilteredShoppingLists(
        // Use repository method
        user.uid,
        'finalizada',
        startDate.value,
        endDate.value,
      );

      _calculateSpending(lists);
      _preparePieChartData(lists);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível buscar os dados de gastos.');
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime? newStartDate, DateTime? newEndDate) {
    startDate.value = newStartDate;
    endDate.value = newEndDate;
    fetchSpendingData();
  }

  void _calculateSpending(List<ShoppingListModel> lists) {
    double total = 0.0;
    for (var list in lists) {
      total += list.totalPrice ?? 0.0;
    }
    totalSpending.value = total;
  }

  void _preparePieChartData(List<ShoppingListModel> lists) {
    final Map<String, double> categoryTotals = {};

    for (var list in lists) {
      categoryTotals.update(
        list.category,
        (value) => value + (list.totalPrice ?? 0.0),
        ifAbsent: () => list.totalPrice ?? 0.0,
      );
    }

    final List<PieChartSectionData> sections = [];
    categoryTotals.forEach((category, total) {
      sections.add(
        PieChartSectionData(
          color:
              categoryColors[category] ??
              Colors.grey, // Use predefined colors or default
          value: total,
          title: totalSpending.value > 0
              ? '${(total / totalSpending.value * 100).toStringAsFixed(1)}%'
              : '0%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: _buildBadge(
            category,
            categoryColors[category] ?? Colors.grey,
          ),
          badgePositionPercentageOffset: 1.4,
        ),
      );
    });
    categorySpendingData.value = sections;
  }

  Widget _buildBadge(String category, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
