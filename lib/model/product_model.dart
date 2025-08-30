import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final String createdBy; // ID do usuário que criou
  final String status;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converte um objeto ProductModel para um Map (formato JSON do Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Cria um objeto ProductModel a partir de um DocumentSnapshot do Firestore
  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      status: data['status'] ?? 'active', // Valor padrão
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }
}
