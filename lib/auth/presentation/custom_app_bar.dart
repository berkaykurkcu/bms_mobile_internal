import 'dart:ui' as ui;

import 'package:bms_mobile/core/presentation/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.leading,
    this.leadingWidth,
    this.onBackPressed,
    this.onClosePressed,
    this.isTransparent = true,
    this.blurIntensity = 25.0,
    this.bottom,
    super.key,
  });
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final double? leadingWidth;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;
  final bool isTransparent;
  final double blurIntensity;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        title,
        style: AppTheme.lightMaterialTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.darkTextColor,
        ),
      ),
      leading: _buildLeading(context),
      leadingWidth: leadingWidth,
      actions: actions?.map(_buildActionWrapper).toList(),
      backgroundColor: isTransparent
          ? Colors.white.withValues(alpha: 0.85)
          : Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      centerTitle: true,
      bottom: bottom,
    );

    if (!isTransparent) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: appBar,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: blurIntensity,
            sigmaY: blurIntensity,
          ),
          child: appBar,
        ),
      ),
    );
  }

  Widget _buildActionWrapper(Widget action) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: action,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (showBackButton) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
        ),
        style: IconButton.styleFrom(
          foregroundColor: AppTheme.darkTextColor,
          padding: const EdgeInsets.all(12),
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}
