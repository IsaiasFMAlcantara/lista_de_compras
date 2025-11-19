import 'package:get/get.dart';
import 'package:lista_compras/app/data/models/list_item_model.dart';
import 'package:lista_compras/app/data/models/list_model.dart';
import 'package:lista_compras/app/data/repositories/shopping_list_repository.dart';

class HistoricalListDetailsController extends GetxController {
  final ShoppingListRepository repository;
  HistoricalListDetailsController({required this.repository});

  late final ListModel list;
  final items = Rx<List<ListItemModel>>([]);

  @override
  void onInit() {
    super.onInit();
    list = Get.arguments as ListModel;
    items.bindStream(
      repository.getItems(list.id!).map(
            (itemList) => itemList.where((item) => item.isCompleted).toList(),
          ),
    );
  }
}
