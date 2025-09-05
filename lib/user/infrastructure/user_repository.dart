import 'package:bms_mobile/user/domain/user_repository_interface.dart';
import 'package:bms_mobile/user/infrastructure/user_remote_service.dart';

class UserRepository implements UserRepositoryInterface {
  UserRepository(this._remoteService);

  final UserRemoteService _remoteService;

  @override
  Future<void> addFcmToken({
    required String uid,
    required String token,
    required String installId,
  }) async {
    await _remoteService.addFcmToken(
      uid: uid,
      token: token,
      installId: installId,
    );
  }

  @override
  Future<void> removeFcmToken({
    required String uid,
    required String token,
  }) async {
    await _remoteService.removeFcmToken(uid: uid, token: token);
  }
}
