import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/controller/product_controller.dart';
import 'package:lista_compras/model/product_model.dart';

class EditProductDialog extends StatefulWidget {
  final ProductController controller;
  final ProductModel product;

  const EditProductDialog({
    super.key,
    required this.controller,
    required this.product,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController _nameController;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await widget.controller.pickImage();
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Produto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image preview
            // TODO: Implement image preview
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Alterar Imagem'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Produto',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.controller.updateProduct(
              widget.product,
              _nameController.text,
              _imageFile,
            );
            Get.back();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
