import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/model/product_model.dart';
import 'package:lista_compras/services/logger_service.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final LoggerService _logger;

  ProductRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    required LoggerService logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _logger = logger;

  Stream<List<ProductModel>> getProductsStream() {
    try {
      return _firestore
          .collection('products')
          .orderBy('name')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
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

  Future<void> addProduct(
    String name,
    String imageUrl,
    String createdBy,
  ) async {
    try {
      final now = Timestamp.now();
      await _firestore.collection('products').add({
        'name': name,
        'imageUrl': imageUrl,
        'createdBy': createdBy,
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      });
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final ref = _storage.ref().child('product_images').child(fileName);
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }
}
