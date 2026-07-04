import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.blur = 10.0,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(24.0);
    
    return margin != null
        ? Padding(
            padding: margin!,
            child: _buildGlassEffect(br),
          )
        : _buildGlassEffect(br);
  }

  Widget _buildGlassEffect(BorderRadiusGeometry br) {
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppTheme.deepTeal.withValues(alpha: 0.15),
            borderRadius: br,
            border: Border.all(
              color: AppTheme.mintGlow.withValues(alpha: 0.2),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.pureWhite.withValues(alpha: 0.05),
                AppTheme.deepTeal.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}