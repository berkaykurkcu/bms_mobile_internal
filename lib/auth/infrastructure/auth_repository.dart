import 'package:bms_mobile/auth/domain/auth_repository_interface.dart';
import 'package:bms_mobile/auth/domain/user_type.dart';
import 'package:bms_mobile/auth/infrastructure/auth_remote_service.dart';
import 'package:bms_mobile/user/shared/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository(this._authService, this._firestore);

  final AuthRemoteService _authService;
  final FirebaseFirestore _firestore;

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );
    return userCredential.user!;
  }

  @override
  Future<UserModel> signUpUserWithEmailAndPassword({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String areaCode,
  }) async {
    final userCredential = await _authService.createUserWithEmailAndPassword(
      email,
      password,
    );

    final user = userCredential.user!;

    final userModel = UserModel(
      userId: user.uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      areaCode: areaCode,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

    await _authService.storeUserType(user.uid, UserType.admin);

    return userModel;
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<UserType> getCurrentUserType() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    final userType = await _authService.getUserType(currentUser.uid);

    if (userType == null) {
      throw Exception('No user type found');
    }

    return userType;
  }
}
