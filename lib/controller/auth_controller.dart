import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/helpers/error_helper.dart';
import 'package:lista_compras/model/user_model.dart';
import 'package:lista_compras/routers.dart';
import 'package:lista_compras/repositories/auth_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lista_compras/services/logger_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final LoggerService _logger = Get.find<LoggerService>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isLoginView = true.obs;
  var isPasswordVisible = false.obs;

  final Rxn<User> _firebaseUser = Rxn<User>();
  final Rxn<UserModel> userModel = Rxn<UserModel>();

  User? get user => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser.bindStream(_authRepository.authStateChanges);
    ever(_firebaseUser, _handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) async {
    if (user == null) {
      userModel.value = null;
      Get.offAllNamed(AppRoutes.loginpage);
    } else {
      await _loadUserModel(user.uid);
      await _updateFCMToken(user.uid);
      Get.offAllNamed(AppRoutes.homePage);
    }
  }

  Future<void> _loadUserModel(String uid) async {
    try {
      userModel.value = await _authRepository.getUserModelFromFirestore(uid);
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    }
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      await _authRepository.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar(
        'Erro de Login',
        getFirebaseErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar(
        'Erro de Cadastro',
        'As senhas não coincidem.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await _authRepository.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _createUserInFirestore(userCredential.user!);
      }
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar(
        'Erro de Cadastro',
        getFirebaseErrorMessage(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createUserInFirestore(User firebaseUser) async {
    try {
      final newUser = UserModel(
        id: firebaseUser.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );
      await _authRepository.createUserInFirestore(newUser);
      userModel.value = newUser;
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Erro',
        'Por favor, digite seu e-mail para redefinir a senha.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authRepository.sendPasswordResetEmail(emailController.text.trim());
      Get.snackbar(
        'Sucesso',
        'E-mail de redefinição de senha enviado. Verifique sua caixa de entrada.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut();
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void toggleView() {
    isLoginView.value = !isLoginView.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> _updateFCMToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _authRepository.updateUserFCMToken(uid, token);
      }
    } catch (e, s) {
      _logger.logError(e, s);
    }
  }
}
