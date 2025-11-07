import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/model/shopping_item_model.dart';
import 'package:lista_compras/services/logger_service.dart';

class ShoppingItemRepository {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  ShoppingItemRepository({
    FirebaseFirestore? firestore,
    required LoggerService logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger;

  Stream<List<ShoppingItemModel>> getItemsStream(String listId) {
    try {
      return _firestore
          .collection('lists')
          .doc(listId)
          .collection('items')
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ShoppingItemModel.fromFirestore(doc))
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

  Future<void> addItem(String listId, Map<String, dynamic> itemData) async {
    try {
      await _firestore
          .collection('lists')
          .doc(listId)
          .collection('items')
          .add(itemData);
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateItemCompletion(
    String listId,
    String itemId,
    bool isCompleted,
    String updatedBy,
  ) async {
    try {
      await _firestore
          .collection('lists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .update({
        'isCompleted': isCompleted,
        'updatedAt': Timestamp.now(),
        'createdBy': updatedBy,
      });
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateItem(
    String listId,
    String itemId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      await _firestore
          .collection('lists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .update(updateData);
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    try {
      await _firestore
          .collection('lists')
          .doc(listId)
          .collection('items')
          .doc(itemId)
          .delete();
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }
}
