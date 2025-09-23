import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/profile_view_page.dart';
import '../../data/profile/user_profile.dart';


class ProfilePage extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback onUpdateProfile;

  const ProfilePage({
    super.key,
    required this.userProfile,
    required this.onUpdateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOptionCard(
              context,
              title: "View Full Profile",
              subtitle: "See all your profile details and statistics",
              emoji: "📋",
              color: Colors.blue[100]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewFullProfilePage(
                      userProfile: userProfile!,
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildOptionCard(
              context,
              title: "Update Profile",
              subtitle: "Make changes to your profile information",
              emoji: "✏️",
              color: Colors.green[100]!,
              onTap: onUpdateProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String emoji,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: Text(emoji, style: const TextStyle(fontSize: 22)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
