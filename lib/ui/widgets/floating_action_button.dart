import 'package:flutter/material.dart';
import 'package:shift_schedule/ui/themes/theme.dart';


class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.tooltip,
    this.visible = true,
    this.heroTag,
    this.icon

  });

  final bool visible;
  final VoidCallback onPressed;
  final String? tooltip;
  final IconData? icon;
  final Object? heroTag;



  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: FloatingActionButton(
          heroTag: heroTag,
          onPressed: onPressed,
          tooltip: tooltip,
          backgroundColor: CHRONOSTheme.primary,
          child: Icon(
              icon,
              color: CHRONOSTheme.onPrimary
          ),
        ),
    );
  }
}