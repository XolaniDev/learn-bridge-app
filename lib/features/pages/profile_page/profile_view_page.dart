import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../service/service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';

class ViewProfilePage extends StatefulWidget {
  final VoidCallback onBack;

  const ViewProfilePage({super.key, required this.onBack});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  UserProfile? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  /// Fetch user profile from backend
  Future<void> _fetchUserProfile() async {
    try {
      final userId = await SessionManager().get("userId");
      final url = Uri.parse("http://154.0.166.216:8091/api/lb/find-user-by-id/$userId");

      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          userProfile = UserProfile.fromJson(data);
          isLoading = false;
        });
      } else {
        print("Failed to fetch profile: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Failed to load profile"),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: widget.onBack,
                child: const Text("Go Back"),
              )
            ],
          ),
        ),
      );
    }

    // --- Calculate profile completion ---
    final totalFields = 5;
    final completedFields = [
      userProfile!.grade,
      userProfile!.province,
      userProfile!.financialBackground,
      userProfile!.subjects.isNotEmpty,
      userProfile!.interests.isNotEmpty
    ].where((e) => e != null && e != false).length;

    final completionPercentage = ((completedFields / totalFields) * 100).round();

    // --- UI code here ---
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            _buildProfileCard(completionPercentage),
            const SizedBox(height: 20),
            // Academic Info
            _buildInfoCard("👤", "Current Grade", userProfile!.grade ?? "-", Colors.blue),
            _buildInfoCard("📍", "Province", userProfile!.province ?? "-", Colors.green),
            _buildInfoCard("💰", "Financial Background",
                "${userProfile!.financialBackground ?? '-'} Income", Colors.purple),
            const SizedBox(height: 20),
            // Subjects
            _buildListCard("My Subjects", userProfile!.subjects, Colors.blue),
            const SizedBox(height: 20),
            // Interests
            _buildListCard("Career Interests", userProfile!.interests, Colors.green),
            const SizedBox(height: 20),
            // Profile Strength
            _buildStrengthCard(
              userProfile!.subjects.length,
              userProfile!.interests.length,
              completionPercentage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(int completionPercentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                ),
                child: const Center(child: Text("👤", style: TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${userProfile!.grade ?? '-'} Learner",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("📍 ${userProfile!.province ?? '-'}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completionPercentage / 100,
            backgroundColor: Colors.grey.shade200,
            color: Colors.blue,
            minHeight: 10,
          ),
          const SizedBox(height: 8),
          Text(
            completionPercentage == 100
                ? "🎉 Excellent! Your profile is complete."
                : "Keep building your profile for better career matches.",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String icon, String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [CircleAvatar(backgroundColor: color, child: Text(icon)), const SizedBox(width: 8), Text(title)]),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildListCard(String title, List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...items.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.2))),
            child: Text(item),
          )),
        ],
      ),
    );
  }

  Widget _buildStrengthCard(int subjectsCount, int interestsCount, int completionPercentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profile Strength", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text("Subjects: $subjectsCount"),
          Text("Interests: $interestsCount"),
          Text("Completion: $completionPercentage%"),
        ],
      ),
    );
  }
}
