import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../utils/profile_setup_data.dart';
import '../../service/service.dart';
import '../../widgets/profile_widgets/financial_background_tiles.dart';
import '../login/login_page.dart';

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
    "Mathematics", "Mathematical Literacy", "Physical Sciences", "Life Sciences", "Agricultural Sciences",
    "Accounting", "Business Studies", "Economics", "Geography", "History", "English Home Language", "English First Additional Language",
    "Afrikaans First Additional Language", "isiZulu First Additional Language", "isiXhosa First Additional Language", "Sesotho", "Life Orientation",
    "Information Technology (IT)", "Computer Applications Technology (CAT)", "Engineering Graphics and Design (EGD)", "Tourism",
    "Hospitality Studies", "Consumer Studies", "Visual Arts", "Dramatic Arts", "Music"
  ];

  final List<String> interests = [
    "Technology", "Science & Research", "Sciences", "Mathematics", "Business & Entrepreneurship",
    "Business & Finance", "Finance & Accounting", "Arts & Design", "Sports & Fitness", "Law & Justice",
    "Law & Politics", "Medicine & Health", "Health & Medicine", "Social Work & Community Development", "Social Services",
    "Engineering", "Engineering & Innovation", "Education & Training", "Teaching & Education", "Media & Communication",
    "Agriculture & Environment", "Environment & Nature", "Travel & Tourism", "Languages & Literature"
  ];

  double get progress => currentStep / totalSteps;

  FinancialBackground? get financialBackgroundEnum {
    if (profile.financialBackground == null) return null;
    try {
      return FinancialBackground.values.firstWhere(
            (fb) => fb.displayName == profile.financialBackground,
      );
    } catch (e) {
      return null;
    }
  }

  bool checkMismatch() {
    for (var subject in profile.subjects) {
      for (var interest in profile.interests) {
        if (subject.toLowerCase().contains(interest.toLowerCase()) ||
            interest.toLowerCase().contains(subject.toLowerCase())) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> showMismatchDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Mismatch Detected'),
        content: const Text(
          'Please note that the selected subjects and interests are not aligned.\n\n'
              'Do you want to proceed with hybrid recommendations or go back to fix your profile?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => currentStep = 2);
            },
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              handleProfileSubmit(); // continue
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> handleNext() async {
    if (currentStep == totalSteps) {
      if (checkMismatch()) {
        await showMismatchDialog();
        return;
      } else {
        await handleProfileSubmit();
        return;
      }
    }

    if (currentStep < totalSteps) {
      setState(() => currentStep++);
    }
  }

  Future<void> handleProfileSubmit() async {
    setState(() => isLoading = true);
    try {
      final response = await Service().profileSetUp(
        province: profile.province ?? "",
        grade: profile.grade ?? "",
        interests: profile.interests,
        subjects: profile.subjects,
        financialBackground: profile.financialBackground ?? "",
      );

      setState(() => isLoading = false);

      if (response.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthScreen(
              onNavigate: (screen) {},
              onAuthComplete: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
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
        return DropdownButton<String>(
          value: profile.grade,
          hint: const Text("Select your grade"),
          isExpanded: true,
          onChanged: (value) => setState(() => profile.grade = value),
          items: ["Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12"]
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
        );

      case 2:
        return buildChipSection(
          "Select your subjects",
          subjects,
          profile.subjects,
        );

      case 3:
        return buildChipSection(
          "What interests you?",
          interests,
          profile.interests,
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tell us about your financial background",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "This will help us suggest relevant bursaries and funding opportunities.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FinancialStep(
              selectedBackground: financialBackgroundEnum,
              onSelect: (fb) =>
                  setState(() => profile.financialBackground = fb.displayName),
            ),
          ],
        );

      case 5:
        return DropdownButton<String>(
          value: provinces.contains(profile.province) ? profile.province : null,
          hint: const Text("Select your province"),
          isExpanded: true,
          onChanged: (value) => setState(() => profile.province = value),
          items: provinces
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildChipSection(String title, List<String> items, List<String> selectedList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedList.contains(item);
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final newList = List<String>.from(selectedList);
                  if (selected) {
                    if (!newList.contains(item)) newList.add(item);
                  } else {
                    newList.remove(item);
                  }
                  if (items == subjects) {
                    profile.subjects = newList;
                  } else {
                    profile.interests = newList;
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
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
                        : Text(currentStep == totalSteps ? "Complete Setup" : "Next"),
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
