import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/data/models/user_model.dart';
import 'package:lista_compras/app/data/repositories/category_repository.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final AuthController authController;
  final ShoppingListRepository shoppingListRepository;
  final CategoryRepository categoryRepository;

  HomeController({
    required this.authController,
    required this.shoppingListRepository,
    required this.categoryRepository,
  });

  // --- Observables for the View ---
  final username = ''.obs;
  final upcomingLists = <ListModel>[].obs;
  final lastPurchase = Rx<ListModel?>(null);
  final monthlyTotal = 0.0.obs;
  final categorySpending = <String, double>{}.obs;
  final categoryNames = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Reage às mudanças do usuário carregado pelo AuthController
    ever(authController.firestoreUser, (UserModel? user) {
      if (user != null) {
        username.value = user.name;
      } else {
        username.value = 'Usuário';
      }
    });

    _loadDashboardData();
  }

  void _loadDashboardData() {
    // A lógica do nome de usuário foi movida para o 'ever' worker acima.

    final userId = authController.firebaseUser.value?.uid;
    if (userId == null) {
      // Escuta por mudanças no firebaseUser para carregar os dados quando ele estiver disponível.
      once(authController.firebaseUser, (User? user) {
        if (user != null) {
          _fetchDataForUser(user.uid);
        }
      });
    } else {
      _fetchDataForUser(userId);
    }
  }

  void _fetchDataForUser(String userId) {
    // 2. Fetch upcoming lists and sort them
    shoppingListRepository.getLists(userId).listen((lists) {
      lists.sort((a, b) {
        if (a.purchaseDate == null && b.purchaseDate == null) return 0;
        if (a.purchaseDate == null) return 1;
        if (b.purchaseDate == null) return -1;
        return a.purchaseDate!.compareTo(b.purchaseDate!);
      });
      upcomingLists.value = lists;
    });

    // 3. Fetch historical lists for calculations
    shoppingListRepository.getHistoricalLists(userId).listen((history) {
      if (history.isEmpty) {
        lastPurchase.value = null;
        monthlyTotal.value = 0.0;
        categorySpending.value = {};
        return;
      }

      // 4. Find last purchase
      history.sort((a, b) {
        if (a.finalizedDate == null && b.finalizedDate == null) return 0;
        if (a.finalizedDate == null) return 1; // Consider nulls as older
        if (b.finalizedDate == null) return -1;
        return b.finalizedDate!.compareTo(a.finalizedDate!);
      });
      lastPurchase.value = history.first;

      // 5. Calculate monthly spending
      final now = DateTime.now();
      final currentMonthLists = history
          .where((list) =>
              list.finalizedDate != null &&
              list.finalizedDate!.year == now.year &&
              list.finalizedDate!.month == now.month)
          .toList();

      monthlyTotal.value = currentMonthLists.fold(0.0, (sum, list) => sum + list.totalPrice);

      // 6. Calculate category spending for the month
      final spending = <String, double>{};
      for (var list in currentMonthLists) {
        final categoryId = list.categoryId.isNotEmpty ? list.categoryId : 'sem-categoria';
        spending.update(categoryId, (value) => value + list.totalPrice,
            ifAbsent: () => list.totalPrice);
      }
      categorySpending.value = spending;
    });

    // 7. Fetch category names for the chart
    categoryRepository.getCategories().listen((categories) {
      categoryNames.value = {for (var cat in categories) cat.id!: cat.name};
    });
  }
}

