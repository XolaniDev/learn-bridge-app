import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../service/service.dart';
import '../profile_page/profile_setup_page.dart';
import '../welcome_page/welcome_page.dart';

// ---------------- Login Page ----------------
class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthComplete;
  const AuthScreen({super.key, required this.onAuthComplete});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  final TextEditingController _signupPasswordController = TextEditingController();
  final TextEditingController _signupConfirmPasswordController = TextEditingController();

  bool _loginObscure = true;
  final bool _signupConfirmObscure = true;

  Future<void> _handleSignup() async {
    if (_signupFormKey.currentState!.validate()) {
      final name = _signupNameController.text.trim();
      final surname = _signupSurnameController.text.trim();
      final email = _signupEmailController.text.trim();
      final phone = _signupPhoneController.text.trim();
      final password = _signupPasswordController.text.trim();

      // Call the backend service
      final response = await Service().signup(
        name: name,
        surname: surname,
        email: email,
        phoneNumber: phone,
        password: password,
      );


      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Signup successful!")),
        );

        _signupNameController.clear();
        _signupSurnameController.clear();
        _signupEmailController.clear();
        _signupPhoneController.clear();
        _signupPasswordController.clear();
        _signupConfirmPasswordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Signup failed")),
        );
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _handleLogin() {
    if (_loginFormKey.currentState!.validate()) {
      // Navigate to ProfileSetupPage after login
      // After successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSetupPage(
            onComplete: (UserProfile profile) {
              // After profile setup, navigate to HomePage (or any screen)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WelcomePage(onContinue: () {  },), // replace with your home screen
                ),
              );
              // Optional: show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile setup completed!')),
              );
            },
          ),
        ),
      );
      ;
    }
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
              // Wrap TabBar in a Container
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.transparent, // remove default indicator
                  ),
                  labelColor: Colors.black, // text color for selected
                  unselectedLabelColor: Colors.black, // text color for unselected
                  tabs: List.generate(2, (index) {
                    bool isSelected = _tabController.index == index;
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey[300] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Tab(
                        text: index == 0 ? "Sign In" : "Sign Up",
                      ),
                    );
                  }),
                  onTap: (index) {
                    setState(() {}); // refresh to swap colors
                  },
                ),
              ),



              const SizedBox(height: 16),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ------------------ Login Form ------------------
                    SingleChildScrollView(
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),
                            // Email
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
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter email' : null,
                            ),
                            const SizedBox(height: 16),

                            // Password
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
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter password' : null,
                            ),
                            const SizedBox(height: 24),

                            // Sign In button
                            ElevatedButton(
                              onPressed: _handleLogin,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 16)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'By continuing, you agree to our Terms of Service and Privacy Policy',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ------------------ Signup Form ------------------
                    SingleChildScrollView(
                      child: Form(
                        key: _signupFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 8),

                            // Name
                            TextFormField(
                              controller: _signupNameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 16),

                            // Surname
                            TextFormField(
                              controller: _signupSurnameController,
                              decoration: const InputDecoration(
                                labelText: 'Surname',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter your surname' : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: _signupEmailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter email' : null,
                            ),
                            const SizedBox(height: 16),

                            // Phone
                            TextFormField(
                              controller: _signupPhoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter phone' : null,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _signupPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please enter password' : null,
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password
                            TextFormField(
                              controller: _signupConfirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                              ),
                              validator: (value) => value != _signupPasswordController.text
                                  ? 'Passwords do not match'
                                  : null,
                            ),
                            const SizedBox(height: 24),

                            // Sign Up button
                            ElevatedButton(
                              onPressed: _handleSignup,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 16)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                    )
                    ,
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