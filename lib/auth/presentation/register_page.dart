import 'package:bms_mobile/auth/application/auth_notifier.dart';
import 'package:bms_mobile/auth/presentation/custom_app_bar.dart';
import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:bms_mobile/core/presentation/widgets/custom_button.dart';
import 'package:bms_mobile/core/presentation/widgets/custom_text_form_field.dart';
import 'package:bms_mobile/core/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaCodeController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _areaCodeController.text = '+90';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _areaCodeController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(authNotifierProvider.notifier)
            .signUp(
              firstName: _nameController.text,
              lastName: _surnameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              areaCode: _areaCodeController.text,
              phone: _phoneController.text,
            );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Üyelik yapılamadı: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Kayıt Ol',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.chair,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    Text(
                      'BMS',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomTextFormField(
                      controller: _nameController,
                      label: 'Ad',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => Validators.validateRequired(
                        value: value ?? '',
                        fieldName: 'Ad',
                      ),
                    ),
                    const SizedBox(height: 20),

                    CustomTextFormField(
                      label: 'Soyad',
                      controller: _surnameController,
                      validator: (value) => Validators.validateRequired(
                        value: value ?? '',
                        fieldName: 'Soyad',
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomTextFormField(
                            label: 'Alan Kodu',
                            controller: _areaCodeController,
                            validator: (value) =>
                                Validators.validateAreaCode(value ?? ''),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 9,
                          child: CustomTextFormField(
                            label: 'Telefon',
                            controller: _phoneController,
                            validator: (value) =>
                                Validators.validatePhone(value ?? ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    CustomTextFormField(
                      label: 'Email',
                      controller: _emailController,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    CustomTextFormField(
                      label: 'Şifre',
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      validator: (value) =>
                          Validators.validatePassword(value ?? ''),
                    ),
                    const SizedBox(height: 20),

                    CustomTextFormField(
                      label: 'Şifre Tekrar',
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      validator: (value) {
                        final passwordError = Validators.validatePassword(
                          value ?? '',
                        );
                        if (passwordError != null) {
                          return passwordError;
                        }
                        if (value != _passwordController.text) {
                          return 'Şifreler eşleşmiyor';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomButton(
                      text: 'Kayıt Ol',
                      onPressed: _signUp,
                      isLoading: authState.isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
