import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItemModel {
  final String id;
  final String listId;
  final String? productId; // Opcional: ID do produto do catálogo global
  final String name;
  final double quantity;
  final double? price; // Opcional
  final bool isCompleted;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String createdBy;

  ShoppingItemModel({
    required this.id,
    required this.listId,
    this.productId,
    required this.name,
    required this.quantity,
    this.price,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  // Converte um objeto ShoppingItemModel para um Map para o Firestore
  Map<String, dynamic> toMap() {
    return {
      'listId': listId,
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
    };
  }

  // Cria um objeto ShoppingItemModel a partir de um DocumentSnapshot do Firestore
  factory ShoppingItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ShoppingItemModel(
      id: doc.id,
      listId: data['listId'] ?? '',
      productId: data['productId'],
      name: data['name'] ?? '',
      quantity: data['quantity']?.toDouble() ?? 0.0,
      price: data['price']?.toDouble(),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }
}
