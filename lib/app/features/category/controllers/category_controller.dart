import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/category_model.dart';
import 'package:lista_compras/app/data/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository repository;
  CategoryController({required this.repository});

  final _categories = Rx<List<CategoryModel>>([]);
  List<CategoryModel> get categories => _categories.value;

  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _categories.bindStream(repository.getCategories());
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void clearForm() {
    nameController.clear();
  }

  Future<void> addCategory() async {
    if (formKey.currentState!.validate()) {
      if (_userId == null) {
        Get.snackbar('Erro', 'Você precisa estar logado para criar uma categoria.');
        return;
      }
      isLoading.value = true;
      try {
        final newCategory = CategoryModel(
          name: nameController.text,
          createdBy: _userId!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await repository.addCategory(newCategory);
        Get.back(); // Fecha o bottom sheet ou dialog
        Get.snackbar('Sucesso', 'Categoria criada!');
        clearForm();
      } catch (e) {
        Get.snackbar('Erro', 'Não foi possível criar a categoria.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final updatedCategory = category.copyWith(
          name: nameController.text,
          updatedAt: DateTime.now(),
        );
        await repository.updateCategory(updatedCategory);
        Get.back(); // Fecha o bottom sheet ou dialog
        Get.snackbar('Sucesso', 'Categoria atualizada!');
        clearForm();
      } catch (e) {
        Get.snackbar('Erro', 'Não foi possível atualizar a categoria.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteCategory(CategoryModel category) async {
    if (category.id == null) return;
     try {
      await repository.deleteCategory(category.id!);
      Get.snackbar('Sucesso', 'Categoria excluída!');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível excluir a categoria.');
    }
  }
}
