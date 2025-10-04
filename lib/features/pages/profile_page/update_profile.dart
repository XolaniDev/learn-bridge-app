import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/data/user_response.dart';
import 'package:learn_bridge_v2/features/pages/profile_page/profile_page.dart';
import '../../data/profile/user_profile.dart';
import '../../utils/profile_setup_data.dart';
import '../../widgets/profile_widgets/financial_background_tiles.dart';
import '../../service/service.dart';
import '../dashboard/dashboard_page.dart';

class ProfileUpdatePage extends StatefulWidget {
  final UserResponse user;
  final VoidCallback onBack;

  const ProfileUpdatePage({
    super.key,
    required this.user,
    required this.onBack,
  });

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  late UserResponse profile;
  bool isLoading = false;

  String? _grade;
  String? _province;
  FinancialBackground? _finalBackground;
  List<String> selectedSubjects = [];
  List<String> selectedInterests = [];

  final List<String> grades = [
    "Grade 7",
    "Grade 8",
    "Grade 9",
    "Grade 10",
    "Grade 11",
    "Grade 12",
  ];

  final List<String> subjects = [
    "Mathematics",
    "Physical Sciences",
    "Life Sciences",
    "English (Home Language)",
    "Afrikaans",
    "History",
    "Geography",
    "Accounting",
    "Business Studies",
    "Economics",
    "Life Orientation",
    "Computer Applications Technology",
    "Information Technology",
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

  @override
  void initState() {
    super.initState();
    profile = UserResponse(
      id: widget.user.id,
      grade: widget.user.grade,
      province: widget.user.province,
      financialBackground: widget.user.financialBackground,
      subjects: List<String>.from(widget.user.subjects),
      interests: List<String>.from(widget.user.interests),
      name: '',
      surname: '',
      phoneNumber: '',
      createdDate: '',
      email: '',
      roleFriendlyNames: [], learnerNumber: '', changePassword: false,
    );

    _grade = profile.grade;
    _province = profile.province;
    _finalBackground = FinancialBackground.fromString(
      profile.financialBackground,
    );
    selectedSubjects = List.from(profile.subjects);
    selectedInterests = List.from(profile.interests);
  }

  Future<void> handleUpdate() async {
    setState(() => isLoading = true);

    try {
      final response = await Service().updateProfile(
        grade: _grade ?? "",
        province: _province ?? "",
        interests: selectedInterests,
        subjects: selectedSubjects,
        financialBackground: _finalBackground!.displayName,
      );

      setState(() => isLoading = false);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        final updatedProfile = await Service().getUserById();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userProfile: updatedProfile,
              onNavigate: (page) {},

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
      ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
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
              // --- Grade ---
              const Text(
                "Grade",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _grade,
                hint: const Text("Select your grade"),
                isExpanded: true,
                onChanged: (value) => setState(() => _grade = value),
                items: grades
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // --- Subjects ---
              const Text(
                "Select Subjects",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: subjects.map((subject) {
                  final selected = selectedSubjects.contains(subject);
                  return ChoiceChip(
                    label: Text(subject),
                    selected: selected,
                    onSelected: (sel) {
                      setState(() {
                        sel
                            ? selectedSubjects.add(subject)
                            : selectedSubjects.remove(subject);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // --- Interests ---
              const Text(
                "Select Interests",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) {
                  final selected = selectedInterests.contains(interest);
                  return ChoiceChip(
                    label: Text(interest),
                    selected: selected,
                    onSelected: (sel) {
                      setState(() {
                        sel
                            ? selectedInterests.add(interest)
                            : selectedInterests.remove(interest);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // --- Financial Background ---
              const Text(
                "Tell us your current finance state",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              FinancialStep(
                selectedBackground: _finalBackground,
                onSelect: (fb) => setState(() => _finalBackground = fb),
              ),
              const SizedBox(height: 16),

              // --- Province ---
              const Text(
                "Province",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _province,
                hint: const Text("Select your province"),
                isExpanded: true,
                onChanged: (value) => setState(() => _province = value),
                items: provinces
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
              ),
              const SizedBox(height: 32),

              // --- Update button ---
              ElevatedButton(
                onPressed: handleUpdate,
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
