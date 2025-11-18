import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/app/data/models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'categories';

  Stream<List<CategoryModel>> getCategories() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CategoryModel.fromDocumentSnapshot(doc)).toList();
    });
  }

  Future<void> addCategory(CategoryModel category) {
    return _firestore.collection(_collectionPath).add(category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) {
    return _firestore.collection(_collectionPath).doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) {
    return _firestore.collection(_collectionPath).doc(categoryId).delete();
  }
}
