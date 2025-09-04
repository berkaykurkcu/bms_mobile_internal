import 'package:bms_mobile/core/shared/providers.dart';
import 'package:bms_mobile/user/domain/user_repository_interface.dart';
import 'package:bms_mobile/user/infrastructure/user_remote_service.dart';
import 'package:bms_mobile/user/infrastructure/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
UserRemoteService userRemoteService(Ref ref) {
  return UserRemoteService(ref.watch(firebaseFirestoreProvider));
}

@riverpod
UserRepositoryInterface userRepository(Ref ref) {
  return UserRepository(ref.watch(userRemoteServiceProvider));
}
