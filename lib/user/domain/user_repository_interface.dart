abstract class UserRepositoryInterface {
  Future<void> addFcmToken({required String uid, required String token});
  Future<void> removeFcmToken({required String uid, required String token});
}
