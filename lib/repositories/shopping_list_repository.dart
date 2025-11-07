import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/model/shopping_item_model.dart';
import 'package:lista_compras/services/logger_service.dart';

class ShoppingListRepository {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  ShoppingListRepository({
    FirebaseFirestore? firestore,
    required LoggerService logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger;

  Stream<List<ShoppingListModel>> getShoppingListsStream(
    String uid,
    String status,
  ) {
    try {
      return _firestore
          .collection('lists')
          .where('members.$uid', isNull: false)
          .where('status', isEqualTo: status)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ShoppingListModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();
      }).handleError((error, stackTrace) {
        _logger.logError(error, stackTrace);
        throw error;
      });
    } catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      // Return a stream that emits an error
      return Stream.error(e);
    }
  }

  Future<String> addList(Map<String, dynamic> listData) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('lists').add(listData);
      return docRef.id;
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateList(
    String listId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      await _firestore.collection('lists').doc(listId).update(updateData);
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<ShoppingItemModel>> getShoppingListItems(String listId) async {
    try {
      final itemsSnapshot = await _firestore
          .collection('lists')
          .doc(listId)
          .collection('items')
          .get();
      return itemsSnapshot.docs
          .map((doc) => ShoppingItemModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Stream<List<ShoppingListModel>> getHistoricalListsStream(String uid) {
    try {
      return _firestore
          .collection('lists')
          .where('members.$uid', isNull: false)
          .where('status', whereIn: ['finalizada', 'arquivada'])
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ShoppingListModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList();
      }).handleError((error, stackTrace) {
        _logger.logError(error, stackTrace);
        throw error;
      });
    } catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      return Stream.error(e);
    }
  }

  Future<List<ShoppingListModel>> getFilteredShoppingLists(
    String uid,
    String status,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    try {
      Query query = _firestore
          .collection('lists')
          .where('members.$uid', isNull: false)
          .where('status', isEqualTo: status);

      if (startDate != null) {
        query = query.where(
          'finishedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        query = query.where(
          'finishedAt',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

      final snapshot = await query.orderBy('finishedAt', descending: true).get();
      return snapshot.docs
          .map((doc) => ShoppingListModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }
}