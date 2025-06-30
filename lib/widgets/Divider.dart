import 'package:flutter/material.dart';

class Div extends StatelessWidget {
  final String text;
  final Color? dividerColor;
  final Color? textColor;
  final double? thickness;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? indent;
  final double? endIndent;
  final double? height;
  final TextStyle? textStyle;
  final MainAxisAlignment? alignment;

  const Div({
    super.key,
    required this.text,
    this.dividerColor,
    this.textColor,
    this.thickness,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.indent,
    this.endIndent,
    this.height,
    this.textStyle,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.dividerColor;
    final defaultTextColor = theme.textTheme.bodyMedium?.color ?? Colors.grey[600];

    final effectiveTextStyle = textStyle ?? TextStyle(
      color: textColor ?? defaultTextColor,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w500,
    );

    final effectivePadding = padding ?? const EdgeInsets.symmetric(horizontal: 16);
    final effectiveThickness = thickness ?? 1.0;
    final effectiveColor = dividerColor ?? defaultColor;

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              color: effectiveColor,
              thickness: effectiveThickness,
              indent: indent,
              endIndent: 0,
            ),
          ),
          Padding(
            padding: effectivePadding,
            child: Text(
              text,
              style: effectiveTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Divider(
              color: effectiveColor,
              thickness: effectiveThickness,
              indent: 0,
              endIndent: endIndent,
            ),
          ),
        ],
      ),
    );
  }
}