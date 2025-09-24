import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_compras/controller/auth_controller.dart';
import 'package:lista_compras/helpers/error_helper.dart';
import 'package:lista_compras/model/product_model.dart';
import 'package:lista_compras/repositories/product_repository.dart';
import 'package:lista_compras/services/logger_service.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository = Get.find<ProductRepository>();
  final AuthController _authController = Get.find<AuthController>();
  final LoggerService _logger = Get.find<LoggerService>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    products.bindStream(_productRepository.getProductsStream());
  }

  Future<void> addProduct(String name, XFile imageFile) async {
    if (name.isEmpty) {
      Get.snackbar('Erro', 'O nome do produto não pode ser vazio.');
      return;
    }

    final user = _authController.user;
    if (user == null) {
      Get.snackbar('Erro', 'Você precisa estar logado para adicionar um produto.');
      return;
    }

    try {
      isLoading.value = true;

      final imageUrl = await _productRepository.uploadImage(imageFile);
      if (imageUrl == null) {
        Get.snackbar('Erro', 'Falha no upload da imagem.');
        isLoading.value = false;
        return;
      }

      await _productRepository.addProduct(name, imageUrl, user.uid);

      Get.snackbar('Sucesso', 'Produto adicionado ao catálogo!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product, String newName, XFile? newImageFile) async {
    if (newName.isEmpty) {
      Get.snackbar('Erro', 'O nome do produto não pode ser vazio.');
      return;
    }

    try {
      isLoading.value = true;
      String imageUrl = product.imageUrl;

      // Se uma nova imagem foi selecionada, faz o upload
      if (newImageFile != null) {
        final newImageUrl = await _productRepository.uploadImage(newImageFile);
        if (newImageUrl == null) {
          Get.snackbar('Erro', 'Falha no upload da nova imagem.');
          isLoading.value = false;
          return;
        }
        imageUrl = newImageUrl;
        // Opcional: deletar a imagem antiga do Firebase Storage
      }

      // Cria um novo produto com os dados atualizados
      final updatedProduct = ProductModel(
        id: product.id,
        name: newName,
        imageUrl: imageUrl,
        createdBy: product.createdBy,
        status: product.status,
        createdAt: product.createdAt,
        updatedAt: Timestamp.now(), // Atualiza o timestamp
      );

      await _productRepository.updateProduct(updatedProduct);

      Get.snackbar('Sucesso', 'Produto atualizado!');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      await _productRepository.deleteProduct(productId);
      Get.snackbar('Sucesso', 'Produto removido do catálogo.');
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', getFirebaseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (e, s) {
      _logger.logError(e, s);
      Get.snackbar('Erro', 'Falha ao selecionar imagem.');
      return null;
    }
  }
}
