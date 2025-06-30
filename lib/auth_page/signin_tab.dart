import 'package:flutter/material.dart';
import 'package:myfirst/widgets/ModernButton.dart';
import 'package:myfirst/widgets/Divider.dart';
import 'package:myfirst/widgets/social_buttons.dart';
import 'package:myfirst/styles/input_decorations.dart';
import 'package:myfirst/widgets/loading_overlay.dart';
import '../firebase/auth_service.dart';
import '../home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInTab extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscureText;
  final VoidCallback toggleObscure;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;

  const SignInTab({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscureText,
    required this.toggleObscure,
    required this.rememberMe,
    required this.onRememberMeChanged,
  });

  @override
  State<SignInTab> createState() => _SignInTabState();
}

class _SignInTabState extends State<SignInTab> {
  bool _isLoading = false;

  Future<void> _handleSignIn(BuildContext context) async {
    final auth = AuthService();
    setState(() => _isLoading = true);

    try {
      await auth.signIn(widget.emailController.text.trim(), widget.passwordController.text.trim());

      if (widget.rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', widget.emailController.text.trim());
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signed in successfully!")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign in failed: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            Text("Sign in to continue your journey",
                style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5)),
            const SizedBox(height: 32),
            TextField(
              controller: widget.emailController,
              decoration: inputDecoration("Email Address", Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.passwordController,
              decoration: inputDecoration("Password", Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    widget.obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: widget.toggleObscure,
                ),
              ),
              obscureText: widget.obscureText,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: widget.rememberMe,
                    onChanged: widget.onRememberMeChanged,
                    activeColor: Colors.indigo[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text("Remember me", style: TextStyle(color: Colors.grey[700], fontSize: 15, fontWeight: FontWeight.w500)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[400],
                    textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Modernbutton(
              text: "Sign In",
              onPressed: () => _handleSignIn(context),
            ),
            const SizedBox(height: 24),
            const Div(text: "Or continue with"),
            const SizedBox(height: 24),
            SocialButtons(
              onGoogleTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Google Sign-In tapped")),
                );
              },
              onFacebookTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
