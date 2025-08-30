import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/model/user_model.dart';
import 'package:lista_compras/routers.dart';
import 'package:lista_compras/repositories/auth_repository.dart'; // Import the new repository
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

class AuthController extends GetxController {
  // Inject AuthRepository
  final AuthRepository _authRepository = Get.put(AuthRepository());

  // Controllers para os campos de texto
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isLoginView = true.obs;
  var isPasswordVisible = false.obs;

  // Variável reativa para o usuário do FirebaseAuth
  final Rxn<User> _firebaseUser = Rxn<User>();
  // Variável reativa para o nosso modelo de usuário do Firestore
  final Rxn<UserModel> userModel = Rxn<UserModel>();

  // Getter para acessar o usuário de fora do controller
  User? get user => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser.bindStream(
      _authRepository.authStateChanges,
    ); // Use repository stream
    // "ouvinte" que reage às mudanças na variável _firebaseUser
    ever(_firebaseUser, _handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) async {
    if (user == null) {
      // Se o usuário deslogou, limpa o modelo e vai para a tela de login
      userModel.value = null;
      Get.offAllNamed(AppRoutes.loginpage);
    } else {
      // Se o usuário logou, carrega os dados do Firestore e vai para a home
      await _loadUserModel(user.uid);
      await _updateFCMToken(user.uid); // Update FCM token
      Get.offAllNamed(AppRoutes.homePage);
    }
  }

  // Carrega os dados do usuário do Firestore
  Future<void> _loadUserModel(String uid) async {
    try {
      userModel.value = await _authRepository.getUserModelFromFirestore(
        uid,
      ); // Use repository method
    } catch (e) {
      log('Erro ao carregar modelo de usuário: $e');
      Get.snackbar('Erro', 'Não foi possível carregar os dados do usuário.');
    }
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      await _authRepository.signInWithEmailAndPassword(
        // Use repository method
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Nenhum usuário encontrado com este e-mail.';
          break;
        case 'wrong-password':
          message = 'Senha incorreta. Por favor, tente novamente.';
          break;
        case 'invalid-email':
          message = 'O formato do e-mail é inválido.';
          break;
        case 'user-disabled':
          message = 'Este usuário foi desabilitado.';
          break;
        default:
          message = 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
      }
      Get.snackbar(
        'Erro de Login',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log('Erro desconhecido no login: $e');
      Get.snackbar(
        'Erro',
        'Ocorreu um erro desconhecido.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar(
        'Erro de Cadastro',
        'As senhas não coincidem.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      // 1. Criar usuário no Firebase Auth
      UserCredential userCredential = await _authRepository
          .createUserWithEmailAndPassword(
            // Use repository method
            emailController.text.trim(),
            passwordController.text.trim(),
          );

      // 2. Salvar dados adicionais no Firestore
      if (userCredential.user != null) {
        await _createUserInFirestore(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este e-mail já está em uso por outra conta.';
          break;
        case 'weak-password':
          message = 'A senha é muito fraca. Tente uma mais forte.';
          break;
        case 'invalid-email':
          message = 'O formato do e-mail é inválido.';
          break;
        default:
          message = 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
      }
      Get.snackbar(
        'Erro de Cadastro',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log('Erro desconhecido no cadastro: $e');
      Get.snackbar(
        'Erro',
        'Ocorreu um erro desconhecido.',
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
      // Salva no Firestore usando o repositório
      await _authRepository.createUserInFirestore(newUser);
      // Atualiza o modelo de usuário no controller localmente
      userModel.value = newUser;
    } catch (e) {
      log('Erro ao criar usuário no Firestore: $e');
      Get.snackbar(
        'Erro',
        'Não foi possível salvar os dados do usuário no Firestore.',
      );
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
      await _authRepository.sendPasswordResetEmail(
        emailController.text.trim(),
      ); // Use repository method
      Get.snackbar(
        'Sucesso',
        'E-mail de redefinição de senha enviado. Verifique sua caixa de entrada.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Nenhum usuário encontrado com este e-mail.';
          break;
        case 'invalid-email':
          message = 'O formato do e-mail é inválido.';
          break;
        default:
          message = 'Ocorreu um erro ao enviar o e-mail. Tente novamente.';
      }
      Get.snackbar('Erro', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      log('Erro desconhecido ao redefinir senha: $e');
      Get.snackbar(
        'Erro',
        'Ocorreu um erro desconhecido.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.signOut(); // Use repository method
    } catch (e) {
      log('Erro ao fazer logout: $e');
      Get.snackbar(
        'Erro',
        'Ocorreu um erro ao sair. Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleView() {
    isLoginView.value = !isLoginView.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Method to update the user's FCM token in Firestore
  Future<void> _updateFCMToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _authRepository.updateUserFCMToken(uid, token);
        log('FCM Token updated for user $uid: $token');
      }
    } catch (e) {
      log('Erro ao atualizar FCM Token: $e');
    }
  }
}
