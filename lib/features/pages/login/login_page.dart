import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_bridge_v2/features/pages/login/reset_password.dart';
import '../../data/profile/user_profile.dart';
import '../../data/user_response.dart';
import '../../service/service.dart';
import '../dashboard/dashboard_page.dart' as dashboard_page;
import '../profile_page/profile_setup_page.dart';
import '../welcome_page/welcome_page.dart';
import 'forgot_password.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthComplete;
  const AuthScreen({
    super.key,
    required this.onAuthComplete,
    required Null Function(dynamic screen) onNavigate,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupNameController = TextEditingController();
  final _signupSurnameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPhoneController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  bool _loginObscure = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    try {
      final user = await Service().login(
        _loginEmailController.text.trim(),
        _loginPasswordController.text.trim(),
      );

      final userJson = await SessionManager().get("userData");
      if (userJson == null) {
        showToast("Session error. Try again.", isError: true);
        return;
      }

      if (user.changePassword) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResetPasswordPage()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => dashboard_page.DashboardScreen(
              userProfile: user,
              onNavigate: (screen) {},
            ),
          ),
        );
      }

      showToast("Welcome back ${user.name}!");
    } catch (e) {
      showToast("Invalid email or password", isError: true);
    }
  }

  Future<void> _handleSignup() async {
    if (_signupFormKey.currentState!.validate()) {
      final response = await Service().signup(
        name: _signupNameController.text.trim(),
        surname: _signupSurnameController.text.trim(),
        email: _signupEmailController.text.trim(),
        phoneNumber: _signupPhoneController.text.trim(),
        password: _signupPasswordController.text.trim(),
      );

      if (response.success) {
        showToast(response.message ?? "Signup successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileSetupPage(
              onComplete: (UserProfile profile) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(onContinue: () {}, onBack: () {}),
                  ),
                );
                showToast("Profile setup completed!");
              },
            ),
          ),
        );
      } else {
        showToast(response.message ?? "Signup failed", isError: true);
      }
    }
  }

  // ✅ VALIDATIONS
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include an uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include a number';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _signupPasswordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full, legal name.';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2 || trimmed.length > 50) {
      return 'Name must be between 2 and 50 characters.';
    }

    // ✅ Allowed: letters, spaces, hyphens, apostrophes
    final nameRegex = RegExp(r"^[A-Za-z\s'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return "Name can only contain letters, spaces, hyphens (-), or apostrophes (').";
    }

    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full, legal surname.';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2 || trimmed.length > 50) {
      return 'Surname must be between 2 and 50 characters.';
    }

    final surnameRegex = RegExp(r"^[A-Za-z\s'-]+$");
    if (!surnameRegex.hasMatch(trimmed)) {
      return "Surname can only contain letters, spaces, hyphens (-), or apostrophes (').";
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number.';
    }

    // Remove spaces and hyphens for validation
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    //  Local format: must start with 0 and be 10 digits long
    final localRegex = RegExp(r'^0\d{9}$');

    // International format: +27 followed by 9 digits
    final internationalRegex = RegExp(r'^\+27\d{9}$');

    if (!localRegex.hasMatch(cleaned) && !internationalRegex.hasMatch(cleaned)) {
      return 'Enter a valid South African phone number (e.g., 0831234567 or +27831234567).';
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: themeColor,
              child: Column(
                children: const [
                  Icon(Icons.school_rounded, color: Colors.white, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'LearnBridge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Discover your career path',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // 🪄 TabBar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: themeColor,
                unselectedLabelColor: Colors.black54,
                indicatorColor: themeColor,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'Sign In'),
                  Tab(text: 'Sign Up'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAuthCard(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          _buildField(
                            controller: _loginEmailController,
                            label: "Email",
                            icon: Icons.mail_outline,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _loginPasswordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            obscureText: _loginObscure,
                            validator: _validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(_loginObscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _loginObscure = !_loginObscure),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildButton("Sign In", _handleLogin),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // SIGN UP FORM
                  _buildAuthCard(
                    child: Form(
                      key: _signupFormKey,
                      child: Column(
                        children: [
                          _buildField(
                            controller: _signupNameController,
                            label: "Name",
                            icon: Icons.person_outline,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _signupSurnameController,
                            label: "Surname",
                            icon: Icons.person,
                            validator: _validateSurname,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _signupEmailController,
                            label: "Email",
                            icon: Icons.mail_outline,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _signupPhoneController,
                            label: "Phone Number",
                            icon: Icons.phone,
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _signupPasswordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: _signupConfirmPasswordController,
                            label: "Confirm Password",
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: _validateConfirmPassword,
                          ),
                          const SizedBox(height: 24),
                          _buildButton("Sign Up", _handleSignup),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthCard({required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 5,
          shadowColor: Colors.blueAccent.withOpacity(0.4),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
