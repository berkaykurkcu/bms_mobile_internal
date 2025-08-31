import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.isLoading = false,
    this.isOutlined = false,
    this.width = double.infinity,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double width;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading || onPressed == null ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: backgroundColor ?? AppTheme.primaryColor,
                  width: 2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: textColor ?? AppTheme.primaryColor,
              ),
              child: _buildChild(),
            )
          : ElevatedButton(
              onPressed: isLoading || onPressed == null ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppTheme.primaryColor,
                foregroundColor: textColor ?? Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _buildChild(),
            ),
    );
  }

  Widget _buildChild() {
    return isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              text,
              style: AppTheme.lightMaterialTheme.textTheme.labelLarge?.copyWith(
                color: isOutlined
                    ? (textColor ?? AppTheme.primaryColor)
                    : (textColor ?? Colors.white),
              ),
            ),
          );
  }
}
