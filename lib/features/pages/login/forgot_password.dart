import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../service/service.dart';  // ✅ import your Service
import 'notification_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _learnerNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _learnerNoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final learnerNo = _learnerNoController.text.trim();
      final email = _emailController.text.trim();

      setState(() => _loading = true);

      final success = await Service().forgotPassword(learnerNo, email);

      setState(() => _loading = false);

      if (success) {
        Fluttertoast.showToast(msg: "Temporary password sent to $email");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(email: email),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "Failed to reset password. Try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Enter your learner number and registered email address. "
                    "We'll send you a temporary password to reset your account.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // 🔹 Learner Number Field
              TextFormField(
                controller: _learnerNoController,
                decoration: const InputDecoration(
                  labelText: 'Learner Number',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your learner number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 🔹 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF0F0F0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex =
                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _loading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
