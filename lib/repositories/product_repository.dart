import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/model/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<ProductModel>> getProductsStream() {
    return _firestore
        .collection('products')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addProduct(
    String name,
    String imageUrl,
    String createdBy,
  ) async {
    final now = Timestamp.now();
    await _firestore.collection('products').add({
      'name': name,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'status': 'active',
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final ref = _storage.ref().child('product_images').child(fileName);
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // Log the error in a real app
      return null;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
