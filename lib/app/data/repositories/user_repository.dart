import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_compras/app/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<UserModel?> findUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromDocumentSnapshot(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      // Handle exceptions as needed
      print(e);
      return null;
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection(_collectionPath).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
