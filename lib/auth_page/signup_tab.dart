import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfirst/widgets/ModernButton.dart';
import 'package:myfirst/widgets/Divider.dart';
import 'package:myfirst/widgets/social_buttons.dart';
import 'package:myfirst/styles/input_decorations.dart';
import 'package:myfirst/widgets/loading_overlay.dart';
import '../firebase/auth_service.dart';

class SignUpTab extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onAccountCreated;
  final bool obscureText;
  final VoidCallback toggleObscure;

  const SignUpTab({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onAccountCreated,
    required this.obscureText,
    required this.toggleObscure,
  });

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  bool _isLoading = false;

  Future<void> _handleSignUp(BuildContext context) async {
    final auth = AuthService();
    setState(() => _isLoading = true);

    try {
      await auth.signUp(widget.emailController.text.trim(), widget.passwordController.text.trim());

      // Get the current user UID
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': widget.nameController.text.trim(),
          'email': widget.emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      widget.onAccountCreated();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
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
            Text("Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            Text("Join us and start your journey",
                style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5)),
            const SizedBox(height: 32),
            TextField(
              controller: widget.nameController,
              decoration: inputDecoration("Full Name", Icons.person_outline),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.emailController,
              decoration: inputDecoration("Email", Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.passwordController,
              obscureText: widget.obscureText,
              decoration: inputDecoration("Password", Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(widget.obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  color: Colors.grey[600],
                  onPressed: widget.toggleObscure,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Modernbutton(
              text: "Create Account",
              onPressed: () => _handleSignUp(context),
            ),
            const SizedBox(height: 24),
            const Div(text: "Or continue with"),
            const SizedBox(height: 24),
            SocialButtons(
              onGoogleTap: () {},
              onFacebookTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
