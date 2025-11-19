import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/data/repositories/category_repository.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';

class SpendingAnalysisController extends GetxController {
  final ShoppingListRepository repository;
  final CategoryRepository categoryRepository;
  SpendingAnalysisController({required this.repository, required this.categoryRepository});

  final _historicalLists = Rx<List<ListModel>>([]);
  final spendingByCategory = Rx<Map<String, double>>({});
  final _categoryNames = Rx<Map<String, String>>({});
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final touchedIndex = Rx<int>(-1);

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    if (_userId != null) {
      _historicalLists.bindStream(repository.getHistoricalLists(_userId!));
      ever(_historicalLists, (_) => _calculateSpendingAnalysis());
      categoryRepository.getCategories().listen((categories) {
        _categoryNames.value = {
          for (var category in categories) category.id!: category.name
        };
        _calculateSpendingAnalysis(); // Recalculate spending when categories update
      });
    }
  }

  void _calculateSpendingAnalysis() {
    final Map<String, double> tempSpending = {};
    for (var list in _historicalLists.value) {
      // Apply date filters if set
      if (startDate.value != null && list.purchaseDate != null && list.purchaseDate!.isBefore(startDate.value!)) {
        continue;
      }
      if (endDate.value != null && list.purchaseDate != null && list.purchaseDate!.isAfter(endDate.value!)) {
        continue;
      }

      final category = list.categoryId.isNotEmpty ? list.categoryId : 'Sem Categoria';
      tempSpending.update(category, (value) => value + list.totalPrice,
          ifAbsent: () => list.totalPrice);
    }
    spendingByCategory.value = tempSpending;
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    _calculateSpendingAnalysis(); // Recalculate when filters change
  }

  String categoryName(String categoryId) {
    return _categoryNames.value[categoryId] ?? 'Sem Categoria';
  }
}
