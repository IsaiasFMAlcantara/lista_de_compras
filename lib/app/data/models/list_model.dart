import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ListModel extends Equatable {
  final String? id;
  final String name;
  final String ownerId;
  final String status;
  final String categoryId;
  final DateTime createdAt;
  final DateTime? purchaseDate;
  final List<String> memberUIDs;
  final Map<String, String> memberPermissions;
  final double totalPrice;

  const ListModel({
    this.id,
    required this.name,
    required this.ownerId,
    required this.status,
    required this.categoryId,
    required this.createdAt,
    this.purchaseDate,
    required this.memberUIDs,
    required this.memberPermissions,
    this.totalPrice = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        ownerId,
        status,
        categoryId,
        createdAt,
        purchaseDate,
        memberUIDs,
        memberPermissions,
        totalPrice,
      ];

  ListModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? status,
    String? categoryId,
    DateTime? createdAt,
    DateTime? purchaseDate,
    List<String>? memberUIDs,
    Map<String, String>? memberPermissions,
    double? totalPrice,
  }) {
    return ListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      memberUIDs: memberUIDs ?? this.memberUIDs,
      memberPermissions: memberPermissions ?? this.memberPermissions,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerId': ownerId,
      'status': status,
      'categoryId': categoryId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'purchaseDate': purchaseDate?.millisecondsSinceEpoch,
      'memberUIDs': memberUIDs,
      'memberPermissions': memberPermissions,
      'totalPrice': totalPrice,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'],
      name: map['name'] ?? '',
      ownerId: map['ownerId'] ?? '',
      status: map['status'] ?? '',
      categoryId: map['categoryId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      purchaseDate: map['purchaseDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'])
          : null,
      memberUIDs: List<String>.from(map['memberUIDs'] ?? []),
      memberPermissions: Map<String, String>.from(map['memberPermissions'] ?? {}),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
    );
  }

    factory ListModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ListModel.fromMap({'id': snapshot.id, ...data});
  }
}
