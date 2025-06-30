import 'package:flutter/material.dart';

class Modernbutton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final double? elevation;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? alignment;
  final double? iconSize;
  final double? spacing;
  final bool isLoading;
  final Widget? loadingWidget;
  final Duration? animationDuration;
  final TextStyle? textStyle;
  final BoxShadow? customShadow;
  final BorderSide? borderSide;

  const Modernbutton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.width,
    this.height,
    this.borderRadius,
    this.gradientColors,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.elevation,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.alignment,
    this.iconSize,
    this.spacing,
    this.isLoading = false,
    this.loadingWidget,
    this.animationDuration,
    this.textStyle,
    this.customShadow,
    this.borderSide,
  });

  @override
  State<Modernbutton> createState() => _ModernbuttonState();
}

class _ModernbuttonState extends State<Modernbutton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetAnimation();
  }

  void _handleTapCancel() {
    _resetAnimation();
  }

  void _resetAnimation() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine effective colors
    final effectiveGradientColors = widget.gradientColors ??
        (widget.isPrimary ? [Colors.indigo[700]!, Colors.indigo[900]!] : null);

    final effectiveBackgroundColor = widget.backgroundColor ??
        (widget.isPrimary ? null : colorScheme.surface);

    final effectiveForegroundColor = widget.foregroundColor ??
        (widget.isPrimary ? colorScheme.onPrimary : colorScheme.primary);

    final effectiveShadowColor = widget.shadowColor ??
        (widget.isPrimary ? colorScheme.primary.withOpacity(0.3) : Colors.transparent);

    final effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    final effectiveTextStyle = widget.textStyle ?? TextStyle(
      fontSize: widget.fontSize ?? 16,
      fontWeight: widget.fontWeight ?? FontWeight.w600,
      letterSpacing: 0.5,
      color: effectiveForegroundColor,
    );

    final effectiveBorderSide = widget.borderSide ??
        (widget.isPrimary ? BorderSide.none : BorderSide(color: colorScheme.outline.withOpacity(0.2)));

    final isDisabled = widget.onPressed == null;
    final showLoading = widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedOpacity(
            opacity: isDisabled ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.width ?? double.infinity,
                height: widget.height ?? 56,
                decoration: BoxDecoration(
                  borderRadius: effectiveBorderRadius,
                  gradient: widget.isPrimary && effectiveGradientColors != null
                      ? LinearGradient(
                    colors: effectiveGradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: effectiveBackgroundColor,
                  boxShadow: widget.isPrimary && !isDisabled
                      ? [
                    widget.customShadow ?? BoxShadow(
                      color: effectiveShadowColor,
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 3 : 6),
                    ),
                  ]
                      : null,
                  border: !widget.isPrimary ? Border.fromBorderSide(effectiveBorderSide) : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: showLoading ? null : widget.onPressed,
                    borderRadius: effectiveBorderRadius,
                    splashColor: effectiveForegroundColor.withOpacity(0.1),
                    highlightColor: effectiveForegroundColor.withOpacity(0.05),
                    child: Container(
                      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: widget.alignment ?? MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showLoading) ...[
                            widget.loadingWidget ?? SizedBox(
                              width: widget.iconSize ?? 20,
                              height: widget.iconSize ?? 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  effectiveForegroundColor,
                                ),
                              ),
                            ),
                            SizedBox(width: widget.spacing ?? 8),
                          ] else if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              size: widget.iconSize ?? 20,
                              color: effectiveForegroundColor,
                            ),
                            SizedBox(width: widget.spacing ?? 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: effectiveTextStyle,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}