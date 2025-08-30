import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListModel {
  final String id;
  final String name;
  final String ownerId;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String lastUpdatedBy;
  final String status;
  final Map<String, String> members; // Key: UID, Value: permissão ('owner', 'editor', etc.)
  final Timestamp? purchaseDate; // Data da compra (opcional)

  ShoppingListModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastUpdatedBy,
    required this.status,
    required this.members,
    this.purchaseDate,
  });

  // Converte um objeto ShoppingListModel para um Map para o Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerId': ownerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastUpdatedBy': lastUpdatedBy,
      'status': status,
      'members': members,
      'purchaseDate': purchaseDate,
    };
  }

  // Cria um objeto ShoppingListModel a partir de um DocumentSnapshot do Firestore
  factory ShoppingListModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ShoppingListModel(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      lastUpdatedBy: data['lastUpdatedBy'] ?? '',
      status: data['status'] ?? 'ativa',
      // O Firestore retorna o mapa como Map<String, dynamic>, então precisamos converter
      members: Map<String, String>.from(data['members'] ?? {}),
      purchaseDate: data['purchaseDate'] as Timestamp?,
    );
  }
}
