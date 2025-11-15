import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/user_model.dart';
import 'package:lista_compras/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLogin = true.obs;
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void submit() {
    if (isLoading.value) return;

    isLoading.value = true;
    if (isLogin.value) {
      _loginUser();
    } else {
      _createUser();
    }
    isLoading.value = false;
  }

  void _createUser() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await _firestore
          .collection('users')
          .doc(newUser.id)
          .set(newUser.toMap());

      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Erro no Cadastro', e.message ?? 'Ocorreu um erro');
    } catch (e) {
      Get.snackbar('Erro no Cadastro', 'Ocorreu um erro inesperado.');
    }
  }

  void _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Erro no Login', e.message ?? 'Ocorreu um erro');
    } catch (e) {
      Get.snackbar('Erro no Login', 'Ocorreu um erro inesperado.');
    }
  }
}

