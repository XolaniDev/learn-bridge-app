import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/profile/user_profile.dart';
import '../../service/service.dart';
import '../dashboard/dashboard_page.dart' as dashboard_page;
import '../profile_page/profile_setup_page.dart';
import '../welcome_page/welcome_page.dart';
import 'forgot_password.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthComplete;

  const AuthScreen({super.key, required this.onAuthComplete});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Toast Helper
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

  // Login form
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Signup form
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupSurnameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();
  final TextEditingController _signupPasswordController =
  TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
  TextEditingController();

  bool _loginObscure = true;
  final bool _signupConfirmObscure = true;

  // ---------------- Handle Signup ----------------
  Future<void> _handleSignup() async {
    if (_signupFormKey.currentState!.validate()) {
      final name = _signupNameController.text.trim();
      final surname = _signupSurnameController.text.trim();
      final email = _signupEmailController.text.trim();
      final phone = _signupPhoneController.text.trim();
      final password = _signupPasswordController.text.trim();

      final response = await Service().signup(
        name: name,
        surname: surname,
        email: email,
        phoneNumber: phone,
        password: password,
      );

      if (response.success) {
        showToast(response.message ?? "Signup successful!");

        _signupNameController.clear();
        _signupSurnameController.clear();
        _signupEmailController.clear();
        _signupPhoneController.clear();
        _signupPasswordController.clear();
        _signupConfirmPasswordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileSetupPage(
                  onComplete: (UserProfile profile) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomePage(onContinue: () {}),
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

  // ---------------- Handle Login ----------------
  Future<void> _handleLogin() async {
    if (_loginFormKey.currentState!.validate()) {
      final username = _loginEmailController.text.trim();
      final password = _loginPasswordController.text.trim();

      try {
        final profile = await Service().login(username, password);
        showToast("Welcome back ${profile.name}!");

        final fetchedUser = await Service().getUserById();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                dashboard_page.DashboardScreen(
                  userProfile: fetchedUser,
                  onNavigate: (screen) {},
                ),
          ),
        );
      } catch (e) {
        showToast("Invalid username or password", isError: true);
      }
    }
  }

  @override
  void dispose() {
    _signupNameController.dispose();
    _signupSurnameController.dispose();
    _signupEmailController.dispose();
    _signupPhoneController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // ---------------- Validators ----------------
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _signupPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Header
              Column(
                children: const [
                  Text(
                    'Welcome to LearnBridge',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sign in to explore your career journey',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tabs
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(color: Colors.transparent),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  tabs: List.generate(2, (index) {
                    bool isSelected = _tabController.index == index;
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[300] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Tab(text: index == 0 ? "Sign In" : "Sign Up"),
                    );
                  }),
                  onTap: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 16),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ------------------ Login Form ------------------
                // ------------------ Login Form ------------------
                SingleChildScrollView(
                child: Form(
                key: _loginFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _loginEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF0F0F0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _loginPasswordController,
                        obscureText: _loginObscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF0F0F0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _loginObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() => _loginObscure = !_loginObscure);
                            },
                          ),
                        ),
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Enter password' : null,
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

                      // 👇 Forgot Password link added here
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),

                    // ------------------ Signup Form ------------------
                    SingleChildScrollView(
                      child: Form(
                        key: _signupFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _signupNameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (v) =>
                              v == null || v.isEmpty
                                  ? 'Please enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _signupSurnameController,
                              decoration: const InputDecoration(
                                labelText: 'Surname',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (v) =>
                              v == null || v.isEmpty
                                  ? 'Please enter your surname'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _signupEmailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _signupPhoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (v) =>
                              v == null || v.isEmpty
                                  ? 'Please enter your phone'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _signupPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _signupConfirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                              onPressed: _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
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
      ),
    );
  }
}
