import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListModel {
  final String id;
  final String name;
  final String ownerId;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String lastUpdatedBy;
  final String status;
  final Map<String, String>
      members; // Key: UID, Value: permissão ('owner', 'editor', etc.)
  final String category; // Categoria da lista (ex: Mercado, Farmácia)
  final Timestamp? purchaseDate; // Data da compra (opcional)
  final double? totalPrice; // Preço total da compra (calculado ao finalizar)
  final Timestamp? finishedAt; // Data em que a compra foi finalizada
  final String? scheduledNotificationId; // ID do documento da notificação agendada

  ShoppingListModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastUpdatedBy,
    required this.status,
    required this.members,
    required this.category,
    this.purchaseDate,
    this.totalPrice,
    this.finishedAt,
    this.scheduledNotificationId,
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
      'category': category,
      'purchaseDate': purchaseDate,
      'totalPrice': totalPrice,
      'finishedAt': finishedAt,
      'scheduledNotificationId': scheduledNotificationId,
    };
  }

  // Cria um objeto ShoppingListModel a partir de um DocumentSnapshot do Firestore
  factory ShoppingListModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ShoppingListModel(
      id: doc.id,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
      lastUpdatedBy: data['lastUpdatedBy'] ?? '',
      status: data['status'] ?? 'ativa',
      members: Map<String, String>.from(data['members'] ?? {}),
      category:
          data['category'] ?? 'Outros', // Padrão 'Outros' para listas antigas
      purchaseDate: data['purchaseDate'] as Timestamp?,
      totalPrice: (data['totalPrice'] as num?)?.toDouble(),
      finishedAt: data['finishedAt'] as Timestamp?,
      scheduledNotificationId: data['scheduledNotificationId'],
    );
  }
}
