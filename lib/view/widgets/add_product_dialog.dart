import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/controller/product_controller.dart';

class AddProductDialog extends StatelessWidget {
  final ProductController controller;

  const AddProductDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final Rx<XFile?> imageFile = Rx<XFile?>(null);

    return AlertDialog(
      title: Text('Adicionar Novo Produto', style: Theme.of(context).textTheme.titleLarge),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            const SizedBox(height: 20),
            Obx(
              () => imageFile.value == null
                  ? Text('Nenhuma imagem selecionada.', style: Theme.of(context).textTheme.bodyMedium)
                  : Image.file(File(imageFile.value!.path), height: 100),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Selecionar Imagem'),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  imageFile.value = pickedFile;
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(child: const Text('Cancelar'), onPressed: () => Get.back()),
        Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  child: const Text('Adicionar'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        imageFile.value != null) {
                      controller.addProduct(
                        nameController.text,
                        imageFile.value!,
                      ); // Pass XFile directly
                      Get.back(); // Fecha o dialog
                    }
                  },
                );
        }),
      ],
    );
  }
}
