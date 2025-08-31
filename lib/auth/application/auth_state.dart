import 'package:bms_mobile/auth/domain/user_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    UserType? userType,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;
}
