import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../utils/profile_setup_data.dart';
import '../../widgets/profile_widgets/financial_background_tiles.dart';

import '../dashboard/dashboard_page.dart' as dashboard_page;
import '../../data/profile/user_profile.dart';

class ProfileSetupPage extends StatefulWidget {
  final void Function(UserProfile profile) onComplete;

  const ProfileSetupPage({super.key, required this.onComplete});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final UserProfile profile = UserProfile();
  int currentStep = 1;
  final int totalSteps = 5;

  // Sample subjects and interests
  final List<String> subjects = [
    "Mathematics",
    "Mathematical Literacy",
    "Physical Sciences",
    "Life Sciences",
    "English (Home Language)",
    "English (First Additional Language)",
    "Afrikaans",
    "isiZulu",
    "isiXhosa",
    "Sesotho",
    "History",
    "Geography",
    "Accounting",
    "Business Studies",
    "Economics",
    "Life Orientation",
    "Agricultural Sciences",
    "Computer Applications Technology",
    "Information Technology",
    "Engineering Graphics and Design",
    "Visual Arts",
    "Dramatic Arts",
    "Music",
    "Consumer Studies",
    "Tourism",
    "Hospitality Studies",
  ];

  final List<String> interests = [
    "Technology",
    "Mathematics",
    "Sciences",
    "Arts & Design",
    "Business & Finance",
    "Health & Medicine",
    "Engineering",
    "Law & Justice",
    "Education & Training",
    "Media & Communication",
    "Sports & Fitness",
    "Environment & Nature",
    "Social Services",
    "Languages & Literature",
  ];

  double get progress => currentStep / totalSteps;

  void handleNext() {
    if (currentStep < totalSteps) {
      setState(() => currentStep++);
    } else {
      // Complete profile setup
      widget.onComplete(profile);

      // Navigate to DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => dashboard_page.DashboardScreen(
            userProfile: profile, // this is the UserProfile from data/profile/user_profile.dart
            onCourseSelect: (course) {},
            onNavigate: (screen) {},
          ),
        ),
      );

    }
  }

  bool canProceed() {
    switch (currentStep) {
      case 1:
        return profile.grade != null;
      case 2:
        return profile.subjects.isNotEmpty;
      case 3:
        return profile.interests.isNotEmpty;
      case 4:
        return profile.financialBackground != null;
      case 5:
        return profile.province != null;
      default:
        return false;
    }
  }

  Widget renderStep() {
    switch (currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What grade are you in?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<Grade>(
              value: profile.grade,
              hint: const Text("Select your grade"),
              isExpanded: true,
              onChanged: (Grade? value) {
                setState(() => profile.grade = value);
              },
              items: Grade.values.map((g) {
                return DropdownMenuItem(
                  value: g,
                  child: Text(g.displayName),
                );
              }).toList(),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select your subjects",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: subjects.map((subject) {
                final isSelected = profile.subjects.contains(subject);
                return ChoiceChip(
                  label: Text(subject),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        profile.subjects.remove(subject);
                      } else {
                        profile.subjects.add(subject);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What interests you?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                final isSelected = profile.interests.contains(interest);
                return ChoiceChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        profile.interests.remove(interest);
                      } else {
                        profile.interests.add(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 4:
        return FinancialStep(
          selectedBackground: profile.financialBackground,
          onSelect: (fb) {
            setState(() {
              profile.financialBackground = fb;
            });
          },
        );

      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Which province are you in?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<Province>(
              value: profile.province,
              hint: const Text("Select your province"),
              isExpanded: true,
              onChanged: (Province? value) {
                setState(() => profile.province = value);
              },
              items: Province.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.displayName),
                );
              }).toList(),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Step content
            Expanded(child: SingleChildScrollView(child: renderStep())),

            const SizedBox(height: 16),
            // Navigation buttons
            Row(
              children: [
                if (currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => currentStep--),
                      child: const Text("Back"),
                    ),
                  ),
                if (currentStep > 1) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canProceed() ? handleNext : null,
                    child: Text(
                        currentStep == totalSteps ? "Complete Setup" : "Next"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
