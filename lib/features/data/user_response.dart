class UserResponse {

  final String id;
  final String name;
  final String surname;
  final String phoneNumber;
  final String createdDate;
  final String email;
  final String province;
  final String grade;
  final List<String> interests;
  final List<String> subjects;
  final String financialBackground;
  final List<String> roleFriendlyNames;


  UserResponse({

    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.createdDate,
    required this.email,
    required this.province,
    required this.grade,
    required this.interests,
    required this.subjects,
    required this.financialBackground,
    required this.roleFriendlyNames,
  });

  // Factory method to create a MessageResponse from JSON
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      name: json['name'],
      surname:json['surname'],
      phoneNumber:json['phoneNumber'],
      createdDate:json['createdDate'],
      email: json['email'],
      province: json['province'],
      grade: json['grade'],
      interests:  List<String>.from(json['interests']),
      subjects: List<String>.from(json['subjects']),
      financialBackground: json['financialBackground'],
      roleFriendlyNames: List<String>.from(json['roleFriendlyNames']),
    );
  }
}

