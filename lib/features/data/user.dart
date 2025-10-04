class User {
  final String id;
  final String name;
  final String surname;
  final String phoneNumber;
  final String createdDate;
  final String email;
  final List<String> roles;
  final List<String> roleFriendlyNames;


  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.createdDate,
    required this.email,
    required this.roles,
    required this.roleFriendlyNames,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'],
      createdDate: json['createdDate'],
      email: json['email'],
      roles: List<String>.from(json['roles']),
      roleFriendlyNames: List<String>.from(json['roleFriendlyNames']),

    );
  }

  String getFormattedRoles() {
    return roleFriendlyNames.join(' | ');
  }
}