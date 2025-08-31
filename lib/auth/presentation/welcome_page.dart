import 'package:bms_mobile/auth/presentation/register_page.dart';
import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:bms_mobile/core/presentation/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Icon(
                Icons.chair,
                size: 64,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'BMS',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'BMS Mobil Internal',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTextColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Kayıt Ol',
                onPressed: () => {
                  Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (context) => const RegisterPage(),
                    ),
                  ),
                },
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Giriş Yap',
                isOutlined: true,
                onPressed: () => {},
              ),
              const SizedBox(height: 24),

              TextButton(
                onPressed: () async {
                  final url = Uri.parse('https://bmsmobilya.com');

                  if (await canLaunchUrl(
                    url,
                  )) {
                    print('URL can be launched');
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  'BMS Mobilya',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
