import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/app/features/category/controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.categories.isEmpty) {
            return const Center(
              child: Text('Nenhuma categoria encontrada. Crie uma nova!'),
            );
          }
          return ListView.builder(
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              final isOwner =
                  category.createdBy == FirebaseAuth.instance.currentUser?.uid;
              return ListTile(
                title: Text(category.name),
                trailing: isOwner
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showCategoryForm(context, category: category);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _showDeleteConfirmation(context, category),
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryForm(BuildContext context, {dynamic category}) {
    final isEditing = category != null;
    if (isEditing) {
      controller.nameController.text = category.name;
    } else {
      controller.clearForm();
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isEditing ? 'Editar Categoria' : 'Nova Categoria',
                  style: Get.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Categoria',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (isEditing) {
                            controller.updateCategory(category);
                          } else {
                            controller.addCategory();
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(isEditing ? 'Salvar' : 'Adicionar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic category) {
    Get.defaultDialog(
      title: 'Excluir Categoria',
      middleText: 'Tem certeza que deseja excluir a categoria "${category.name}"?',
      textConfirm: 'Excluir',
      textCancel: 'Cancelar',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteCategory(category);
        Get.back();
      },
    );
  }
}
