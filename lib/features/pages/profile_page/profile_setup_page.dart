import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';
import '../../utils/profile_setup_data.dart';
import '../../service/service.dart';
import '../../widgets/profile_widgets/financial_background_tiles.dart';
import '../../widgets/profile_widgets/select_card_widget.dart';
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
    "Mathematics",
    "Mathematical Literacy",
    "Physical Sciences",
    "Life Sciences",
    "Agricultural Sciences",
    "Accounting",
    "Business Studies",
    "Economics",
    "Geography",
    "History",
    "English Home Language",
    "English First Additional Language",
    "Afrikaans First Additional Language",
    "isiZulu First Additional Language",
    "isiXhosa First Additional Language",
    "Sesotho",
    "Life Orientation",
    "Information Technology (IT)",
    "Computer Applications Technology (CAT)",
    "Engineering Graphics and Design (EGD)",
    "Tourism",
    "Hospitality Studies",
    "Consumer Studies",
    "Visual Arts",
    "Dramatic Arts",
    "Music"
  ];

  final List<String> interests = [
    "Technology",
    "Science & Research",
    "Sciences",
    "Mathematics",
    "Business & Entrepreneurship",
    "Business & Finance",
    "Finance & Accounting",
    "Arts & Design",
    "Sports & Fitness",
    "Law & Justice",
    "Law & Politics",
    "Medicine & Health",
    "Health & Medicine",
    "Social Work & Community Development",
    "Social Services",
    "Engineering",
    "Engineering & Innovation",
    "Education & Training",
    "Teaching & Education",
    "Media & Communication",
    "Agriculture & Environment",
    "Environment & Nature",
    "Travel & Tourism",
    "Languages & Literature"
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
      barrierDismissible: false, // prevent dismissal by tapping outside
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orangeAccent),
              const SizedBox(height: 16),
              const Text(
                'Mismatch Detected',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Please note that the selected subjects and interests are not aligned.\n\n'
                    'Do you want to proceed with hybrid recommendations or go back to fix your profile?',
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => currentStep = 2);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        side: const BorderSide(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        handleProfileSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Material(
            elevation: 2,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: profile.grade,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Select your grade',
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                isExpanded: true,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                onChanged: (value) {
                  setState(() => profile.grade = value);
                },
                items: ["Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12"]
                    .map(
                      (g) => DropdownMenuItem(
                    value: g,
                    child: Text(
                      g,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        );

      case 2:
        return buildCardSelection("Select your subjects", subjects, profile.subjects);

      case 3:
        return buildCardSelection("What interests you?", interests, profile.interests);

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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Material(
            elevation: 2,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField<String>(
                value: provinces.contains(profile.province) ? profile.province : null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Select your province',
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                isExpanded: true,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                onChanged: (value) {
                  setState(() => profile.province = value);
                },
                items: provinces.map(
                      (p) => DropdownMenuItem(
                    value: p,
                    child: Text(
                      p,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ).toList(),
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildCardSelection(String title, List<String> options, List<String> selectedList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: options.map((option) {
            final isSelected = selectedList.contains(option);
            return MultiSelectCard(
              label: option,
              selected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedList.remove(option);
                  } else {
                    selectedList.add(option);
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
    final themeColor = Colors.blueAccent;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: themeColor,
              child: Column(
                children: const [
                  Icon(Icons.person_add_alt_1, color: Colors.white, size: 64),
                  SizedBox(height: 8),
                  Text(
                    'LearnBridge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Complete your profile setup',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      color: themeColor,
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: SingleChildScrollView(child: renderStep())),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (currentStep > 1)
                          Expanded(
                            child: Material(
                              borderRadius: BorderRadius.circular(14),
                              elevation: 1,
                              shadowColor: Colors.black26,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => setState(() => currentStep--),
                                splashColor: Colors.blue.withOpacity(0.2),
                                highlightColor: Colors.blue.withOpacity(0.1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10), // reduced
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: const Text(
                                    "Back",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (currentStep > 1) const SizedBox(width: 12),
                        Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(14),
                            elevation: canProceed() && !isLoading ? 4 : 1,
                            shadowColor: Colors.black26,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: canProceed() && !isLoading ? handleNext : null,
                              splashColor: Colors.blue.withOpacity(0.2),
                              highlightColor: Colors.blue.withOpacity(0.1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10), // reduced
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: canProceed() && !isLoading ? themeColor : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(14),
                                ),
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
                                  currentStep == totalSteps ? "Complete Setup" : "Next",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
