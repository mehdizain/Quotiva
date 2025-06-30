import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signin_tab.dart';
import 'signup_tab.dart';
import '../widgets/tab_selector.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupNameController = TextEditingController();

  final _signinEmailController = TextEditingController();
  final _signinPasswordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscureSignup = true;
  bool _obscureSignin = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupNameController.dispose();
    _signinEmailController.dispose();
    _signinPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo[900],
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo[800]!, Colors.indigo[900]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TabSelector(
                    controller: _tabController,
                    labels: const ['Sign Up', 'Sign In'],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SignUpTab(
                      nameController: _signupNameController,
                      emailController: _signupEmailController,
                      passwordController: _signupPasswordController,
                      obscureText: _obscureSignup,
                      toggleObscure: () =>
                          setState(() => _obscureSignup = !_obscureSignup),
                      onAccountCreated: () {
                        _signinEmailController.text =
                            _signupEmailController.text;
                        _tabController.animateTo(1);
                      },
                    ),
                    SignInTab(
                      emailController: _signinEmailController,
                      passwordController: _signinPasswordController,
                      obscureText: _obscureSignin,
                      toggleObscure: () =>
                          setState(() => _obscureSignin = !_obscureSignin),
                      rememberMe: _rememberMe,
                      onRememberMeChanged: (val) =>
                          setState(() => _rememberMe = val!),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
