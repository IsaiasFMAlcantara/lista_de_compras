import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'manage_product_controller.dart';

class ManageProductView extends GetView<ManageProductController> {
  const ManageProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Editar Produto' : 'Adicionar Produto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // --- Seção de Imagem do Produto ---
              Obx(
                () => GestureDetector(
                  onTap: controller.showImageSourceActionSheet,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: controller.image.value != null
                        ? Image.file(File(controller.image.value!.path), fit: BoxFit.cover)
                        : (controller.imageUrl.isNotEmpty
                            ? Image.network(controller.imageUrl.value, fit: BoxFit.cover)
                            : const Icon(Icons.camera_alt, size: 50, color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Campos do Formulário ---
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // --- Botão de Salvar ---
              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: controller.saveProduct,
                        child: const Text('Salvar Produto'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}