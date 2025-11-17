import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/app/data/models/product_model.dart';

class ProductProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromDocumentSnapshot(doc);
      }).toList();
    });
  }

  Future<DocumentReference> addProductAndGetReference(ProductModel product) async {
    return await _firestore.collection(_collection).add(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    if (product.id == null) {
      throw Exception('Product ID cannot be null for update.');
    }
    await _firestore.collection(_collection).doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(_collection).doc(productId).delete();
  }
}