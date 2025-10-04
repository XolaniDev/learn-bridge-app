import 'package:flutter/material.dart';

import '../login/login_page.dart';

import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomePage({super.key, required this.onContinue, required Null Function() onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2FF), Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo/Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '🎓',
                style: TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(height: 16),

            // App Name
            Column(
              children: [
                const Text(
                  "LearnBridge",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '✨',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "Discover your future career with AI guidance",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Features
            Column(
              children: [
                featureCard(
                  icon: '🎓',
                  iconBgColor: Colors.green,
                  title: "Personalized Career Paths",
                  subtitle: "Based on your subjects and interests",
                ),
                const SizedBox(height: 12),
                featureCard(
                  icon: '✨',
                  iconBgColor: Colors.blue,
                  title: "Funding Opportunities",
                  subtitle: "Find bursaries and scholarships",
                ),
                const SizedBox(height: 12),
                featureCard(
                  icon: '📈',
                  iconBgColor: Colors.purple,
                  title: "Job Market Insights",
                  subtitle: "Stay updated with industry trends",
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Inside WelcomePage widget
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to LoginPage when Get Started is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen(onAuthComplete: () {  }, onNavigate: (screen) {  },)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Designed for South African high school learners",
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Feature Card Widget
  Widget featureCard({
    required String icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
