import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/model/shopping_item_model.dart'; // Needed for getShoppingListItems

class ShoppingListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ShoppingListModel>> getShoppingListsStream(
    String uid,
    String status,
  ) {
    return _firestore
        .collection('lists')
        .where('members.$uid', isNull: false)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ShoppingListModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();
        });
  }

  Future<String> addList(Map<String, dynamic> listData) async {
    DocumentReference docRef = await _firestore.collection('lists').add(listData);
    return docRef.id;
  }

  Future<void> updateList(
    String listId,
    Map<String, dynamic> updateData,
  ) async {
    await _firestore.collection('lists').doc(listId).update(updateData);
  }

  Future<List<ShoppingItemModel>> getShoppingListItems(String listId) async {
    final itemsSnapshot = await _firestore
        .collection('lists')
        .doc(listId)
        .collection('items')
        .get();
    return itemsSnapshot.docs
        .map((doc) => ShoppingItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Stream<List<ShoppingListModel>> getHistoricalListsStream(String uid) {
    return _firestore
        .collection('lists')
        .where('members.$uid', isNull: false)
        .where('status', whereIn: ['finalizada', 'arquivada'])
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ShoppingListModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();
        });
  }

  Future<List<ShoppingListModel>> getFilteredShoppingLists(
    String uid,
    String status,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
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
        .map((doc) => ShoppingListModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
}
