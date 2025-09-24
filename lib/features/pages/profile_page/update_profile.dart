import 'dart:developer';
import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../utils/profile_setup_data.dart';
import '../../widgets/profile_widgets/financial_background_tiles.dart';
import '../../service/service.dart';

class ProfileUpdatePage extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onBack;

  const ProfileUpdatePage({
    super.key,
    required this.userProfile,
    required this.onBack,
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  late UserProfile profile;
  bool isLoading = false;

  final List<String> subjects = [
    "Mathematics", "Physical Sciences", "Life Sciences", "English (Home Language)",
    "Afrikaans", "History", "Geography", "Accounting", "Business Studies",
    "Economics", "Life Orientation", "Computer Applications Technology",
    "Information Technology", "Visual Arts", "Dramatic Arts", "Music",
    "Consumer Studies", "Tourism", "Hospitality Studies"
  ];

  final List<String> interests = [
    "Technology", "Mathematics", "Sciences", "Arts & Design", "Business & Finance",
    "Health & Medicine", "Engineering", "Law & Justice", "Education & Training",
    "Media & Communication", "Sports & Fitness", "Environment & Nature", "Social Services",
    "Languages & Literature"
  ];

  @override
  void initState() {
    super.initState();
    profile = UserProfile(
      id: widget.userProfile.id,
      grade: widget.userProfile.grade,
      province: widget.userProfile.province,
      financialBackground: widget.userProfile.financialBackground,
      subjects: List<String>.from(widget.userProfile.subjects),
      interests: List<String>.from(widget.userProfile.interests),
    );
  }

  Future<void> handleUpdate() async {
    setState(() => isLoading = true);

    try {
      final response = await Service().updateProfile(
        grade: profile.grade ?? "",
        province: profile.province ?? "",
        interests: profile.interests,
        subjects: profile.subjects,
        financialBackground: profile.financialBackground?.displayName ?? "",
      );

      setState(() => isLoading = false);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        widget.onBack();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grade
              const Text("Grade", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: profile.grade,
                hint: const Text("Select your grade"),
                isExpanded: true,
                onChanged: (value) => setState(() => profile.grade = value),
                items: ["Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11"]
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Subjects
              const Text("You want to update your Subjects?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subjects.map((subject) {
                  final selected = profile.subjects.contains(subject);
                  return ChoiceChip(
                    label: Text(subject),
                    selected: selected,
                    onSelected: (sel) {
                      setState(() {
                        if (sel) {
                          profile.subjects.add(subject);
                        } else {
                          profile.subjects.remove(subject);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Interests
              const Text("Please select your new Interests", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) {
                  final selected = profile.interests.contains(interest);
                  return ChoiceChip(
                    label: Text(interest),
                    selected: selected,
                    onSelected: (sel) {
                      setState(() {
                        if (sel) {
                          profile.interests.add(interest);
                        } else {
                          profile.interests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Financial Background
              const Text("Tell us your current finance state", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              FinancialStep(
                selectedBackground: profile.financialBackground,
                onSelect: (fb) => setState(() => profile.financialBackground = fb),
              ),
              const SizedBox(height: 16),

              // Province
              const Text("Province", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: profile.province,
                hint: const Text("Select your province"),
                isExpanded: true,
                onChanged: (value) => setState(() => profile.province = value),
                items: provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              ),
              const SizedBox(height: 32),

              // Update button
              ElevatedButton(
                onPressed: isLoading ? null : handleUpdate,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
