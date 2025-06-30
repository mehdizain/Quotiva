import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;
  final VoidCallback? onAppleTap;
  final bool showApple;
  final bool isLoading;
  final String? loadingProvider;

  const SocialButtons({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
    this.onAppleTap,
    this.showApple = false,
    this.isLoading = false,
    this.loadingProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (showApple && onAppleTap != null) {
      return Column(
        children: [
          _buildSocialButton(
            onTap: onAppleTap!,
            icon: Icons.apple,
            label: "Continue with Apple",
            backgroundColor: Colors.black,
            textColor: Colors.white,
            iconColor: Colors.white,
            isFullWidth: true,
            isLoading: isLoading && loadingProvider == 'apple',
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  onTap: onGoogleTap,
                  icon: Icons.g_mobiledata,
                  label: "Google",
                  backgroundColor: Colors.white,
                  textColor: Colors.grey[700]!,
                  iconColor: Colors.white,
                  iconBackground: Colors.red[400]!,
                  isLoading: isLoading && loadingProvider == 'google',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSocialButton(
                  onTap: onFacebookTap,
                  icon: Icons.facebook,
                  label: "Facebook",
                  backgroundColor: Colors.white,
                  textColor: Colors.grey[700]!,
                  iconColor: Colors.white,
                  iconBackground: Colors.blue[600]!,
                  isLoading: isLoading && loadingProvider == 'facebook',
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            onTap: onGoogleTap,
            icon: Icons.g_mobiledata,
            label: "Google",
            backgroundColor: Colors.white,
            textColor: Colors.grey[700]!,
            iconColor: Colors.white,
            iconBackground: Colors.red[400]!,
            isLoading: isLoading && loadingProvider == 'google',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            onTap: onFacebookTap,
            icon: Icons.facebook,
            label: "Facebook",
            backgroundColor: Colors.white,
            textColor: Colors.grey[700]!,
            iconColor: Colors.white,
            iconBackground: Colors.blue[600]!,
            isLoading: isLoading && loadingProvider == 'facebook',
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    Color? iconBackground,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.grey.withOpacity(0.1),
          highlightColor: Colors.grey.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ] else ...[
                  if (iconBackground != null)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconBackground,
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 16,
                      ),
                    )
                  else
                    Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                ],
                if (!isFullWidth || !isLoading) ...[
                  SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      isLoading ? "Connecting..." : label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Alternative single button widget for more flexibility
class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color? iconBackground;
  final bool isLoading;
  final double? width;
  final double height;

  const SocialButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF374151),
    this.iconColor = Colors.white,
    this.iconBackground,
    this.isLoading = false,
    this.width,
    this.height = 56,
  });

  // Predefined factory constructors for common social platforms
  factory SocialButton.google({
    required VoidCallback onTap,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) {
    return SocialButton(
      onTap: onTap,
      icon: Icons.g_mobiledata,
      label: "Continue with Google",
      backgroundColor: Colors.white,
      textColor: Color(0xFF374151),
      iconColor: Colors.white,
      iconBackground: Color(0xFFEA4335),
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }

  factory SocialButton.facebook({
    required VoidCallback onTap,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) {
    return SocialButton(
      onTap: onTap,
      icon: Icons.facebook,
      label: "Continue with Facebook",
      backgroundColor: Colors.white,
      textColor: Color(0xFF374151),
      iconColor: Colors.white,
      iconBackground: Color(0xFF1877F2),
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }

  factory SocialButton.apple({
    required VoidCallback onTap,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) {
    return SocialButton(
      onTap: onTap,
      icon: Icons.apple,
      label: "Continue with Apple",
      backgroundColor: Colors.black,
      textColor: Colors.white,
      iconColor: Colors.white,
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }

  factory SocialButton.twitter({
    required VoidCallback onTap,
    bool isLoading = false,
    double? width,
    double height = 56,
  }) {
    return SocialButton(
      onTap: onTap,
      icon: Icons.close, // You might want to use a custom Twitter icon
      label: "Continue with Twitter",
      backgroundColor: Colors.white,
      textColor: Color(0xFF374151),
      iconColor: Colors.white,
      iconBackground: Color(0xFF1DA1F2),
      isLoading: isLoading,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
        border: Border.all(
          color: backgroundColor == Colors.white
              ? Colors.grey[300]!
              : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: (backgroundColor == Colors.white
              ? Colors.grey
              : Colors.white).withOpacity(0.1),
          highlightColor: (backgroundColor == Colors.white
              ? Colors.grey
              : Colors.white).withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ] else ...[
                  if (iconBackground != null)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconBackground,
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 16,
                      ),
                    )
                  else
                    Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                ],
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    isLoading ? "Connecting..." : label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}