abstract class UserRepositoryInterface {
  Future<void> addFcmToken({
    required String uid,
    required String token,
    required String installId,
  });
  Future<void> removeFcmToken({required String uid, required String token});
}
