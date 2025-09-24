import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lista_compras/helpers/error_helper.dart';
import 'package:lista_compras/model/shopping_list_model.dart';
import 'package:lista_compras/model/user_model.dart';
import 'package:lista_compras/repositories/auth_repository.dart';
import 'package:lista_compras/repositories/shopping_list_repository.dart';

class MembersController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final ShoppingListRepository _listRepo = Get.find<ShoppingListRepository>();

  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<List<UserModel>> getMembersDetails(ShoppingListModel list) async {
    List<UserModel> members = [];
    for (String uid in list.members.keys) {
      final user = await _authRepo.getUserModelFromFirestore(uid);
      if (user != null) {
        members.add(user);
      }
    }
    return members;
  }

  Future<void> inviteUser(ShoppingListModel list) async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Erro', 'Por favor, digite o e-mail do usuário.');
      return;
    }

    try {
      isLoading.value = true;

      // 1. Find user by email
      final userToInvite = await _authRepo.getUserByEmail(emailController.text.trim());

      if (userToInvite == null) {
        Get.snackbar('Erro', 'Nenhum usuário encontrado com este e-mail.');
        isLoading.value = false;
        return;
      }

      // 2. Check if user is already a member
      if (list.members.containsKey(userToInvite.id)) {
        Get.snackbar('Aviso', 'Este usuário já é um membro da lista.');
        isLoading.value = false;
        return;
      }

      // 3. Add user to the members map with 'editor' role
      final newMembers = Map<String, String>.from(list.members);
      newMembers[userToInvite.id] = 'editor'; // Default role

      await _listRepo.updateList(list.id, {'members': newMembers});

      Get.snackbar('Sucesso', 'Usuário convidado para a lista!');
      emailController.clear();
      // We need to trigger a refresh on the MembersPage
      update(); // Notify GetX to rebuild widgets

    } catch (e) {
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
}
