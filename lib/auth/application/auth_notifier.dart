import 'dart:async';
import 'dart:developer';

import 'package:bms_mobile/auth/application/auth_state.dart';
import 'package:bms_mobile/auth/domain/auth_repository_interface.dart';
import 'package:bms_mobile/auth/infrastructure/auth_remote_service.dart';
import 'package:bms_mobile/auth/infrastructure/auth_repository.dart';
import 'package:bms_mobile/core/shared/providers.dart';
import 'package:bms_mobile/user/shared/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@riverpod
AuthRemoteService authRemoteService(Ref ref) {
  return AuthRemoteService(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
AuthRepositoryInterface authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authRemoteServiceProvider),
    ref.watch(firebaseFirestoreProvider),
  );
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late StreamSubscription<User?> _authStateSubscription;
  bool _hasInitializedServices = false;

  @override
  AuthState build() {
    _setupAuthStateChangesListener();
    ref.onDispose(() {
      _authStateSubscription.cancel();
    });
    return const AuthState();
  }

  void _setupAuthStateChangesListener() {
    final authRepository = ref.read(authRepositoryProvider);

    _authStateSubscription = authRepository.authStateChanges.listen(
      (user) async {
        if (user != null) {
          try {
            final userType = await authRepository.getCurrentUserType();
            state = state.copyWith(
              user: user,
              userType: userType,
              errorMessage: null,
            );

            if (!_hasInitializedServices) {
              _initializeUserServices();
              _hasInitializedServices = true;
            }
          } catch (e) {
            state = state.copyWith(user: user, errorMessage: e.toString());

            if (!_hasInitializedServices) {
              _initializeUserServices();
              _hasInitializedServices = true;
            }
          }
        } else {
          _hasInitializedServices = false;
          state = state.copyWith(
            user: null,
            userType: null,
            errorMessage: null,
          );
        }
      },
    );
  }

  void _initializeUserServices() {
    try {
      // ref.read(notificationNotifierProvider.notifier).initialize();
    } catch (e) {
      log('Failed to initialize notification system: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final user = await authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      final userType = await authRepository.getCurrentUserType();

      state = state.copyWith(
        user: user,
        userType: userType,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      log('Failed to sign in with email and password: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String areaCode,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final userModel = await authRepository.signUpUserWithEmailAndPassword(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        areaCode: areaCode,
      );

      final userType = await authRepository.getCurrentUserType();

      state = state.copyWith(
        user: authRepository.currentUser,
        userType: userType,
        isLoading: false,
        errorMessage: null,
      );

      return userModel;
    } catch (e) {
      log('Failed to sign up user with email and password: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();

      // Don't invalidate providers that watch authNotifierProvider
      //to avoid circular dependency
      // These providers will automatically be refreshed when
      //the auth state changes

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }
}
