import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/shopping_item_controller.dart';
import 'package:lista_compras/controller/suggestion_controller.dart';

class SuggestionCarousel extends StatelessWidget {
  final String listId;

  const SuggestionCarousel({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    final SuggestionController suggestionController = Get.put(SuggestionController());
    final ShoppingItemController itemController = Get.find<ShoppingItemController>();

    return Obx(() {
      if (suggestionController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (suggestionController.suggestions.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Sugestões para você',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestionController.suggestions.length,
                itemBuilder: (context, index) {
                  final product = suggestionController.suggestions[index];
                  return Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16.0 : 8.0,
                      right: index == suggestionController.suggestions.length - 1 ? 16.0 : 8.0,
                    ),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          itemController.addItem(
                            listId,
                            product.name,
                            1, // Default quantity
                            productId: product.id,
                          );
                          Get.snackbar(
                            'Adicionado',
                            '${product.name} foi adicionado à sua lista.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.shopping_bag, size: 40, color: Colors.grey);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.name,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
