import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/app/features/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Controladores de texto
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;

  // Observáveis
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isOldPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializa os controladores com os dados do usuário
    final user = authController.firestoreUser.value;
    nameController = TextEditingController(text: user?.name);
    phoneController = TextEditingController(text: user?.phone);
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    profileImageUrl.value = user?.photoUrl ?? '';
  }

  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
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
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Get.back();
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    isLoading.value = true;
    try {
      final userId = authController.firebaseUser.value!.uid;
      final ref = _storage.ref('profile_pictures/$userId');
      final uploadTask = await ref.putFile(File(image.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({'photoUrl': downloadUrl});
      
      // Atualiza o estado local do usuário
      final currentUser = authController.firestoreUser.value;
      if (currentUser != null) {
        authController.firestoreUser.value = currentUser.copyWith(photoUrl: downloadUrl);
      }
      profileImageUrl.value = downloadUrl;

      Get.snackbar('Sucesso', 'Foto de perfil atualizada!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar a foto de perfil.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile() async {
    isLoading.value = true;
    try {
      final userId = authController.firebaseUser.value!.uid;
      final newName = nameController.text;
      final newPhone = phoneController.text;

      await _firestore.collection('users').doc(userId).update({
        'name': newName,
        'phone': newPhone,
      });

      // Atualiza o estado local do usuário
      final currentUser = authController.firestoreUser.value;
      if (currentUser != null) {
        authController.firestoreUser.value = currentUser.copyWith(
          name: newName,
          phone: newPhone,
        );
      }

      Get.snackbar('Sucesso', 'Perfil atualizado!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar o perfil.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    if (oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty) {
      Get.snackbar('Erro', 'Preencha a senha antiga e a nova senha.');
      return;
    }

    isLoading.value = true;
    try {
      final user = authController.firebaseUser.value;
      if (user == null || user.email == null) {
        Get.snackbar('Erro', 'Usuário não encontrado.');
        return;
      }

      // Reautenticar o usuário
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Alterar a senha
      await user.updatePassword(newPasswordController.text);

      oldPasswordController.clear();
      newPasswordController.clear();
      Get.back(); // Volta para a tela anterior
      Get.snackbar('Sucesso', 'Senha alterada com sucesso!');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Erro', e.message ?? 'Não foi possível alterar a senha.');
    } catch (e) {
      Get.snackbar('Erro', 'Ocorreu um erro inesperado.');
    } finally {
      isLoading.value = false;
    }
  }
}