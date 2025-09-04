import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteService {
  UserRemoteService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addFcmToken({
    required String uid,
    required String token,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          'fcmTokens': FieldValue.arrayUnion([token]),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to add FCM token: $e');
    }
  }

  Future<void> removeFcmToken({
    required String uid,
    required String token,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          'fcmTokens': FieldValue.arrayRemove([token]),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to remove FCM token: $e');
    }
  }
}
