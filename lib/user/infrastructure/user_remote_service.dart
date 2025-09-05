import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

class UserRemoteService {
  UserRemoteService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addFcmToken({
    required String uid,
    required String token,
    required String installId,
  }) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final platform = _currentPlatform();
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(token);
      await docRef.set({
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': platform,
        'installId': installId,
        'appVersion': info.version,
        'buildNumber': info.buildNumber,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to add FCM token: $e');
    }
  }

  Future<void> removeFcmToken({
    required String uid,
    required String token,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(token)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove FCM token: $e');
    }
  }

  String _currentPlatform() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'funchsia';
    }
  }
}
