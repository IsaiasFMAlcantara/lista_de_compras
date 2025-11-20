import 'dart:io';
import 'package:lista_compras/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/app/data/models/product_model.dart';
import 'package:lista_compras/app/data/providers/product_provider.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ManageProductController extends GetxController {
  final ProductModel? product = Get.arguments;

  bool get isEditing => product != null;

  // Dependências
  final AuthController _authController = Get.find();
  final ProductProvider _productProvider = Get.find();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Formulário
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  // Observáveis
  final RxBool isLoading = false.obs;
  final Rx<XFile?> image = Rx<XFile?>(null);
  final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: product?.name);
    descriptionController = TextEditingController(text: product?.description);
    if (product?.imageUrl != null) {
      imageUrl.value = product!.imageUrl!;
    }
  }

  void showImageSourceActionSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = pickedFile;
    }
  }

  Future<String?> _uploadImage(String productId) async {
    if (image.value == null) {
      return null;
    }

    try {
      final ref = _storage.ref('product_images/$productId');
      final uploadTask = await ref.putFile(File(image.value!.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar('Erro de Upload', 'Não foi possível enviar a imagem.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
      return null;
    }
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      String? uploadedImageUrl;

      if (isEditing) {
        // --- MODO EDIÇÃO ---
        if (image.value != null) {
          uploadedImageUrl = await _uploadImage(product!.id!);
        }

        final finalImageUrl = uploadedImageUrl ?? imageUrl.value;

        final updatedProduct = ProductModel(
          id: product!.id,
          name: nameController.text,
          description: descriptionController.text,
          ownerId: product!.ownerId,
          createdAt: product!.createdAt,
          updatedAt: DateTime.now(),
          imageUrl: finalImageUrl,
        );

        await _productProvider.updateProduct(updatedProduct);
        Get.back();
        Get.snackbar('Sucesso', 'Produto atualizado!',
        backgroundColor: AppTheme.successColor, colorText: Colors.white);
      } else {
        // --- MODO ADIÇÃO ---
        final newProduct = ProductModel(
          name: nameController.text,
          description: descriptionController.text,
          ownerId: _authController.firebaseUser.value!.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          // A URL da imagem é adicionada após o upload
        );

        final docRef = await _productProvider.addProductAndGetReference(newProduct);
        
        if (image.value != null) {
          uploadedImageUrl = await _uploadImage(docRef.id);
          if (uploadedImageUrl != null) {
            await docRef.update({'imageUrl': uploadedImageUrl});
          }
        }
        
        Get.back();
        Get.snackbar('Sucesso', 'Produto adicionado!',
        backgroundColor: AppTheme.successColor, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível salvar o produto.',
        backgroundColor: AppTheme.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}