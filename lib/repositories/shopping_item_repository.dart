import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/model/shopping_item_model.dart';

class ShoppingItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ShoppingItemModel>> getItemsStream(String listId) {
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
        });
  }

  Future<void> addItem(String listId, Map<String, dynamic> itemData) async {
    await _firestore
        .collection('lists')
        .doc(listId)
        .collection('items')
        .add(itemData);
  }

  Future<void> updateItemCompletion(
    String listId,
    String itemId,
    bool isCompleted,
    String updatedBy,
  ) async {
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
  }

  Future<void> updateItem(
    String listId,
    String itemId,
    Map<String, dynamic> updateData,
  ) async {
    await _firestore
        .collection('lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update(updateData);
  }

  Future<void> deleteItem(String listId, String itemId) async {
    await _firestore
        .collection('lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .delete();
  }
}
