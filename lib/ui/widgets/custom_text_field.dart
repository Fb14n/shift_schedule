import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shift_schedule/ui/themes/theme.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.color = CHRONOSTheme.secondary,
    this.controller,
    this.labelText,
    this.borderWidth = 2,
    this.validatorText,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon
  });

  final Color color;
  final TextEditingController? controller;
  final String? labelText;
  final double borderWidth;
  final String? validatorText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unfocusedColor = CHRONOSTheme.of(context).onBackgroundLight;
    final labelColor = _isFocused ? widget.color : unfocusedColor;
    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      cursorColor: widget.color,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        labelStyle: TextStyle(color: labelColor),
        floatingLabelStyle: TextStyle(color: labelColor),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color, width: widget.borderWidth)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: unfocusedColor),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? widget.validatorText : null,
    );
  }
}