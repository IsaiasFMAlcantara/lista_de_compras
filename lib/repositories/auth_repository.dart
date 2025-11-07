import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lista_compras/model/user_model.dart';
import 'package:lista_compras/services/logger_service.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    required LoggerService logger,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> createUserInFirestore(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toJson());
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel?> getUserModelFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateUserFCMToken(String uid, String? fcmToken) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'fcmToken': fcmToken,
      });
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(e, stackTrace);
      rethrow;
    }
  }
}
