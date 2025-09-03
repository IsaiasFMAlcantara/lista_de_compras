import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/helpers/error_helper.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart';
import 'package:lista_compras/services/logger_service.dart';

class ShoppingListController extends GetxController {
  final ShoppingListRepository _shoppingListRepository = Get.put(
    ShoppingListRepository(),
  );
  final AuthController _authController = Get.find<AuthController>();
  final LoggerService _logger = Get.find<LoggerService>();

  final RxList<ShoppingListModel> shoppingLists = <ShoppingListModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _authController.user;
    if (user != null) {
      shoppingLists.bindStream(_getShoppingListsStream(user.uid));
    }
  }

  Stream<List<ShoppingListModel>> _getShoppingListsStream(String uid) {
    return _shoppingListRepository
        .getShoppingListsStream(uid, 'ativa')
        .map((lists) {
      lists.sort((a, b) {
        if (a.purchaseDate != null && b.purchaseDate != null) {
          return a.purchaseDate!.compareTo(b.purchaseDate!);
        }
        if (a.purchaseDate != null) return -1;
        if (b.purchaseDate != null) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
      return lists;
    });
  }

  Future<void> createList(
    String name,
    String category,
    DateTime? purchaseDate,
  ) async {
    if (name.isEmpty) {
      Get.snackbar('Erro', 'O nome da lista não pode ser vazio.');
      return;
    }

    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para criar uma lista.');
      return;
    }

    try {
      isLoading.value = true;
      final now = Timestamp.now();
      final uid = user.uid;

      final listData = {
        'name': name,
        'ownerId': uid,
        'createdAt': now,
        'updatedAt': now,
        'lastUpdatedBy': uid,
        'status': 'ativa',
        'members': {uid: 'owner'},
        'category': category,
        'purchaseDate':
            purchaseDate != null ? Timestamp.fromDate(purchaseDate) : null,
        'scheduledNotificationId': null, // Initialize as null
      };

      String newListId = await _shoppingListRepository.addList(listData);

      if (purchaseDate != null) {
        final notificationId = await _scheduleNewNotification(
          newListId,
          name,
          purchaseDate,
        );
        if (notificationId != null) {
          await _shoppingListRepository.updateList(newListId, {
            'scheduledNotificationId': notificationId,
          });
        }
      }

      Get.snackbar('Sucesso', 'Lista "$name" criada!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateList(
    ShoppingListModel list,
    String newName,
    String newCategory,
    DateTime? newPurchaseDate,
  ) async {
    if (newName.isEmpty) {
      Get.snackbar('Erro', 'O nome da lista não pode ser vazio.');
      return;
    }

    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para editar uma lista.');
      return;
    }

    try {
      isLoading.value = true;

      // Handle notification logic before updating the list
      await _handleNotificationOnUpdate(
        list: list,
        newPurchaseDate: newPurchaseDate,
        listName: newName,
      );

      // Update the rest of the list data
      await _shoppingListRepository.updateList(list.id, {
        'name': newName,
        'category': newCategory,
        'purchaseDate':
            newPurchaseDate != null ? Timestamp.fromDate(newPurchaseDate) : null,
        'updatedAt': Timestamp.now(),
        'lastUpdatedBy': user.uid,
      });

      Get.snackbar('Sucesso', 'Lista atualizada com sucesso!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> archiveList(ShoppingListModel list) async {
    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado.');
      return;
    }

    try {
      isLoading.value = true;
      // Cancel any pending notification before archiving
      await _deleteNotification(list.scheduledNotificationId);

      await _shoppingListRepository.updateList(list.id, {
        'status': 'arquivada',
        'updatedAt': Timestamp.now(),
        'lastUpdatedBy': user.uid,
        'scheduledNotificationId': null,
      });
      Get.snackbar('Sucesso', 'Lista arquivada com sucesso!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> finishList(ShoppingListModel list) async {
    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado.');
      return;
    }

    try {
      isLoading.value = true;
      // Cancel any pending notification before finishing
      await _deleteNotification(list.scheduledNotificationId);

      final items = await _shoppingListRepository.getShoppingListItems(list.id);
      double totalPrice = 0.0;
      for (var item in items) {
        if (item.price != null && item.quantity > 0) {
          totalPrice += item.price! * item.quantity;
        }
      }

      await _shoppingListRepository.updateList(list.id, {
        'status': 'finalizada',
        'totalPrice': totalPrice,
        'finishedAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'lastUpdatedBy': user.uid,
        'scheduledNotificationId': null,
      });

      Get.snackbar('Sucesso', 'Compra finalizada e movida para o histórico!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  // --- Notification Helper Methods ---

  Future<void> _handleNotificationOnUpdate({
    required ShoppingListModel list,
    required DateTime? newPurchaseDate,
    required String listName,
  }) async {
    final oldPurchaseDate = list.purchaseDate?.toDate();
    final oldNotificationId = list.scheduledNotificationId;

    // Case 1: Date removed
    if (oldPurchaseDate != null && newPurchaseDate == null) {
      await _deleteNotification(oldNotificationId);
      await _shoppingListRepository.updateList(list.id, {
        'scheduledNotificationId': null,
      });
    }

    // Case 2: Date added
    else if (oldPurchaseDate == null && newPurchaseDate != null) {
      final newNotificationId = await _scheduleNewNotification(
        list.id,
        listName,
        newPurchaseDate,
      );
      await _shoppingListRepository.updateList(list.id, {
        'scheduledNotificationId': newNotificationId,
      });
    }

    // Case 3: Date changed
    else if (oldPurchaseDate != null &&
        newPurchaseDate != null &&
        !oldPurchaseDate.isAtSameMomentAs(newPurchaseDate)) {
      await _deleteNotification(oldNotificationId);
      final newNotificationId = await _scheduleNewNotification(
        list.id,
        listName,
        newPurchaseDate,
      );
      await _shoppingListRepository.updateList(list.id, {
        'scheduledNotificationId': newNotificationId,
      });
    }
  }

  Future<String?> _scheduleNewNotification(
    String listId,
    String listName,
    DateTime purchaseDate,
  ) async {
    final user = _authController.userModel.value;
    if (user == null || user.fcmToken == null) return null;

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('scheduled_notifications')
          .add({
        'userId': user.id,
        'listId': listId,
        'listName': listName,
        'fcmToken': user.fcmToken,
        'scheduleTime': Timestamp.fromDate(purchaseDate),
        'sent': false,
        'createdAt': Timestamp.now(),
      });
      return docRef.id;
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar(
        'Erro de Agendamento',
        'A lista foi salva, mas ocorreu um erro ao agendar a notificação.',
      );
      return null;
    }
  }

  Future<void> _deleteNotification(String? notificationId) async {
    if (notificationId == null) return; // Nothing to delete
    try {
      await FirebaseFirestore.instance
          .collection('scheduled_notifications')
          .doc(notificationId)
          .delete();
    } catch (e, s) {
      // Log this error, as it might lead to orphaned notifications
      _logger.logError(e, s);
      Get.snackbar(
        'Erro de Agendamento',
        'Não foi possível remover a notificação antiga, mas a lista foi atualizada.',
      );
    }
  }
}

