import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:crypto/crypto.dart' as crypto;
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
      final tokenId = _hashToken(token);
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(tokenId);
      await docRef.set({
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': platform,
        'installId': installId,
        'appVersion': info.version,
        'buildNumber': info.buildNumber,
        'token': token,
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
      final tokenId = _hashToken(token);
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(tokenId)
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

  String _hashToken(String token) {
    final bytes = crypto.sha256.convert(token.codeUnits).bytes;
    final buffer = StringBuffer();
    for (final b in bytes) {
      buffer.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
