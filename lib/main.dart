import 'package:bms_mobile/auth/application/auth_notifier.dart';
import 'package:bms_mobile/auth/application/auth_state.dart';
import 'package:bms_mobile/auth/presentation/welcome_page.dart';
import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:bms_mobile/firebase_options.dart';
import 'package:bms_mobile/user/presentation/user_dashboard_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(
      authNotifierProvider,
      (previous, next) {
        final nav = navigatorKey.currentState;
        if (nav == null) return;

        final wasAuth = previous?.user != null;
        final isAuth = next.user != null;

        if (!wasAuth && isAuth) {
          nav.pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const UserDashboardPage(),
            ),
            (route) => false,
          );
        } else if (wasAuth && !isAuth) {
          nav.pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const WelcomePage(),
            ),
            (route) => false,
          );
        }
      },
    );

    return MaterialApp(
      title: 'BMS Mobile',
      theme: AppTheme.lightMaterialTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const WelcomePage(),
    );
  }
}
