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
  final isPasswordVisible = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> firestoreUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    if (user != null) {
      _loadFirestoreUser(user.uid);
      // Apenas navega se não estivermos já na home
      if (Get.currentRoute != Routes.HOME) {
        Get.offAllNamed(Routes.HOME);
      }
    } else {
      firestoreUser.value = null;
      // Apenas navega se não estivermos já na autenticação
      if (Get.currentRoute != Routes.AUTH) {
        Get.offAllNamed(Routes.AUTH);
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> _loadFirestoreUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        firestoreUser.value = UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os dados do usuário.');
    }
  }

  void submit() async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      if (isLogin.value) {
        await _loginUser();
      } else {
        await _createUser();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createUser() async {
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

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Erro no Cadastro', e.message ?? 'Ocorreu um erro');
    } catch (e) {
      Get.snackbar('Erro no Cadastro', 'Ocorreu um erro inesperado.');
    }
  }

  Future<void> _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Erro no Login', e.message ?? 'Ocorreu um erro');
    } catch (e) {
      Get.snackbar('Erro no Login', 'Ocorreu um erro inesperado.');
    }
  }

  void logout() async {
    await _auth.signOut();
  }
}

