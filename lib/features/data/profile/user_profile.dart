import '../../utils/profile_setup_data.dart';

class UserProfile {
  String id;
  String name;
  String surname;
  String phoneNumber;
  String email;
  String? province;  // now single string
  String? grade;     // changed from enum to string
  List<String> interests;
  List<String> subjects;
  FinancialBackground? financialBackground;

  UserProfile({
    this.id = '',
    this.name = '',
    this.surname = '',
    this.phoneNumber = '',
    this.email = '',
    required this.province,
    this.grade,
    this.interests = const [],
    this.subjects = const [],
    this.financialBackground,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      province: json['province'] is List && json['province'].isNotEmpty
          ? json['province'][0] // take first if backend returns list
          : null,
      grade: json['grade']?.toString(),
      interests: List<String>.from(json['interests'] ?? []),
      subjects: List<String>.from(json['subjects'] ?? []),
      financialBackground: json['financialBackground'] != null
          ? FinancialBackground.values
          .cast<FinancialBackground?>()
          .firstWhere(
            (fb) => fb?.displayName == json['financialBackground'],
        orElse: () => null,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'email': email,
      'province': province != null ? [province!] : [],
      'grade': grade,
      'interests': interests,
      'subjects': subjects,
      'financialBackground': financialBackground?.displayName,
    };
  }
}
