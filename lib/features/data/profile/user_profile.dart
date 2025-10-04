class UserProfile {
  String? id;
  String? name;
  String? surname;
  String? phoneNumber;
  String? email;
  String? province;
  String? grade;
  List<String> interests;
  List<String> subjects;
  String? financialBackground;

  UserProfile({
    this.id,
    this.name,
    this.surname,
    this.phoneNumber,
    this.email,
    this.province,
    this.grade,
    this.interests = const [],
    this.subjects = const [],
    this.financialBackground,
  });

  /// Converts JSON map to UserProfile object
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      province: json['province'] is List && json['province'].isNotEmpty
          ? json['province'][0].toString()
          : json['province']?.toString(),
      grade: json['grade']?.toString(),
      interests: List<String>.from(json['interests'] ?? []),
      subjects: List<String>.from(json['subjects'] ?? []),
      financialBackground: json['financialBackground']?.toString(),
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
      'financialBackground': financialBackground, // 👈 string
    };
  }
}
