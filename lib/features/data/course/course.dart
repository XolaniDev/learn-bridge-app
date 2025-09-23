// Your Course model
class Course {
  final String id;
  final String name;
  final String description;
  final List<String> requiredSubjects;
  final String university;
  final String duration;
  final String qualification;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredSubjects,
    required this.university,
    required this.duration,
    required this.qualification,
  });
}
