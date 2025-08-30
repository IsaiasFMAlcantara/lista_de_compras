import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/model/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('products')
          .orderBy('name')
          .get();
      products.value = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os produtos.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(String name, XFile imageFile) async {
    if (name.isEmpty) {
      Get.snackbar('Erro', 'O nome do produto não pode ser vazio.');
      return;
    }

    try {
      isLoading.value = true;

      // 1. Fazer upload da imagem para o Firebase Storage
      final imageUrl = await _uploadImage(imageFile);
      if (imageUrl == null) {
        Get.snackbar('Erro', 'Falha no upload da imagem.');
        return;
      }

      // 2. Criar o novo produto no Firestore
      final now = Timestamp.now();
      final newProduct = {
        'name': name,
        'imageUrl': imageUrl,
        'createdBy': _authController.user!.uid,
        'status': 'active',
        'createdAt': now,
        'updatedAt': now,
      };

      await _firestore.collection('products').add(newProduct);

      Get.snackbar('Sucesso', 'Produto adicionado ao catálogo!');
      fetchProducts(); // Atualiza a lista de produtos
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível adicionar o produto.');
      log(e.toString());
    }
  }

  Future<String?> _uploadImage(XFile imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final ref = _storage.ref().child('product_images').child(fileName);
      final uploadTask = ref.putFile(File(imageFile.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log('Erro no upload da imagem: $e');
      return null;
    }
  }
}
