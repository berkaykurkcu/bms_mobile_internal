// lib/user/presentation/user_dashboard_page.dart
import 'package:bms_mobile/auth/application/auth_notifier.dart';
import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ANCHOR: user_dashboard_placeholder
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Paneli'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'User Dashboard (TODO)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.darkTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(authNotifierProvider.notifier).signOut(),
              child: const Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
