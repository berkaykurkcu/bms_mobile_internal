import 'package:bms_mobile/auth/domain/user_type.dart';
import 'package:bms_mobile/user/shared/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepositoryInterface {
  User? get currentUser;

  Stream<User?> get authStateChanges;

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<UserModel> signUpUserWithEmailAndPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String areaCode,
  });

  Future<void> signOut();

  Future<UserType> getCurrentUserType();
}
