class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? fcmToken; // New field for FCM token

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.fcmToken, // New field for FCM token
  });

  // Converte um objeto UserModel para um Map (formato JSON do Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'fcmToken': fcmToken, // Add FCM token to JSON
    };
  }

  // Cria um objeto UserModel a partir de um Map (documento do Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      fcmToken: map['fcmToken'], // Get FCM token from map
    );
  }
}
