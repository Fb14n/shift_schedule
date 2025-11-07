import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme.dart';

class AdminBadge extends StatelessWidget {
  final double? height;
  final EdgeInsets? padding;
  final double? fontSize;

  const AdminBadge({super.key, this.height = 22, this.padding, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: CHRONOSTheme.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'ADMIN',
          style: TextStyle(
            color: CHRONOSTheme.error,
            fontSize: fontSize ?? 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}