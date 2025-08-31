import 'dart:io';

import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:bms_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'BMS Mobile',
            theme: AppTheme.lightCupertinoTheme,
            debugShowCheckedModeBanner: false,
            home: Container(),
          )
        : MaterialApp(
            title: 'BMS Mobile',
            theme: AppTheme.lightMaterialTheme,
            debugShowCheckedModeBanner: false,
            home: Container(),
          );
  }
}
