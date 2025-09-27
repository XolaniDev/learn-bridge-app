import 'dart:developer';
import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../utils/profile_setup_data.dart';
import '../../service/service.dart';
import '../../widgets/profile_widgets/financial_background_tiles.dart';
import '../dashboard/dashboard_page.dart' as dashboard_page;

class ProfileSetupPage extends StatefulWidget {
  final void Function(UserProfile profile) onComplete;

  const ProfileSetupPage({super.key, required this.onComplete});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final UserProfile profile = UserProfile(province: '');
  int currentStep = 1;
  final int totalSteps = 5;
  bool isLoading = false;

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

  Future<void> handleNext() async {
    if (currentStep < totalSteps) {
      setState(() => currentStep++);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Service().profileSetUp(
        province: profile.province ?? "",  // Send first element as string
        grade: profile.grade ?? "",
        interests: profile.interests,
        subjects: profile.subjects,
        financialBackground: profile.financialBackground?.displayName ?? "",
      );

      setState(() => isLoading = false);

      if (response.success) {
        final fetchedUser = await Service().getUserById();
        widget.onComplete(profile);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => dashboard_page.DashboardScreen(
              userProfile: fetchedUser,
              onCourseSelect: (course) {},
              onNavigate: (screen) {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
            DropdownButton<String>(
              value: profile.grade,
              hint: const Text("Select your grade"),
              isExpanded: true,
              onChanged: (value) {
                setState(() => profile.grade = value); // store as string
              },
              items: [
                "Grade 8",
                "Grade 9",
                "Grade 10",
                "Grade 11",
                "Grade 12",
              ].map((g) => DropdownMenuItem(
                value: g,
                child: Text(g),
              )).toList(),
            )
            ,
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
                  onSelected: (selected) {
                    setState(() {
                      profile.subjects = List<String>.from(profile.subjects);
                      if (selected) {
                        if (!profile.subjects.contains(subject)) {
                          profile.subjects.add(subject);
                        }
                      } else {
                        profile.subjects.remove(subject);
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
                  onSelected: (selected) {
                    setState(() {
                      profile.interests = List<String>.from(profile.interests);
                      if (selected) {
                        if (!profile.interests.contains(interest)) {
                          profile.interests.add(interest);
                        }
                      } else {
                        profile.interests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tell us about your financial background",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This will help us suggest relevant bursaries and funding opportunities.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FinancialStep(
              selectedBackground: profile.financialBackground,
              onSelect: (fb) =>
                  setState(() => profile.financialBackground = fb),
            ),
          ],
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
            DropdownButton<String>(
              value: provinces.contains(profile.province) ? profile.province : null,
              hint: const Text("Select your province"),
              isExpanded: true,
              onChanged: (String? value) {
                setState(() {
                  profile.province = value; // single String
                });
              },
              items: provinces.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p),
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
      appBar: AppBar(title: const Text("Profile Setup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Expanded(child: SingleChildScrollView(child: renderStep())),
            const SizedBox(height: 16),
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
                    onPressed: canProceed() && !isLoading ? handleNext : null,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            currentStep == totalSteps
                                ? "Complete Setup"
                                : "Next",
                          ),
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
