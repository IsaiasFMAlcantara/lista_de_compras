import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/app/data/models/list_item_model.dart';
import 'package:lista_compras/app/data/models/list_model.dart';

class ShoppingListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _listsCollectionPath = 'lists';
  final String _itemsSubcollectionPath = 'items';

  // --- List Methods ---

  Stream<List<ListModel>> getLists(String userId) {
    return _firestore
        .collection(_listsCollectionPath)
        .where('memberUIDs', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ListModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  Future<DocumentReference> addList(ListModel list) {
    return _firestore.collection(_listsCollectionPath).add(list.toMap());
  }

  Future<void> updateList(ListModel list) {
    return _firestore.collection(_listsCollectionPath).doc(list.id).update(list.toMap());
  }

  Future<void> deleteList(String listId) {
    return _firestore.collection(_listsCollectionPath).doc(listId).delete();
  }

  // --- List Item Methods ---

  Stream<List<ListItemModel>> getItems(String listId) {
    return _firestore
        .collection(_listsCollectionPath)
        .doc(listId)
        .collection(_itemsSubcollectionPath)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ListItemModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  Future<void> addItem(String listId, ListItemModel item) {
    return _firestore
        .collection(_listsCollectionPath)
        .doc(listId)
        .collection(_itemsSubcollectionPath)
        .add(item.toMap());
  }

  Future<void> updateItem(String listId, ListItemModel item) {
    return _firestore
        .collection(_listsCollectionPath)
        .doc(listId)
        .collection(_itemsSubcollectionPath)
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> deleteItem(String listId, String itemId) {
    return _firestore
        .collection(_listsCollectionPath)
        .doc(listId)
        .collection(_itemsSubcollectionPath)
        .doc(itemId)
        .delete();
  }
}
