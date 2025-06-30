import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final Widget child;

  const AuthHeader({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[700]!, Colors.indigo[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildLogo(),
          SizedBox(height: 16),
          _buildTitle(),
          SizedBox(height: 8),
          SizedBox(height: 32),
          child,
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.security,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Welcome",
      style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
  //
  // Widget _buildSubtitle() {
  //   return Text(
  //     "Please sign in or create an account",
  //     style: TextStyle(
  //       color: Colors.white.withOpacity(0.8),
  //       fontSize: 14,
  //       fontWeight: FontWeight.w400,
  //     ),
  //   );
  // }
}
