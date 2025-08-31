import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.label,
    required this.controller,
    this.onTap,
    this.readOnly = false,
    this.hint,
    this.isRequired = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.autoCorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.inputFormatters,
    super.key,
  });
  final VoidCallback? onTap;
  final bool readOnly;
  final String label;
  final String? hint;
  final bool isRequired;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool autoCorrect;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autocorrect: autoCorrect,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hint,
        suffixIcon: suffixIcon,
        errorStyle: const TextStyle(color: AppTheme.errorColor, fontSize: 12),
      ),
    );
  }
}
