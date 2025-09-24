import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/profile_view_page.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/update_profile.dart';
import '../../data/profile/user_profile.dart';


class ProfilePage extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback onLogout;
  final Function(String) onNavigate;

  const ProfilePage({
    super.key,
    required this.userProfile,
    required this.onNavigate,
    required this.onLogout, required Null Function() onUpdateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // slate-50
              Color(0xFFEFF6FF), // blue-50/30
              Color(0xFFEEF2FF), // indigo-50/20
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// --- Header ---
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Profile",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [Colors.black87, Colors.blueGrey],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 70),
                                ),
                            ),
                          ),
                          const Text(
                            "Manage your learning journey and preferences",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// --- Profile Card ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text("👤", style: TextStyle(fontSize: 40)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Learner Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          [
                            if (userProfile?.province != null)
                              "📍 ${userProfile!.province}",
                            if (userProfile?.grade != null)
                              "• Grade ${userProfile!.grade}",
                          ].join(" "),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                              5,
                                  (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.green, Colors.blue],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Profile Complete",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// --- Options ---
                  _buildOptionCard(
                    context,
                    title: "View Full Profile",
                    description: "Detailed overview of your academic profile and progress",
                    emoji: "📋",
                    color: Colors.black54,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProfilePage(
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                  ),

                  _buildOptionCard(
                    context,
                    title: "Update Profile",
                    description: "Edit subjects, interests, and personal preferences",
                    emoji: "✏️",
                    color: Colors.black54,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileUpdatePage(
                            userProfile: userProfile!, // <-- pass the current profile
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                  ),

                  _buildOptionCard(
                    context,
                    title: "Update Learner",
                    description:
                    "Edit personal details",
                    emoji: "✏️",
                    color: Colors.black54,
                    onTap: () => onNavigate("profile-setup"),
                  ),
                  _buildOptionCard(
                    context,
                    title: "Logout",
                    description: "Sign out of your account securely",
                    emoji: "🚪",
                    color: Colors.black54,
                    onTap: onLogout,
                  ),

                  const SizedBox(height: 20),

                  /// --- Quick Stats ---
                  if (userProfile != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade100.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "📊 Quick Overview",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  count: userProfile!.subjects.length,
                                  label: "Subjects Selected",
                                  color: Colors.blue,
                                  progress:
                                  (userProfile!.subjects.length / 10).clamp(0, 1),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  count: userProfile!.interests.length,
                                  label: "Career Interests",
                                  color: Colors.green,
                                  progress:
                                  (userProfile!.interests.length / 8).clamp(0, 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required String description,
        required String emoji,
        Color color = Colors.blue,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.7), color],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: color)),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
