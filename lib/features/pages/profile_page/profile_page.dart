import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/data/user_response.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/profile_view_page.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/update_profile.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/update_user.dart';
import '../../data/profile/user_profile.dart';
import '../../service/service.dart';

class ProfilePage extends StatefulWidget {
  final UserResponse? userProfile;
  final Function(String) onNavigate;

  const ProfilePage({
    super.key,
    required this.userProfile,
    required this.onNavigate,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserResponse? userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = widget.userProfile;
  }

  // Refresh user profile from backend
  Future<void> _refreshProfile() async {
    try {
      final updatedProfile = await Service().getUserById();
      setState(() {
        userProfile = updatedProfile;
      });
    } catch (e) {
      print("Error fetching updated profile: $e");
    }
  }

  // Intercept back press
  Future<bool> _onBackPressed() async {
    await _refreshProfile();
    Navigator.pop(context, userProfile);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
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
                          onPressed: _onBackPressed,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Manage your learning journey and preferences",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
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
                                "• ${userProfile!.grade}",
                            ].join(" "),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// --- Options ---
                    _buildOptionCard(
                      context,
                      title: "View Full Profile",
                      description:
                          "Detailed overview of your academic profile and progress",
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
                      description:
                          "Edit subjects, interests, and personal preferences",
                      emoji: "✏️",
                      color: Colors.black54,
                      onTap: () async {
                        final updatedProfile =
                            await Navigator.push<UserResponse>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileUpdatePage(
                                  user: userProfile!,
                                  onBack: () {},
                                ),
                              ),
                            );

                        if (updatedProfile != null) {
                          setState(() {
                            userProfile = updatedProfile;
                          });
                        }
                      },
                    ),

                    _buildOptionCard(
                      context,
                      title: "Update Learner",
                      description: "Edit personal details",
                      emoji: "✏️",
                      color: Colors.black54,
                      onTap: () async {
                        final updatedProfile =
                            await Navigator.push<UserResponse>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateUserPage(
                                  user: userProfile!,
                                  onBack: () {},
                                  userId:'' ,
                                  name:userProfile!.name,
                                  surname: userProfile!.surname,
                                  email: userProfile!.email,
                                  phone: userProfile!.phoneNumber,
                                ),
                              ),
                            );

                        if (updatedProfile != null) {
                          setState(() {
                            userProfile = updatedProfile;
                          });
                        }
                      },
                    ),
                  ],
                ),
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
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
