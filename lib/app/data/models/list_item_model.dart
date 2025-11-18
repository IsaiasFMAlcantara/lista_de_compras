import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ListItemModel extends Equatable {
  final String? id;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final double quantity;
  final double unitPrice;
  final double totalItemPrice;
  final bool isCompleted;

  const ListItemModel({
    this.id,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalItemPrice,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productImageUrl,
        quantity,
        unitPrice,
        totalItemPrice,
        isCompleted,
      ];

  ListItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImageUrl,
    double? quantity,
    double? unitPrice,
    double? totalItemPrice,
    bool? isCompleted,
  }) {
    return ListItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalItemPrice: totalItemPrice ?? this.totalItemPrice,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalItemPrice': totalItemPrice,
      'isCompleted': isCompleted,
    };
  }

  factory ListItemModel.fromMap(Map<String, dynamic> map) {
    return ListItemModel(
      id: map['id'],
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImageUrl: map['productImageUrl'],
      quantity: (map['quantity'] ?? 0.0).toDouble(),
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalItemPrice: (map['totalItemPrice'] ?? 0.0).toDouble(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  factory ListItemModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ListItemModel.fromMap({'id': snapshot.id, ...data});
  }
}
