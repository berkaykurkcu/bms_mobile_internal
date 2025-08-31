import 'package:bms_mobile/auth/domain/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteService {
  AuthRemoteService(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> storeUserType(String uid, UserType userType) async {
    try {
      await _firestore.collection('user_types').doc(uid).set({
        'type': userType.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to store user type: $e');
    }
  }

  Future<UserType?> getUserType(String uid) async {
    try {
      final doc = await _firestore.collection('user_types').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final type = doc.data()!['type'] as String?;

      if (type == null) return null;

      // Handle legacy 'trainer' user type - return null to trigger migration in AuthRepository
      if (type == 'trainer') {
        return null;
      }

      try {
        return UserType.values.firstWhere((e) => e.name == type);
      } catch (e) {
        // If user type doesn't exist, return null
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get user type: $e');
    }
  }

  Exception _handleFirebaseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'user-not-found' || 'wrong-password' => FirebaseAuthException(
          code: error.code,
          message: 'Invalid email or password',
        ),
        'email-already-in-use' => FirebaseAuthException(
          code: error.code,
          message: 'This email is already registered',
        ),
        'weak-password' => FirebaseAuthException(
          code: error.code,
          message: 'Password is too weak',
        ),
        'invalid-email' => FirebaseAuthException(
          code: error.code,
          message: 'Invalid email format',
        ),
        'network-request-failed' => FirebaseAuthException(
          code: error.code,
          message: 'Network error. Please check your connection',
        ),
        _ => FirebaseAuthException(
          code: error.code,
          message: error.message ?? 'Authentication error occurred',
        ),
      };
    }
    return Exception(error.toString());
  }
}
