import 'package:bms_mobile/core/infrastructure/install_id_service.dart';
import 'package:bms_mobile/core/infrastructure/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
FirebaseStorage firebaseStorage(Ref ref) {
  return FirebaseStorage.instance;
}

@riverpod
FirebaseFunctions firebaseFunctions(Ref ref) {
  return FirebaseFunctions.instanceFor(region: 'us-central1');
}

@riverpod
FirebaseMessaging firebaseMessaging(Ref ref) {
  return FirebaseMessaging.instance;
}

@riverpod
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(Ref ref) {
  return FlutterLocalNotificationsPlugin();
}

@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService(
    ref.watch(flutterLocalNotificationsPluginProvider),
  );
}

@riverpod
InstallIdService installIdService(Ref ref) {
  return InstallIdService();
}
