import 'dart:async';
import 'dart:developer';

import 'package:bms_mobile/core/shared/providers.dart';
import 'package:bms_mobile/user/shared/providers.dart' as user_providers;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_notifier.g.dart';

@Riverpod(keepAlive: true)
class MessagingNotifier extends _$MessagingNotifier {
  StreamSubscription<String>? _tokenSub;

  @override
  FutureOr<void> build() async {
    ref.onDispose(() async {
      await _tokenSub?.cancel();
      _tokenSub = null;
    });
  }

  Future<void> initialize() async {
    try {
      final messaging = ref.read(firebaseMessagingProvider);
      // iOS permission
      if (!kIsWeb) {
        await messaging.requestPermission();
      }

      final auth = ref.read(firebaseAuthProvider);
      final user = auth.currentUser;
      if (user == null) return;

      // Get initial token and store
      final token = await messaging.getToken();
      if (token != null) {
        await _storeToken(user, token);
      }

      // Listen for refresh
      await _tokenSub?.cancel();
      _tokenSub = messaging.onTokenRefresh.listen((String newToken) async {
        try {
          await _storeToken(user, newToken);
        } catch (e, s) {
          log('Failed to update FCM token: $e', stackTrace: s);
        }
      });
    } catch (e, s) {
      log('Messaging init failed: $e', stackTrace: s);
      rethrow;
    }
  }

  Future<void> _storeToken(User user, String token) async {
    final repo = ref.read(user_providers.userRepositoryProvider);
    final installId = await ref
        .read(installIdServiceProvider)
        .getOrCreateInstallId();
    await repo.addFcmToken(uid: user.uid, token: token, installId: installId);
  }
}
